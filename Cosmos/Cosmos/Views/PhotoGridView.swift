import SwiftUI

struct PhotoGridView: View {
    @State private var viewModel: PhotoGridViewModel
    @State private var numColumns = 3
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: numColumns)
    }

    init(_ viewModel: PhotoGridViewModel) {
        // Initialize StateObject with the injected provider
        _viewModel = State(wrappedValue: viewModel)
    }
    
    func errorText(_ error: String) -> some View {
        Text("Error: \(error)")
            .foregroundColor(.red)
            .padding()
    }
    
    @ViewBuilder
    var loadingMoreSpinnerRow: some View {
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
            LazyVGrid(columns: columns) {
                ForEach(viewModel.photoViewModels) { photoViewModel in
                    PhotoView(photoViewModel: photoViewModel)
                        .frame(height: 200)
                        .onTapGesture {
                            viewModel.send(.selectedPhoto(photo: photoViewModel))
                        }
                        .onAppear {
                            // start loading next page with 4 rows remaining
                            let lookaheadCount = numColumns * 5
                            if viewModel.photoViewModels.count > lookaheadCount {
                                let nearBottomIndex = viewModel.photoViewModels.count - lookaheadCount - 1
                                if photoViewModel == viewModel.photoViewModels[nearBottomIndex] {
                                    viewModel.send(.scrolledToBottom)
                                }
                            } else {
                                viewModel.send(.scrolledToBottom)
                            }
                            photoViewModel.send(.imageScrolledIn)
                        }.onDisappear {
                            photoViewModel.send(.imageScrolledOut)
                        }
                }
                let toFill = numColumns - (viewModel.photoViewModels.count % numColumns)
                let _ = print("toFill \(toFill)")
                ForEach(0..<toFill, id: \.self) { _ in
                    Color.clear
                }
                Color.clear
                loadingMoreSpinnerRow
                Color.clear
            }
        }
        .scrollIndicators(.hidden)
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
    let viewModel = PhotoGridViewModel(blogId: "pitchersandpoets.tumblr.com")
    PhotoGridView(viewModel)
}
