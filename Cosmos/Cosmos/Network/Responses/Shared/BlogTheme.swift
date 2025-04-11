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
        case headerFullWidth
        case headerFullHeight
        case headerFocusWidth
        case headerFocusHeight
        case avatarShape
        case backgroundColor
        case bodyFont
        case headerBounds
        case headerImage
        case headerImageFocused
        case headerImagePoster
        case headerImageScaled
        case headerStretch
        case linkColor
        case showAvatar
        case showDescription
        case showHeaderImage
        case showTitle
        case titleColor
        case titleFont
        case titleFontWeight
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
