import Testing // Import the new testing framework
import Foundation // Needed for Bundle, Data, URL, JSONDecoder, DateFormatter
@testable import Cosmos // Import your module where the models are defined

private class Context {}

struct TumblrModelDecodingTests {

    @Test func testTumblrResponseDecodingFromFile() async throws {
        // --- 1. Load JSON Data from File ---
        // Get the URL for the JSON file within the test bundle.
        // NOTE: Assumes GetPostsResponse.json is added to the test target's resources.
        // `Bundle.module` works for Swift Packages. Adjust if using a different setup
        // (e.g., `Bundle(for: Self.self)` might be needed in an Xcode project).
        let fileURL = try #require(Bundle(for: Context.self).url(forResource: "GetPostsResponseRaw", withExtension: "json"))

        // Load the data from the file URL.
        let jsonData = try #require(try Data(contentsOf: fileURL))

        // --- 2. Configure JSON Decoder ---
        let decoder = JSONDecoder.tumblr

        // --- 3. Decode JSON Data ---
        // Attempt to decode the JSON data into the top-level model.
        // #require will fail the test immediately if decoding throws an error.
        let apiResponse = try #require(try decoder.decode(GetPostsResponse.self, from: jsonData))

        // --- 4. Assertions ---
        // Verify key properties of the decoded objects match expected values.
        #expect(apiResponse.meta.status == 200)
        #expect(apiResponse.meta.msg == "OK")

        let responseData = apiResponse.response
        #expect(responseData.totalPosts == 935)
        #expect(!responseData.posts.isEmpty) // Check that posts array is not empty
    }
}
