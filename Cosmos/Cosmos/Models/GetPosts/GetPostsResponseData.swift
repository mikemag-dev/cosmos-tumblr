import Foundation

struct GetPostsResponseData: Decodable {
    let blog: BlogInfo
    let posts: [Post]
    let totalPosts: Int
    // Use CodingKeys for `_links` if you prefer camelCase `links` property
    let links: Links?

    enum CodingKeys: String, CodingKey {
        case blog, posts
        case totalPosts = "total_posts"
        case links = "_links" // Map JSON's _links to links
    }
}
