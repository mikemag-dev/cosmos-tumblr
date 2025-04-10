import Foundation

class TumblrDataProvider: TumblrDataProvidable {
    private let apiKey: String = Secrets.tumblrApiKey
    private let baseURL = URL(string: "https://api.tumblr.com/v2")!
    private let networkClient = NetworkClient(decoder: .tumblr)

    func getPosts(blogId: String) async throws -> GetPostsResponse {
        let path = "/blog/\(blogId)/posts"
        let url = baseURL.appendingPathComponent(path)

        let queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]

        return try await networkClient.fetch(
            url: url,
            method: .get,
            queryItems: queryItems
        )
    }
}


