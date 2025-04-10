import Foundation
import Dependencies

extension TumblrClient: DependencyKey {
    
    public static let liveValue: TumblrClient = {
        let apiKey = Secrets.tumblrApiKey
        let networkClient = NetworkClient(decoder: JSONDecoder.tumblr)
        
        func baseURL() -> URL {
            URL(string: "https://api.tumblr.com/v2")!
        }
        
        func getPostsForBlogId(_ blogId: String) async throws -> GetPostsResponse {
            let path = "/blog/\(blogId)/posts"
            let url = baseURL().appendingPathComponent(path)

            let queryItems = [
                URLQueryItem(name: "api_key", value: apiKey)
            ]

            return try await networkClient.fetch(
                url: url,
                method: .get,
                queryItems: queryItems
            )
        }
        
        return .init(
            baseURL: baseURL,
            getPostsForBlogId: getPostsForBlogId
        )
    }()
}
