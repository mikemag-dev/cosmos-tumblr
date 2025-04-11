import SwiftUI
import Kingfisher

struct PhotoView: View {
    let photoViewModel: PhotoViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // smoother, but no GIF support
                //                AsyncImage(url: photoViewModel.getThumbnailURL(forIntentSize: geometry.size)) { image in
                //                    image
                //                        .resizable()
                //                        .scaledToFit()
                //                        .aspectRatio(contentMode: .fit)
                //                } placeholder: {
                //                    ProgressView()
                //                }
                //                .frame(maxWidth: .infinity, maxHeight: .infinity)
                //                WebImage (url: photoViewModel.getThumbnailURL(forIntentSize: geometry.size)) { image in
                //                    image
                //                        .resizable()
                //                        .scaledToFit()
                //                        .aspectRatio(contentMode: .fit)
                //                } placeholder: {
                //                    ProgressView()
                //                }
                //                .frame(maxWidth: .infinity, maxHeight: .infinity)
                KFImage
                    .url(photoViewModel.getThumbnailURL(forIntentSize: geometry.size))
                    .placeholder { _ in
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
        }
        
    }
}

#Preview {
    let viewModel = PhotoGridViewModel(blogId: "pitchersandpoets.tumblr.com")
    PhotoGridView(viewModel)
}
