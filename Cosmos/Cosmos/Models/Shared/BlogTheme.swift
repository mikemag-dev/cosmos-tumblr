import Foundation

struct BlogTheme: Decodable {
    let headerFullWidth: Int?
    let headerFullHeight: Int?
    let headerFocusWidth: Int?
    let headerFocusHeight: Int?
    let avatarShape: String?
    let backgroundColor: String?
    let bodyFont: String?
    let headerBounds: String? // Looks like a comma-separated string "x,y,w,h"?
    let headerImage: URL?
    let headerImageFocused: URL?
    let headerImagePoster: URL? // Seems empty in example, potentially URL
    let headerImageScaled: URL?
    let headerStretch: Bool?
    let linkColor: String?
    let showAvatar: Bool?
    let showDescription: Bool?
    let showHeaderImage: Bool?
    let showTitle: Bool?
    let titleColor: String?
    let titleFont: String?
    let titleFontWeight: String?

    enum CodingKeys: String, CodingKey {
        case headerFullWidth = "header_full_width"
        case headerFullHeight = "header_full_height"
        case headerFocusWidth = "header_focus_width"
        case headerFocusHeight = "header_focus_height"
        case avatarShape = "avatar_shape"
        case backgroundColor = "background_color"
        case bodyFont = "body_font"
        case headerBounds = "header_bounds"
        case headerImage = "header_image"
        case headerImageFocused = "header_image_focused"
        case headerImagePoster = "header_image_poster"
        case headerImageScaled = "header_image_scaled"
        case headerStretch = "header_stretch"
        case linkColor = "link_color"
        case showAvatar = "show_avatar"
        case showDescription = "show_description"
        case showHeaderImage = "show_header_image"
        case showTitle = "show_title"
        case titleColor = "title_color"
        case titleFont = "title_font"
        case titleFontWeight = "title_font_weight"
    }

     // Handle potentially empty string for URLs
     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        headerFullWidth = try container.decodeIfPresent(Int.self, forKey: .headerFullWidth)
        headerFullHeight = try container.decodeIfPresent(Int.self, forKey: .headerFullHeight)
        headerFocusWidth = try container.decodeIfPresent(Int.self, forKey: .headerFocusWidth)
        headerFocusHeight = try container.decodeIfPresent(Int.self, forKey: .headerFocusHeight)
        avatarShape = try container.decodeIfPresent(String.self, forKey: .avatarShape)
        backgroundColor = try container.decodeIfPresent(String.self, forKey: .backgroundColor)
        bodyFont = try container.decodeIfPresent(String.self, forKey: .bodyFont)
        headerBounds = try container.decodeIfPresent(String.self, forKey: .headerBounds)
        headerImage = try? container.decodeIfPresent(URL.self, forKey: .headerImage) // Use try? for robust URL decoding
        headerImageFocused = try? container.decodeIfPresent(URL.self, forKey: .headerImageFocused)
        headerImagePoster = try? container.decodeIfPresent(URL.self, forKey: .headerImagePoster) // Allow empty string
        headerImageScaled = try? container.decodeIfPresent(URL.self, forKey: .headerImageScaled)
        headerStretch = try container.decodeIfPresent(Bool.self, forKey: .headerStretch)
        linkColor = try container.decodeIfPresent(String.self, forKey: .linkColor)
        showAvatar = try container.decodeIfPresent(Bool.self, forKey: .showAvatar)
        showDescription = try container.decodeIfPresent(Bool.self, forKey: .showDescription)
        showHeaderImage = try container.decodeIfPresent(Bool.self, forKey: .showHeaderImage)
        showTitle = try container.decodeIfPresent(Bool.self, forKey: .showTitle)
        titleColor = try container.decodeIfPresent(String.self, forKey: .titleColor)
        titleFont = try container.decodeIfPresent(String.self, forKey: .titleFont)
        titleFontWeight = try container.decodeIfPresent(String.self, forKey: .titleFontWeight)
    }
}
