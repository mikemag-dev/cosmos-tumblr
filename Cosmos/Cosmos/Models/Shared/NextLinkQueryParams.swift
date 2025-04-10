import Foundation

struct NextLinkQueryParams: Decodable {
    let tumblelog: String?
    let pageNumber: String?

    enum CodingKeys: String, CodingKey {
        case tumblelog
        case pageNumber = "page_number"
    }
}
