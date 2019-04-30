public class Store<State: StateType> {
    private var isDispatching = false
    private let reducer: Reducer<State>
    private(set) var state: State! {
        didSet {
            subscriptions = subscriptions.filter { $0.notifyUpdate(with: state) }
        }
    }
    var subscriptions: [Subscription<State>] = []
    private var wrappedDispatch: DispatchFunction!
    
    public init(reducer: @escaping Reducer<State>, state: State?, middleware: [Middleware<State>] = []) {
        self.reducer = reducer
        
        wrappedDispatch = wrapDispatch(with: middleware)
        
        if let state = state {
            self.state = state
        } else {
            dispatch(SwiftReduxActionInitialize())
        }
    }
    
    public func subscribe(_ subscriber: AnySubscriber) {
        guard !isSubscriber(subscriber) else { return }
        
        let subscription: Subscription<State> = Subscription(subscriber: subscriber)
        subscriptions.append(subscription)
        subscription.notifyUpdate(with: state)
    }
    
    public func unsubscribe(_ subscriber: AnySubscriber) {
        subscriptions = subscriptions.filter { $0.subscriber !== subscriber }
    }
    
    func baseDispatch(_ action: Action) {
        guard !isDispatching else {
            fatalError()
        }
        
        isDispatching = true
        let nextState = reducer(state, action)
        isDispatching = false
        
        state = nextState
    }
    
    public func dispatch(_ action: Action) {
        wrappedDispatch(action)
    }
    
    private func wrapDispatch(with middleware: [Middleware<State>]) -> DispatchFunction {
        let dispatch: DispatchFunction = { [weak self] action in self?.dispatch(action) }
        let getState: Getter<State> = { [weak self] in self?.state }
        let next: DispatchFunction = { [weak self] action in self?.baseDispatch(action) }
        
        return middleware.reversed().reduce(next) { next, middleware in middleware(dispatch, getState)(next) }
    }
    
    func isSubscriber(_ subscriber: AnySubscriber) -> Bool {
        return subscriptions.contains(where: { $0.subscriber === subscriber })
    }
}
