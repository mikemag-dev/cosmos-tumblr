import Foundation
import Dependencies

public struct TumblrClient {
    typealias GetPostsForBlogId = (String) async throws -> GetPostsResponse
    
    let baseURL: () -> URL
    let getPostsForBlogId: GetPostsForBlogId

    init(
        baseURL: @escaping () -> URL = { fatalError("TumblrClient baseURL not set") },
        getPostsForBlogId: @escaping GetPostsForBlogId
    ) {
        self.baseURL = baseURL
        self.getPostsForBlogId = getPostsForBlogId
    }
}

public extension DependencyValues {
    var tumblrClient: TumblrClient {
        get { self[TumblrClient.self] }
        set { self[TumblrClient.self] = newValue }
    }
}
