struct Subscription<State> {
    private(set) weak var subscriber: AnySubscriber?
    
    @discardableResult
    func notifyUpdate(with state: State) -> Bool {
        if let subscriber = subscriber {
            subscriber._update(with: state)
            return true
        } else {
            return false
        }
    }
}
