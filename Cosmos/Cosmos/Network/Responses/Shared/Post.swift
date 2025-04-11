import Foundation

struct Post: Decodable, Identifiable { // Conforming to Identifiable using 'id'
    let type: String // e.g., "link", "photo", "text"
    let isBlocksPostFormat: Bool
    let blogName: String
    let blog: PostBlog // Nested blog info specific to the post
    let id: Int // Use this as the primary ID
    let idString: String // String version of ID
    let isBlazed: Bool
    let isBlazePending: Bool
    let canBlaze: Bool
    let postUrl: String // URL String
    let slug: String
    let date: String // Date string "yyyy-MM-dd HH:mm:ss zzz" - Requires custom decoder configuration
    let timestamp: TimeInterval // Unix timestamp
    let state: String // e.g., "published"
    let format: String // e.g., "html"
    let reblogKey: String
    let tags: [String]
    let shortUrl: String // URL String
    let summary: String
    let shouldOpenInLegacy: Bool? // Optional boolean
    let recommendedSource: String? // Optional string (null in example)
    let recommendedColor: String? // Optional string (null in example)
    let noteCount: Int
    let title: String? // Title can be optional depending on post type
    let url: String? // URL specific to the post type (e.g., link URL), optional
    let linkAuthor: String? // Optional (null in example)
    let excerpt: String? // Optional (null in example)
    let publisher: String? // Optional (e.g., "peacecorps.gov", "instagram.com")
    let description: String? // HTML content, optional
    let reblog: Reblog? // Reblog details, optional
    let trail: [Trail]? // Trail details, optional
    let canLike: Bool?
    let interactabilityReblog: String?
    let interactabilityBlaze: String?
    let canReblog: Bool?
    let canSendInMessage: Bool?
    let canReply: Bool?
    let displayAvatar: Bool?

    // Properties specific to 'link' posts with images
    let linkImage: String? // URL String, optional
    let linkImageDimensions: LinkImageDimensions? // Optional
    let photos: [Photo]? // Array of photos, optional (present in some link posts)
}
