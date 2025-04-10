import Foundation

struct Trail: Decodable {
    let blog: TrailBlog?
    let post: TrailPost?
    let contentRaw: String?
    let content: String? // HTML content
    let isCurrentItem: Bool?
    let isRootItem: Bool?

    enum CodingKeys: String, CodingKey {
        case blog, post
        case contentRaw = "content_raw"
        case content
        case isCurrentItem = "is_current_item"
        case isRootItem = "is_root_item"
    }
}
