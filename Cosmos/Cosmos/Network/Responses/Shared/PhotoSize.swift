import Foundation

struct PhotoSize: Codable, Hashable, Equatable {
    let url: URL
    let width: Int
    let height: Int
    
    enum CodingKeys: String, CodingKey {
        case url
        case width
        case height
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(URL.self, forKey: .url)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
    }
    
    init(url: URL, width: Int, height: Int) {
        self.url = url
        self.width = width
        self.height = height
    }
}
