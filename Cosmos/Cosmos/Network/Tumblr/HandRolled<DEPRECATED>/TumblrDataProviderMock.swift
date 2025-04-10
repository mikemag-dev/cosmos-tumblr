import Foundation

class TumblrDataProviderMock: TumblrDataProvidable {
    var shouldSucceed: Bool = true

    func getPosts(blogId: String) async throws -> GetPostsResponse {
        let fileURL = Bundle.main.url(forResource: "GetPostsResponse", withExtension: "json")!
        let jsonData = try Data(contentsOf: fileURL)
        let response = try JSONDecoder().decode(GetPostsResponse.self, from: jsonData)
        
        try? await Task.sleep(for: .seconds(2))

        if shouldSucceed {
            print("Mock: Returning successful response for blogId: \(blogId)")
            return response
        } else {
            print("Mock: Throwing simulation error for blogId: \(blogId)")
            throw MockError.simulationError
        }
    }
}
