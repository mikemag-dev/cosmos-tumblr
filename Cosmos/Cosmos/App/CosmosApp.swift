import Dependencies
import SwiftUI

@main
struct CosmosApp: App {
    @Dependency(\.router) var router

    init() {
//        prepareDependencies {
//            $0.tumblrClient = .previewValue
//        }
    }
    
    var body: some Scene {
        @Bindable var router = router

        WindowGroup {
            NavigationStack(path: $router.path) {
                BlogPhotosView(.init(blogId: "pitchersandpoets.tumblr.com"))
                    .navigationDestination(for: Destination.self) { $0.view }
            }
        }
    }
}


