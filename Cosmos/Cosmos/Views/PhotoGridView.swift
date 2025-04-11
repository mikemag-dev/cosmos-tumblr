import SwiftUI

struct PhotoGridView: View {
    
    static let zoomInThreshold: CGFloat = 1.2
    static let zoomOutThreshold: CGFloat = 0.8
    static let maxColumns: Int = 10

    @State private var viewModel: PhotoGridViewModel
    @State private var numColumns = 3
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: numColumns)
    }

    init(_ viewModel: PhotoGridViewModel) {
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
                // detects if loading spinner is on screen
                // necessary for pinching since the prefetching does not always hit
                .onGeometryChange(for: Bool.self) { proxy in
                    let frame = proxy.frame(in: .scrollView)
                    let bounds = proxy.bounds(of: .scrollView) ?? .zero
                    let intersection = frame.intersection(
                        CGRect(origin: .zero, size: bounds.size))
                    let visibleHeight = intersection.size.height
                    return (visibleHeight / frame.size.height) > 0.75
                } action: { isVisible in
                    if isVisible {
                        viewModel.send(.scrolledToBottom)
                    }
                }

        case .error, .loadedComplete:
            let _ = 0
        }
    }
    
    func photoView(for photoViewModel: PhotoViewModel) -> some View {
        PhotoView(photoViewModel: photoViewModel)
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
    
    var photosList: some View {
        GeometryReader { proxy in
            let dim = proxy.size.width / CGFloat(numColumns)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(viewModel.photoViewModels) { photoViewModel in
                        photoView(for: photoViewModel)
                            .frame(width: dim, height: dim)
                    }
                }
                loadingMoreSpinnerRow
            }
            .scrollIndicators(.hidden)
            .gesture(
                MagnificationGesture()
                    .onEnded { value in
                        withAnimation {
                            if value > Self.zoomInThreshold {
                                numColumns = max(numColumns - 1, 1)
                            } else if value < Self.zoomOutThreshold {
                                numColumns = min(numColumns + 1, Self.maxColumns)
                            }
                            let newDim = proxy.size.width / CGFloat(numColumns)
                            let availableHeight = proxy.size.height
                            // 2 screens worth of photos
                            let photosNeeded = Int((CGFloat(numColumns) * availableHeight / newDim).rounded(.up)) * 2
                            viewModel.send(.layoutUpdated(minPhotos: photosNeeded))
                        }
                    }
            )
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
    let viewModel = PhotoGridViewModel(blogId: "pitchersandpoets.tumblr.com")
    PhotoGridView(viewModel)
}
