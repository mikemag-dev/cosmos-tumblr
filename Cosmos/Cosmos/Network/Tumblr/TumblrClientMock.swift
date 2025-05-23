import Foundation
import Dependencies

private class Context {}

extension TumblrClient: TestDependencyKey {
    
    public static let previewValue: TumblrClient = {
        var shouldSucceed: Bool = true

        func getPosts(_ request: GetPostsRequest) async throws -> GetPostsResponse {
            let fileURL = Bundle(for: Context.self).url(forResource: "GetPostsResponseMock", withExtension: "json")!
            let jsonData = try Data(contentsOf: fileURL)
            let response = try JSONDecoder.tumblr.decode(GetPostsResponse.self, from: jsonData)
            
//            try? await Task.sleep(for: .seconds(2))

            if shouldSucceed {
                print("Mock: Returning successful response for blogId: \(request.blogId)")
                return response
            } else {
                print("Mock: Throwing simulation error for blogId: \(request.blogId)")
                throw MockError.simulationError
            }
        }
        
        return .init(
            getPosts: getPosts
        )
    }()
}
