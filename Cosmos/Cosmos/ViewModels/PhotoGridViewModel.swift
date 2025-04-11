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
            case .selectedPhoto(let photo):
                return "selectedPhoto: \(photo.photo.originalSize?.url.absoluteString ?? "no url")"
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
            let photosNeeded = minPhotos - photoViewModels.count
            let pagesNeeded = photosNeeded / Self.pageSize + 1
            paginator.tryBatchFetch(numPages: pagesNeeded)
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
    }
    
    private func fetchPhotos(offset: Int, pageSize: Int) async {
        if case .loading = state {
            print("Already loading posts, ignoring fetch request.")
            return
        }
        print("Fetching posts for blog ID: \(blogId)...")
        photoViewModels = []
        state = .loading
        
        let request = GetPostsRequest(blogId: blogId, type: .photo, offset: offset, pageSize: pageSize)
        
        do {
            print("fetching posts")
            let posts = try await tumblrClient.getPosts(request).response.posts
            print("Successfully fetched \(posts.count) posts.")
            
            let extractPhotos = extractPhotoViewModels(from: posts)
            print("Extracted \(extractPhotos.count) image URLs.")
            
            self.photoViewModels = extractPhotos
            self.state = .loaded
            
        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
        }
    }
    
    private func extractPhotoViewModels(from posts: [Post]) -> [PhotoViewModel] {
        posts.reduce(into: [PhotoViewModel]()) { partialResult, post in
            partialResult.append(contentsOf: post.photos?.compactMap(PhotoViewModel.init(photo:)) ?? [])
        }
    }
}
