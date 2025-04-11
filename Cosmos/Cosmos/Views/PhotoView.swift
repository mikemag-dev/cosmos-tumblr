import SwiftUI

struct PhotoView: View {
    let photoViewModel: PhotoViewModel
    
    var body: some View {
        GeometryReader { geometry in // geometry is a GeometryProxy
            VStack {
                AsyncImage(url: photoViewModel.getThumbnailURL(forIntentSize: geometry.size)) { image in
                    image
                        .resizable()
                        .scaledToFit()
//                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        
    }
}

#Preview {
    let viewModel = BlogPostsViewModel(blogId: "pitchersandpoets.tumblr.com")
    BlogPhotosView(viewModel)
}
