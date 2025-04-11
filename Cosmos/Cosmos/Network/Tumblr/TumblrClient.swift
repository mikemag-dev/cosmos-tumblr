import Foundation
import Dependencies

public struct TumblrClient {
    typealias GetPhotosForBlogId = (String) async throws -> GetPostsResponse
    
    let baseURL: () -> URL
    let getPhotosForBlogId: GetPhotosForBlogId

    init(
        baseURL: @escaping () -> URL = { fatalError("TumblrClient baseURL not set") },
        getPhotosForBlogId: @escaping GetPhotosForBlogId
    ) {
        self.baseURL = baseURL
        self.getPhotosForBlogId = getPhotosForBlogId
    }
}

public extension DependencyValues {
    var tumblrClient: TumblrClient {
        get { self[TumblrClient.self] }
        set { self[TumblrClient.self] = newValue }
    }
}
