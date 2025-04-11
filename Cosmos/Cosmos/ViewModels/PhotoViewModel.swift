import Foundation

struct PhotoViewModel: Identifiable, Codable, Hashable {
    let photo: Photo
    private let originalUrl: URL
    var id: String { originalUrl.absoluteString }
    
    init?(photo: Photo) {
        guard let originalSizeUrl = photo.originalSize?.url else {
            return nil
        }
        self.photo = photo
        self.originalUrl = originalSizeUrl
    }
    
    func getThumbnailURL(forIntentSize intentSize: CGSize) -> URL? {
        // TODO: remove test code
        // comment this in for testing what (2nd) smallest thumbnail looks like
//        if let altSizes = photo.altSizes, altSizes.count > 1 {
//            return altSizes[altSizes.count-2].url
//        }
        //TODO: could do binary search for improvement if many alt sizes
        //TODO: add network speed test decision making
        // alt sizes are ordered greatest to least size, last alt is a square 75x75
        let photoSize = photo.altSizes?.last(where: { photoSize in
            CGFloat(photoSize.width) >= intentSize.width && CGFloat(photoSize.height) >= intentSize.height
        }) ?? photo.originalSize
        guard let photoSize = photoSize else {
            print("no photo size found for \(photo)")
            return nil
        }
        print("loaded photo size: \(photoSize.width)x\(photoSize.height) into \(photoSize.width)x\(photoSize.height)")
        return photoSize.url
    }
    
    func preFetch() {
        //TODO: add prefetching logic
    }
}
