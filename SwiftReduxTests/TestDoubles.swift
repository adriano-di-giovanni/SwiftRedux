import SwiftRedux

struct CounterState: StateType {
    var counter: Int = 0
}

class CounterStoreSubscriber: Subscriber {
    typealias SubscriberStateType = CounterState
    
    var updateWasInvoked: Bool = false
    var lastState: CounterState?
    
    func update(with state: CounterState) {
        updateWasInvoked = true
        lastState = state
    }
}

struct CounterActionIncrease: Action {}

struct AlphabetState: StateType {
    var letters: String = ""
}

struct AlphabetActionAdd: Action {
    var letter: Character
}
