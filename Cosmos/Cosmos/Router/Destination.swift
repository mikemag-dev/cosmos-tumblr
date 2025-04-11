import SwiftUI

enum Destination: Hashable {
    case blogPhotos(blogId: String)
    case photo(photoViewModel: PhotoViewModel)

    @ViewBuilder
    @MainActor
    var view: some View {
        switch self {
        case .blogPhotos(let blogId):
            PhotoGridView(.init(blogId: blogId))
        case .photo(let photoViewModel):
            PhotoView(photoViewModel: photoViewModel)
        }
    }
}
