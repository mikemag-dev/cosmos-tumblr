import Foundation
import Dependencies

public struct TumblrClient {
    typealias GetPosts = (GetPostsRequest) async throws -> GetPostsResponse
    
    let baseURL: () -> URL
    let getPosts: GetPosts

    init(
        baseURL: @escaping () -> URL = { fatalError("TumblrClient baseURL not set") },
        getPosts: @escaping GetPosts
    ) {
        self.baseURL = baseURL
        self.getPosts = getPosts
    }
}

public extension DependencyValues {
    var tumblrClient: TumblrClient {
        get { self[TumblrClient.self] }
        set { self[TumblrClient.self] = newValue }
    }
}
