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
    
    @ViewBuilder
    var loadingMoreSpinner: some View {
        switch viewModel.paginator.state {
        case .loadedHasMore, .unloaded, .loading:
            ProgressView()
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity)
        case .error, .loadedComplete:
            let _ = 0
        }
    }
    
    var photosList: some View {
        ScrollView {
            LazyVStack {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.photoViewModels) { photoViewModel in
                        PhotoView(photoViewModel: photoViewModel)
                            .frame(height: 200)
                            .onTapGesture {
                                viewModel.send(.selectedPhoto(photo: photoViewModel))
                            }
                            .onAppear {
                                // start loading next page with 4 rows remaining
                                let lookaheadCount = numColumns * 4
                                let nearBottomIndex = viewModel.photoViewModels.count > lookaheadCount ? viewModel.photoViewModels.count - lookaheadCount - 1 : viewModel.photoViewModels.count - 1
                                let _ = print(nearBottomIndex)
                                if photoViewModel == viewModel.photoViewModels[nearBottomIndex] {
                                    viewModel.send(.scrolledToBottom)
                                }
                            }
                    }
                }
                loadingMoreSpinner
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
        .task {
            viewModel.send(.scrolledToBottom)
        }
    }
}

#Preview {
    let viewModel = BlogPostsViewModel(blogId: "pitchersandpoets.tumblr.com")
    BlogPhotosView(viewModel)
}
