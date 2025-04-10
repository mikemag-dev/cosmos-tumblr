import Foundation

struct NextLink: Decodable {
    let href: String
    let method: String
    let queryParams: NextLinkQueryParams?

    enum CodingKeys: String, CodingKey {
        case href, method
        case queryParams = "query_params"
    }
}
