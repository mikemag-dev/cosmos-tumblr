import Foundation
import Dependencies

extension TumblrClient: DependencyKey {
    
    public static let liveValue: TumblrClient = {
        let apiKey = Secrets.tumblrApiKey
        let networkClient = NetworkClient(decoder: JSONDecoder.tumblr)
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        func baseURL() -> URL {
            URL(string: "https://api.tumblr.com/v2")!
        }
        
        func getPosts(_ request: GetPostsRequest) async throws -> GetPostsResponse {
            let path = "/blog/\(request.blogId)/posts"
            let url = baseURL().appendingPathComponent(path)

            var queryItems = queryItems
            queryItems.append(.init(name: "type", value: request.type.rawValue))
            queryItems.append(.init(name: "limit", value: "\(request.pageSize)"))
            queryItems.append(.init(name: "offset", value: "\(request.offset)"))

            return try await networkClient.fetch(
                url: url,
                method: .get,
                queryItems: queryItems
            )
        }
        
        return .init(
            baseURL: baseURL,
            getPosts: getPosts
        )
    }()
}
