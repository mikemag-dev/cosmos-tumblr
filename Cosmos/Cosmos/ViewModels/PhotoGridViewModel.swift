import Foundation
import Combine
import Dependencies

@MainActor
@Observable
class PhotoGridViewModel {
    @ObservationIgnored @Dependency(\.tumblrClient) private var tumblrClient
    @ObservationIgnored @Dependency(\.router) private var router
    
    static let pageSize = 20
    
    let paginator: Paginator<GetPostsResponse>
    private(set) var photoViewModels: [PhotoViewModel] = []
    private(set) var photoViewModels3Columns: [[PhotoViewModel]] = []
    private let blogId: String
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var state: State = .loaded {
        didSet {
            print("\(Self.self) state changed \(oldValue) \(state)")
        }
    }
    // MARK: - Initialization
    
    init(blogId: String) {
        self.blogId = blogId
        self.paginator = Paginator(pageSize: Self.pageSize) { offset async throws in
            let request = GetPostsRequest(blogId: blogId, type: .photo, offset: offset, pageSize: Self.pageSize)
            @Dependency(\.tumblrClient) var tumblrClient
            return try await tumblrClient.getPosts(request)
        }
        setUpPaginationStream()
    }
    
    // MARK: - State Machine
    
    enum Event: CustomDebugStringConvertible {
        case scrolledToBottom
        case layoutUpdated(minPhotos: Int)
        case selectedPhoto(photo: PhotoViewModel)
        
        var debugDescription: String {
            switch self {
            case .scrolledToBottom:
                return "scrolledToBottom"
            case .layoutUpdated(let minPhotos):
                return "layoutUpdated \(minPhotos)"
            case .selectedPhoto(let photoViewModel):
                return "selectedPhoto: \(photoViewModel.getThumbnailURL(forIntentSize: .init(width: .max, height: .max))?.absoluteString ?? "no url")"
            }
        }
    }
    
    enum State: CustomDebugStringConvertible {
        case loading
        case loaded
        case error(String)
        
        var debugDescription: String {
            switch self {
            case .loading:
                return "Loading"
            case .loaded:
                return "Loaded"
            case .error(let message):
                return "Error: \(message)"
            }
        }
    }
    
    public func send(_ event: Event) {
        print("\(Self.self) event received \(event)")
        switch event {
        case .scrolledToBottom:
            paginator.tryFetchMore()
        case .selectedPhoto(let photoViewModel):
            router.path.append((.photo(photoViewModel: photoViewModel)))
        case .layoutUpdated(let minPhotos):
            batchFetchPhotos(minPhotos: minPhotos)
        }
    }
    
    // MARK: - Private Helper Methods
    private func setUpPaginationStream() {
        paginator.datasPublisher
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .data(let response):
                    self.handleNewData(responses: [response])
                case .datas(let responses):
                    self.handleNewData(responses: responses)
                case .error(let error):
                    self.state = .error("Failed to load posts: \(error.localizedDescription)")
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleNewData(responses: [GetPostsResponse]) {
        photoViewModels += responses.reduce(into: [PhotoViewModel]()) { partialResult, response in
            let photoViewModels = extractPhotoViewModels(from: response.response.posts)
            partialResult += photoViewModels
        }
        self.photoViewModels3Columns = deriveGrid(photoViewModels: photoViewModels)
    }
    
    private func batchFetchPhotos(minPhotos: Int) {
        let photosNeeded = minPhotos - photoViewModels.count
        let pagesNeeded = photosNeeded / Self.pageSize + 1
        paginator.tryBatchFetch(numPages: pagesNeeded)
    }
    
    private func deriveGrid(photoViewModels: [PhotoViewModel]) -> [[PhotoViewModel]] {
        var photoGridViewModels: [[PhotoViewModel]] = [[],[],[]]
        let size = CGSize(width: 120, height: 120)
        var columnHeights = [CGFloat](repeating: 0, count: 3)
        for photoViewModel in photoViewModels {
            let width = CGFloat(photoViewModel.originalSize.width)
            let height = CGFloat(photoViewModel.originalSize.height)
            let minHeight = columnHeights.min()!
            let nextColumn = columnHeights.firstIndex(of: minHeight)!
            if height > width {
                columnHeights[nextColumn] += size.height
                photoGridViewModels[nextColumn].append(photoViewModel)
            } else {
                let aspectRatio = width / height
                let height = size.height / aspectRatio
                columnHeights[nextColumn] += height
                photoGridViewModels[nextColumn].append(photoViewModel)
            }
        }
        print("mmm columnHeights: \(columnHeights)")
        print("mmm photoCounts: \(photoGridViewModels.map { $0.count })")
        return photoGridViewModels
    }
    
    private func extractPhotoViewModels(from posts: [Post]) -> [PhotoViewModel] {
        posts.reduce(into: [PhotoViewModel]()) { partialResult, post in
            partialResult.append(contentsOf: post.photos?.compactMap(PhotoViewModel.init(photo:)) ?? [])
        }
    }
}
