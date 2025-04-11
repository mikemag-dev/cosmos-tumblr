import Dependencies
import SwiftUI

@Observable
@MainActor
class Router {
    public var path = [Destination]()
}

extension DependencyValues {
    var router: Router {
        get { self[Router.self] }
        set { self[Router.self] = newValue }
    }
}

extension Router: DependencyKey {
    public static let liveValue: Router = Router()
}
