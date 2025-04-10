import SwiftUI

struct BlogPostsView: View {
    @State private var viewModel: BlogPostsViewModel

    init() {
        // Initialize StateObject with the injected provider
        _viewModel = State(wrappedValue: BlogPostsViewModel(blogId: "peacecorps.tumblr.com"))
    }

    var body: some View {
        NavigationView {
            Group {
                switch viewModel.state {
                    case .loading:
                        ProgressView("Loading...")
                    case .error(let message):
                    Text("Error: \(message)")
                        .foregroundColor(.red)
                        .padding()
                case .loaded:
                    List {
                        ForEach(viewModel.imageURLs, id: \.self) { imageUrl in
                            // Display the image (e.g., using AsyncImage)
                            AsyncImage(url: imageUrl) { image in
                                image.resizable().aspectRatio(contentMode: .fit)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(height: 200) // Example frame
                        }
                    }
                }
            }
            .navigationTitle("Blog Images")
            .task { // Use .task for async operations tied to view lifecycle
                await viewModel.send(action: .fetchPosts) // Example blog ID
            }
        }
    }
}
