import Testing // Import the new testing framework
import Foundation // Needed for Bundle, Data, URL, JSONDecoder, DateFormatter
@testable import Cosmos // Import your module where the models are defined

struct PhotoViewModelTests {
    
    var viewModel: PhotoViewModel {
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
        return PhotoViewModel(photo: photo)!
    }
    
    @Test("Get Thumbnail Url")
    func testGetThumbnailUrl() async throws {
        #expect(viewModel.getThumbnailURL(forIntentSize: .init(width: 100, height: 100)) == URL(string: "https://cosmos.com/100.jpg"))
        #expect(viewModel.getThumbnailURL(forIntentSize: .init(width: 101, height: 101)) == URL(string: "https://cosmos.com/200.jpg"))
        #expect(viewModel.getThumbnailURL(forIntentSize: .init(width: 101, height: 301)) == URL(string: "https://cosmos.com/1000.jpg"))
    }
    
    @Test("Initial State")
    func testInitialState() async throws {
        let viewModel = viewModel
        switch viewModel.state {
        case .idle:
            break
        default:
            #expect(Bool(false), "ViewModel should initialize in the .idle state, but was \(viewModel.state.debugDescription)")
        }
    }
    
    @Test("Initial State To Immediate Prefetch")
    func testInitialStateToImmediatePrefetch() async throws {
        let viewModel = viewModel
        viewModel.send(.imageScrolledIn)

        switch viewModel.state {
        case .waitingToPrefetch(let task):
            #expect(!task.isCancelled, "The associated prefetch task should not be cancelled immediately after creation.")
        default:
            #expect(Bool(false), "Expected state .waitingToPrefetch after sending .imageScrolledIn, but got \(viewModel.state.debugDescription)")
        }
    }
    
    @Test("Send Scrolled Transitions Happy Path")
    func testSendScrolledTransitionsHappyPath() async throws {
        let viewModel = viewModel
        viewModel.send(.imageScrolledIn)
        
        // wait for prefetch to start
        try await Task.sleep(for: .seconds(2.5))
        
        switch viewModel.state {
        case .prefetching:
            break
        default:
            #expect(Bool(false), "Expected state .waitingToPrefetch after sending .imageScrolledIn, but got \(viewModel.state.debugDescription)")
        }
        
        viewModel.send(.imageScrolledOut)

        switch viewModel.state {
        case .idle:
            break
        default:
            #expect(Bool(false), "ViewModel should return to .idle state after cancelPrefetch, but was \(viewModel.state.debugDescription)")
        }
    }
    
    @Test("Send Scrolled Transitions Cancel Early")
    func testSendScrolledTransitionsCancelEarly() async throws {
        viewModel.send(.imageScrolledIn)
        try await Task.sleep(for: .seconds(1))
        viewModel.send(.imageScrolledOut)

        switch viewModel.state {
        case .idle:
            break
        default:
            #expect(Bool(false), "Expected state .waitingToPrefetch after sending .imageScrolledIn, but got \(viewModel.state.debugDescription)")
        }
    }
}
