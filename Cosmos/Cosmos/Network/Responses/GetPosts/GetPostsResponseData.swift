import Foundation

struct GetPostsResponseData: Decodable {
    let blog: BlogInfo
    let posts: [Post]
    let totalPosts: Int
    let links: Links?
}
