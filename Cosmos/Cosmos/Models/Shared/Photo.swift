import Foundation

struct Photo: Decodable {
    let caption: String?
    let originalSize: PhotoSize?
    let altSizes: [PhotoSize]?
}
