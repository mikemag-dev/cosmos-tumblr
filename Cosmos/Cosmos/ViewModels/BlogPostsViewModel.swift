import Foundation
import Combine

@MainActor
@Observable
class BlogPostsViewModel {

    enum Action {
        case fetchPosts
    }
    
    enum State {
        case loading
        case loaded
        case error(String)
    }
    
    // MARK: - Properties

    private let dataProvider: TumblrDataProvidable

    private(set) var imageURLs: [URL] = []
    private(set) var state: State = .loaded
    private let blogId: String

    // MARK: - Initialization

    init(blogId: String, dataProvider: TumblrDataProvidable = TumblrDataProvider()) {
        self.dataProvider = dataProvider
        self.blogId = blogId
        Task {
            await send(action: .fetchPosts)
        }
    }

    // MARK: - Public Methods
    public func send(action: Action) async {
        switch action {
        case .fetchPosts:
            await fetchPosts()
        }
    }

    // MARK: - Private Helper Methods
    private func fetchPosts() async {
        if case .loading = state {
            print("Already loading posts, ignoring fetch request.")
            return
        }
        print("Fetching posts for blog ID: \(blogId)...")
        imageURLs = []
        state = .loading

        do {
            print("fetching posts")
            let posts = try await dataProvider.getPosts(blogId: blogId).response.posts
            print("Successfully fetched \(posts.count) posts.")

            let extractedURLs = extractImageURLs(from: posts)
            print("Extracted \(extractedURLs.count) image URLs.")

            self.imageURLs = extractedURLs
            self.state = .loaded

        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
            self.state = .error("Failed to load posts: \(error.localizedDescription)")
        }
    }
    
    private func extractImageURLs(from posts: [Post]) -> [URL] {
        var urls: [URL] = []

        for post in posts {
            var imageURLString: String? = nil

            if let firstPhotoURL = post.photos?.first?.originalSize?.url {
                imageURLString = firstPhotoURL
            } else if let linkImageURL = post.linkImage {
                imageURLString = linkImageURL
            }

            if let urlString = imageURLString, let url = URL(string: urlString) {
                urls.append(url)
            } else if let urlString = imageURLString {
                 print("Warning: Could not create URL from string: \(urlString)")
            }
        }
        return urls
    }
}
