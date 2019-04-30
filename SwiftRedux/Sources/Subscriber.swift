//public protocol Subscriber: class {
//    associatedtype SubscriberStateType
//    func update(state: SubscriberStateType)
//}

public protocol AnySubscriber: class {
    func _update(with state: Any)
}

public protocol Subscriber: AnySubscriber {
    associatedtype SubscriberStateType
    func update(with state: SubscriberStateType)
}

extension Subscriber {
    public func _update(with state: Any) {
        if let state = state as? SubscriberStateType {
            update(with: state)
        }
    }
}
