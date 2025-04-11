import Dependencies
import SwiftUI

@Observable
class Router {
    public var path = [Destination]()
}

// MARK: - DependencyInjection

extension DependencyValues {
    var router: Router {
        get { self[Router.self] }
        set { self[Router.self] = newValue }
    }
}

extension Router: DependencyKey {
    public static var liveValue: Router {
        Router()
    }
}
