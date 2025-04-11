import Foundation
import Combine
import Dependencies

@MainActor
@Observable
class BlogPostsViewModel {
    @ObservationIgnored @Dependency(\.tumblrClient) private var tumblrClient
    @ObservationIgnored @Dependency(\.router) private var router

    enum Action {
        case fetchPosts
        case selectedPhoto(photo: PhotoViewModel)
    }
    
    enum State {
        case loading
        case loaded
        case error(String)
    }

    private(set) var photoViewModels: [PhotoViewModel] = []
    private(set) var state: State = .loaded
    private let blogId: String

    // MARK: - Initialization

    nonisolated
    init(blogId: String) {
        self.blogId = blogId
        Task {
            await send(action: .fetchPosts)
        }
    }

    // MARK: - Public Methods
    public func send(action: Action) {
        switch action {
        case .fetchPosts:
            Task {
                await fetchPosts()
            }
        case .selectedPhoto(let photoViewModel):
            router.path.append((.photo(photoViewModel: photoViewModel)))
        }
    }

    // MARK: - Private Helper Methods
    private func fetchPosts() async {
        if case .loading = state {
            print("Already loading posts, ignoring fetch request.")
            return
        }
        print("Fetching posts for blog ID: \(blogId)...")
        photoViewModels = []
        state = .loading

        do {
            print("fetching posts")
            let posts = try await tumblrClient.getPhotosForBlogId(blogId).response.posts
            print("Successfully fetched \(posts.count) posts.")

            let extractPhotos = extractPhotos(from: posts)
            print("Extracted \(extractPhotos.count) image URLs.")

            self.photoViewModels = extractPhotos
            self.state = .loaded

        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
            self.state = .error("Failed to load posts: \(error.localizedDescription)")
        }
    }
    
    private func extractPhotos(from posts: [Post]) -> [PhotoViewModel] {
        posts.reduce(into: [PhotoViewModel]()) { partialResult, post in
            partialResult.append(contentsOf: post.photos?.compactMap(PhotoViewModel.init(photo:)) ?? [])
        }
    }
}
