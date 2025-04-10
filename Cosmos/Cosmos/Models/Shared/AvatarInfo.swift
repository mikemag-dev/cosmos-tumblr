import Foundation

struct AvatarInfo: Decodable {
    let width: Int
    let height: Int
    let url: URL
    let accessories: [Accessory]? // Array of currently unknown objects, made optional
}
