import Foundation

struct BlogInfo: Decodable, Identifiable {
    var id: String { uuid } // Use uuid for Identifiable conformance

    let ask: Bool
    let askAnon: Bool
    let askPageTitle: String
    let asksAllowMedia: Bool
    let avatar: [AvatarInfo]
    let canChat: Bool
    let canSubscribe: Bool
    let description: String
    let isNsfw: Bool
    let likes: Int? // Assuming likes can be large, consider Int64 if needed
    let name: String
    let posts: Int // Count of posts in the blog overall
    let shareLikes: Bool
    let subscribed: Bool
    let themeId: Int? // Made optional as theme info might vary
//    let theme: BlogTheme? // Made optional
    let title: String
    let totalPosts: Int
    let updated: TimeInterval // Unix timestamp -> TimeInterval/Date
    let url: URL
    let uuid: String
}
