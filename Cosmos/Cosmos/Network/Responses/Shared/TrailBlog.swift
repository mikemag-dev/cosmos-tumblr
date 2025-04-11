import Foundation

struct TrailBlog: Decodable {
    let name: String?
    let active: Bool?
//    let theme: Theme? // Reusing the main Theme struct
    let shareLikes: Bool?
    let shareFollowing: Bool?
    let canBeFollowed: Bool?
}
