import Foundation
import Kingfisher

//TODO: limit prefetchers

class PhotoViewModel: Identifiable {
    private let photo: Photo
    private let originalUrl: URL
    var id: String { originalUrl.absoluteString }
    var state: State = .idle {
        didSet {
            print("\(Self.self) \(oldValue) -> \(state)")
        }
    }
    
    init?(photo: Photo) {
        guard let originalSizeUrl = photo.originalSize?.url else {
            return nil
        }
        self.photo = photo
        self.originalUrl = originalSizeUrl
    }
    
    func getThumbnailURL(forIntentSize intentSize: CGSize) -> URL? {
        // TODO: remove test code
        // comment this in for testing what (2nd) smallest thumbnail looks like during demo
        //        if let altSizes = photo.altSizes, altSizes.count > 1 {
        //            return altSizes[altSizes.count-2].url
        //        }
        //TODO: could do binary search for improvement if many alt sizes
        //TODO: add network speed test decision making
        // alt sizes are ordered greatest to least size, last alt is a square 75x75
        let photoSize = photo.altSizes?.last(where: { photoSize in
            CGFloat(photoSize.width) >= intentSize.width && CGFloat(photoSize.height) >= intentSize.height
        }) ?? photo.originalSize
        guard let photoSize = photoSize else {
            print("no photo size found for \(photo)")
            return nil
        }
        //                print("loaded photo size: \(photoSize.width)x\(photoSize.height) into \(intentSize.width)x\(intentSize.height)")
        return photoSize.url
    }
    
    // MARK: - State Machine
    
    enum State: CustomDebugStringConvertible {
        case idle
        case waitingToPrefetch(prefetchTask: Task<Void, Never>)
        case prefetching(imagePrefetcher: ImagePrefetcher)
        
        var debugDescription: String {
            switch self {
            case .idle:
                return "Idle"
            case .waitingToPrefetch(let task):
                return "Waiting to Prefetch \(task.hashValue)"
            case .prefetching(let prefetcher):
                return "Prefetching \(prefetcher.description)"
            }
        }
    }
    
    enum Event {
        case imageScrolledIn
        case imageScrolledOut
    }
    
    func send(_ event: Event) {
        //        print("\(Self.self) event received \(event)")
        switch event {
        case .imageScrolledIn:
            delayedPreFetch()
        case .imageScrolledOut:
            cancelPrefetch()
        }
    }
    
    // MARK: - Private Helper Methods
    
    private func delayedPreFetch() {
        cancelPrefetch()
        let task = Task {
            // delay so that we only refresh if user is paused on screen
            // 1s is probably better, but using 2s for demo purposes
            try? await Task.sleep(for: .seconds(2))
            if Task.isCancelled {
                return
            }
            let imagePrefetcher = ImagePrefetcher(urls: [originalUrl])
            state = .prefetching(imagePrefetcher: imagePrefetcher)
            imagePrefetcher.start()
        }
        state = .waitingToPrefetch(prefetchTask: task)
    }
    
    private func cancelPrefetch() {
        switch state {
        case .idle:
            break
        case .waitingToPrefetch(let task):
            task.cancel()
            state = .idle
        case .prefetching(let prefetcher):
            prefetcher.stop()
            state = .idle
        }
    }
}

// MARK: - Equatable and Hashable Conformance

extension PhotoViewModel: Equatable, Hashable  {
    
    
    static func == (lhs: PhotoViewModel, rhs: PhotoViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
