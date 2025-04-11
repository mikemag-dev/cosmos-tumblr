import Testing // Import the new testing framework
import Foundation // Needed for Bundle, Data, URL, JSONDecoder, DateFormatter
@testable import Cosmos // Import your module where the models are defined

struct PhotoViewModelTests {

    @Test func testTumblrResponseDecodingFromFile() async throws {
        
        let photo = Photo(
            caption: nil,
            originalSize: .init(
                url: URL(string: "https://cosmos.com/1000.jpg")!,
                width: 1000,
                height: 1000
            ),
            altSizes: [
                .init(
                    url: URL(string: "https://cosmos.com/300.jpg")!,
                    width: 300,
                    height: 300
                ),
                .init(
                    url: URL(string: "https://cosmos.com/200.jpg")!,
                    width: 200,
                    height: 200
                ),
                .init(
                    url: URL(string: "https://cosmos.com/100.jpg")!,
                    width: 100,
                    height: 100
                ),
            ]
        )
        
        let viewModel = PhotoViewModel(photo: photo)
        
        #expect(viewModel.getThumbnailURL(forIntentSize: .init(width: 100, height: 100)) == URL(string: "https://cosmos.com/100.jpg"))
        #expect(viewModel.getThumbnailURL(forIntentSize: .init(width: 101, height: 101)) == URL(string: "https://cosmos.com/200.jpg"))
        #expect(viewModel.getThumbnailURL(forIntentSize: .init(width: 101, height: 301)) == URL(string: "https://cosmos.com/1000.jpg"))
    }
}
