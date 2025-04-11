import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}

struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    static let get = HTTPMethod(rawValue: "GET")
    static let post = HTTPMethod(rawValue: "POST")

    let rawValue: String
    init(rawValue: String) { self.rawValue = rawValue }
}

class NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }

    func fetch<Response: Decodable>(
        url: URL,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem]? = nil
    ) async throws -> Response {

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw NetworkError.invalidURL
        }
        components.queryItems = queryItems

        guard let finalURL = components.url else {
             throw NetworkError.invalidURL
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue

        let data: Data
        let urlResponse: URLResponse

        do {
            (data, urlResponse) = try await session.data(for: request)
        } catch {
            // Handle cancellation specifically if desired
            throw NetworkError.requestFailed(error)
        }

        guard let httpResponse = urlResponse as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            // More specific error handling based on status code could be added
            throw NetworkError.invalidResponse
        }

        // comment in for testing delay
//        try! await Task.sleep(for: .seconds(1))
        
        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
