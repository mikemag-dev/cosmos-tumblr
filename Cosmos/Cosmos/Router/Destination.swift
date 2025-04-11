import SwiftUI

enum Destination: Codable, Hashable {
    case blogPhotos(blogId: String)
    case photo(photoViewModel: PhotoViewModel)

    @ViewBuilder
    @MainActor
    var view: some View {
        switch self {
        case .blogPhotos(let blogId):
            BlogPhotosView(.init(blogId: blogId))
        case .photo(let photoViewModel):
            PhotoView(photoViewModel: photoViewModel)
        }
    }
}
