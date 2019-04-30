@testable import SwiftRedux

extension Store {
    var subscriptionCount: Int {
        return subscriptions.count
    }
}
