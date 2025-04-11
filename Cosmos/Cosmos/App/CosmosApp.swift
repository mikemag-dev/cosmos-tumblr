import Dependencies
import SwiftUI
import Kingfisher

@main
struct CosmosApp: App {
    @Dependency(\.router) var router

    init() {
        // TODO: remove, only for demo purpose
        KingfisherManager.shared.cache.clearCache()
//        prepareDependencies {
//            $0.tumblrClient = .previewValue
//        }
    }
    
    var body: some Scene {
        @Bindable var router = router

        WindowGroup {
            NavigationStack(path: $router.path) {
                PhotoGridView(.init(blogId: "pitchersandpoets.tumblr.com"))
                    .navigationDestination(for: Destination.self) { $0.view }
            }
        }
    }
}


