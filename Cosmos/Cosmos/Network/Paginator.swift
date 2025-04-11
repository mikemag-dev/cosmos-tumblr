import Foundation
import Combine

protocol PageableResponse<T> {
    associatedtype T
    var data: T { get }
    var total: Int { get }
}

typealias AsyncPagedFetch<T> = (_ offset: Int) async throws -> any PageableResponse<T>

// this class is definitely over-engineered for the project's scope,
// but I want to demonstrate what I'm imagining for a more reusable paginator as the app might scale

struct PaginationError: Error, Equatable {
    init(error: any Error) {
        self.message = error.localizedDescription
    }
    
    init(message: String) {
        self.message = message
    }
    
    var message: String
}

/// a reusable, abstract paginator capable of fetching a pageable API until completion
class Paginator<Data>: ObservableObject {
    enum State: Equatable {
        case unloaded
        case loadedComplete
        case loadedHasMore
        case loading
        case error(error: PaginationError)
    }
    
    enum StreamEvent {
        case data(Data)
        case error(PaginationError)
    }
    
    private let minWaitDurationAfterError: TimeInterval = 2.0
    private var lastErrorTime: TimeInterval? = nil
    
    //use this if you want to self-consume paged data
    private let datasSubject = PassthroughSubject<StreamEvent, Never>()
    public var datasPublisher: AnyPublisher<StreamEvent, Never> { datasSubject.eraseToAnyPublisher() }
    
    //use this if you want to use Paginator-managed data (might be less optimizable/efficient in certain scenarios where results are shared)
    @Published public private(set) var datas = [Data]()
    @Published public private(set) var state: State = .unloaded

    /// do not use directly, only exposed for testing
    public private(set) var lastSuccessfullyFetchedPage: Int?
    private let pageSize: Int
    private let fetch: AsyncPagedFetch<Data>

    init(pageSize: Int, fetch: @escaping AsyncPagedFetch<Data>) {
        self.pageSize = pageSize
        self.fetch = fetch
    }
    
    private var canFetch: Bool {
        if let lastErrorTime = lastErrorTime, Date().timeIntervalSince1970 - lastErrorTime < minWaitDurationAfterError {
            return false
        } else {
            return true
        }
    }
    
    public func tryFetchMore() {
        guard canFetch else { return }
        switch state {
        case .loadedComplete, .loading:
            return
            
        case .unloaded, .loadedHasMore, .error:
            state = .loading
            Task {
                do {
                    let pageToFetch = lastSuccessfullyFetchedPage == nil ? 0 : lastSuccessfullyFetchedPage! + 1
                    let response = try await fetch(pageToFetch * pageSize)
                    self.lastSuccessfullyFetchedPage = pageToFetch
                    let hasMore = response.total > (pageToFetch + 1) * pageSize
                    self.state = hasMore ? .loadedHasMore : .loadedComplete
                    datasSubject.send(.data(response.data))
                    datas.append(response.data)
                } catch (let error) {
                    lastErrorTime = Date().timeIntervalSince1970
                    state = .error(error: PaginationError(error: error))
                    datasSubject.send(.error(PaginationError(error: error)))
                    return
                }
            }
        }
    }
}
