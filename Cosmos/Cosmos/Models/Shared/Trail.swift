import Foundation

struct Trail: Decodable {
    let blog: TrailBlog?
    let post: TrailPost?
    let contentRaw: String?
    let content: String? // HTML content
    let isCurrentItem: Bool?
    let isRootItem: Bool?
}
