import Foundation

struct Theme: Decodable {
    let headerFullWidth: Int?
    let headerFullHeight: Int?
    let headerFocusWidth: Int?
    let headerFocusHeight: Int?
    let avatarShape: String?
    let backgroundColor: String?
    let bodyFont: String?
    let headerBounds: String? // String containing comma-separated numbers
    let headerImage: String? // URL String
    let headerImageFocused: String? // URL String
    let headerImagePoster: String? // URL String or empty string
    let headerImageScaled: String? // URL String
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
}
