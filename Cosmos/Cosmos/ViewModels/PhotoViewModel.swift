import Foundation
import Kingfisher

//TODO: limit prefetchers

class PhotoViewModel: Identifiable {
    private let photo: Photo
    private let originalUrl: URL
    var id: String { originalUrl.absoluteString }
    var prefetchTask: Task<Void, Never>?
    //TODO: consider moving this to PhotosViewModel to limit concurrent prefetches
    private var imagePrefetcher: ImagePrefetcher?
    
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
    
    enum State {
        case prefetching
        case prefetchComplete
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
        prefetchTask?.cancel()
        imagePrefetcher?.stop()
        prefetchTask = Task {
            // delay so that we only refresh if user is paused on screen
            // 1s is probably better, but using 2s for demo purposes
            try? await Task.sleep(for: .seconds(2))
            guard let isCancelled = prefetchTask?.isCancelled, !isCancelled else { return }
            // TODO: demo purposes only
            //            print("prefetching image \(originalUrl)")
            imagePrefetcher = ImagePrefetcher(urls: [originalUrl])
            imagePrefetcher?.start()
        }
    }
    
    private func cancelPrefetch() {
        prefetchTask?.cancel()
        imagePrefetcher?.stop()
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
