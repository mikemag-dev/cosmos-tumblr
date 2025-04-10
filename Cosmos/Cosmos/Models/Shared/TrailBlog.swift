import Foundation

struct TrailBlog: Decodable {
    let name: String?
    let active: Bool?
    let theme: Theme? // Reusing the main Theme struct
    let shareLikes: Bool?
    let shareFollowing: Bool?
    let canBeFollowed: Bool?

    enum CodingKeys: String, CodingKey {
        case name, active, theme
        case shareLikes = "share_likes"
        case shareFollowing = "share_following"
        case canBeFollowed = "can_be_followed"
    }
}
