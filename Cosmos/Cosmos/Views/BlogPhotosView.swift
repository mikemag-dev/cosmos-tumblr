import SwiftUI

struct BlogPhotosView: View {
    @State private var viewModel: BlogPostsViewModel
    @State private var numColumns = 1

    init(_ viewModel: BlogPostsViewModel) {
        // Initialize StateObject with the injected provider
        _viewModel = State(wrappedValue: viewModel)
    }
    
    func errorText(_ error: String) -> some View {
        Text("Error: \(error)")
            .foregroundColor(.red)
            .padding()
    }
    
    var photosList: some View {
        List {
            ForEach(viewModel.photoViewModels, id: \.self) { photo in
                PhotoView(photoViewModel: photo)
                .frame(height: 200)
                .onTapGesture {
                    viewModel.send(action: .selectedPhoto(photo: photo))
                }
            }
        }
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading...")
            case .error(let message):
                errorText(message)
            case .loaded:
                photosList
            }
        }
        .navigationTitle("Blog Images")
    }
}

#Preview {
    let viewModel = BlogPostsViewModel(blogId: "pitchersandpoets.tumblr.com")
    BlogPhotosView(viewModel)
}
