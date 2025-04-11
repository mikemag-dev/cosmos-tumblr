import SwiftUI

struct BlogPhotosView: View {
    @State private var viewModel: BlogPostsViewModel
    @State private var numColumns = 3
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: numColumns)
    }

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
        ScrollView {
            LazyVGrid(columns: columns) {
                let rowIterator = Array(stride(from: 0, to: viewModel.photoViewModels.count, by: numColumns))
                ForEach(viewModel.photoViewModels, id: \.self) { photoViewModel in
                    PhotoView(photoViewModel: photoViewModel)
                        .frame(height: 200)
                        .onTapGesture {
                            viewModel.send(action: .selectedPhoto(photo: photoViewModel))
                        }
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
