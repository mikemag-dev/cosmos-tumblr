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

    enum CodingKeys: String, CodingKey {
        case type
        case isBlocksPostFormat = "is_blocks_post_format"
        case blogName = "blog_name"
        case blog, id
        case idString = "id_string"
        case isBlazed = "is_blazed"
        case isBlazePending = "is_blaze_pending"
        case canBlaze = "can_blaze"
        case postUrl = "post_url"
        case slug, date, timestamp, state, format
        case reblogKey = "reblog_key"
        case tags
        case shortUrl = "short_url"
        case summary
        case shouldOpenInLegacy = "should_open_in_legacy"
        case recommendedSource = "recommended_source"
        case recommendedColor = "recommended_color"
        case noteCount = "note_count"
        case title, url
        case linkAuthor = "link_author"
        case excerpt, publisher, description, reblog, trail
        case canLike = "can_like"
        case interactabilityReblog = "interactability_reblog"
        case interactabilityBlaze = "interactability_blaze"
        case canReblog = "can_reblog"
        case canSendInMessage = "can_send_in_message"
        case canReply = "can_reply"
        case displayAvatar = "display_avatar"
        case linkImage = "link_image"
        case linkImageDimensions = "link_image_dimensions"
        case photos
    }

    // Note: To decode the 'date' string correctly, configure your JSONDecoder:
    // let decoder = JSONDecoder()
    // let dateFormatter = DateFormatter()
    // dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
    // dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Important for fixed formats
    // dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Assuming GMT
    // decoder.dateDecodingStrategy = .formatted(dateFormatter)
    // Then use this decoder instance.
    // Alternatively, decode 'date' as String and parse manually.
}
