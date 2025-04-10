import Foundation

struct Photo: Decodable {
    let caption: String?
    let originalSize: PhotoSize?
    let altSizes: [PhotoSize]?

    enum CodingKeys: String, CodingKey {
        case caption
        case originalSize = "original_size"
        case altSizes = "alt_sizes"
    }
}
