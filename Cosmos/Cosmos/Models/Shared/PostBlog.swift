import Foundation

struct PostBlog: Decodable {
    let name: String
    let title: String
    let description: String
    let url: String // URL String
    let uuid: String
    let updated: TimeInterval // Unix timestamp
    // Define as optional dictionary, assuming keys/values are strings if present.
    let tumblrmartAccessories: [String: String]?
    let canShowBadges: Bool?
}
