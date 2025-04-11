import Foundation
import Combine

protocol PageableResponse {
    var total: Int { get }
}

typealias AsyncPagedFetch<T> = (_ offset: Int) async throws -> T
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
class Paginator<T: PageableResponse>: ObservableObject {
    enum State: Equatable {
        case unloaded
        case loadedComplete
        case loadedHasMore
        case loading
        case error(error: PaginationError)
    }
    
    enum StreamEvent {
        case data(T)
        case datas([T])
        case error(PaginationError)
    }
    
    private let minWaitDurationAfterError: TimeInterval = 2.0
    private var lastErrorTime: TimeInterval? = nil
    
    //use this if you want to self-consume paged data
    private let datasSubject = PassthroughSubject<StreamEvent, Never>()
    public var datasPublisher: AnyPublisher<StreamEvent, Never> { datasSubject.eraseToAnyPublisher() }
    
    //use this if you want to use Paginator-managed data (might be less optimizable/efficient in certain scenarios where results are shared)
    @Published public private(set) var datas = [T]()
    @Published public private(set) var state: State = .unloaded

    /// do not use directly, only exposed for testing
    public private(set) var lastSuccessfullyFetchedPage: Int?
    private let pageSize: Int
    private let fetch: AsyncPagedFetch<T>

    init(pageSize: Int, fetch: @escaping AsyncPagedFetch<T>) {
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
    
    public func tryBatchFetch(numPages: Int) {
        guard canFetch, numPages > 0 else { return }
        switch state {
        case .loadedComplete, .loading:
            return
            
        case .unloaded, .loadedHasMore, .error:
            state = .loading
            Task {
                do {
                    let firstPageToFetch = lastSuccessfullyFetchedPage == nil ? 0 : lastSuccessfullyFetchedPage! + 1
                    let lastPageToFetch = firstPageToFetch + numPages - 1
                    let responses: [T] = try await withThrowingTaskGroup(of: T.self) { [weak self] group in
                        guard let self = self else { throw PaginationError(message: "Paginator deallocated") }
                        for page in firstPageToFetch...lastPageToFetch {
                            group.addTask {
                                let offset = page * self.pageSize
                                return try await self.fetch(offset)
                            }
                        }
                        var responses = [T]()
                        for try await response in group {
                            responses.append(response)
                        }
                        return responses
                    }
                    guard !responses.isEmpty else {
                        state = .error(error: PaginationError(message: "No data returned"))
                        datasSubject.send(.error(PaginationError(message: "No data returned")))
                        return
                    }
                    self.lastSuccessfullyFetchedPage = lastPageToFetch
                    let hasMore = responses[responses.count - 1].total > lastPageToFetch * pageSize
                    self.state = hasMore ? .loadedHasMore : .loadedComplete
                    datasSubject.send(.datas(responses))
                    datas += responses
                } catch (let error) {
                    lastErrorTime = Date().timeIntervalSince1970
                    state = .error(error: PaginationError(error: error))
                    datasSubject.send(.error(PaginationError(error: error)))
                    return
                }
            }
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
                    datasSubject.send(.data(response))
                    datas.append(response)
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
