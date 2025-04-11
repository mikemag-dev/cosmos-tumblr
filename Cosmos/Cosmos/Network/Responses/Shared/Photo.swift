import Foundation

struct Photo: Codable, Hashable, Equatable {
    let caption: String?
    let originalSize: PhotoSize?
    let altSizes: [PhotoSize]?
}
