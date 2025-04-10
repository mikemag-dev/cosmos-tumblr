import Dependencies
import SwiftUI

@main
struct CosmosApp: App {
    init() {
//        prepareDependencies {
//            $0.tumblrClient = .previewValue
//        }
    }
    
    var body: some Scene {
        WindowGroup {
            BlogPostsView()
        }
    }
}


