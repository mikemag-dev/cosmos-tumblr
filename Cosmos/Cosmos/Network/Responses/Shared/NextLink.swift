import Foundation

struct NextLink: Decodable {
    let href: String
    let method: String
    let queryParams: NextLinkQueryParams?
}
