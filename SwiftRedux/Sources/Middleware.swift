public typealias DispatchFunction = (Action) -> Void
public typealias Getter<State> = () -> State?
public typealias Middleware<State> = (_ dispatch: @escaping DispatchFunction, _ getState: @escaping Getter<State>) -> (_ next: @escaping DispatchFunction) -> DispatchFunction
