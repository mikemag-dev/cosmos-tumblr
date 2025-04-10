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
}
