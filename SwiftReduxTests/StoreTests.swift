//
//  StoreTests.swift
//  SwiftReduxTests
//
//  Created by Adriano Di Giovanni on 30/04/2019.
//  Copyright © 2019 Adriano Di Giovanni. All rights reserved.
//

import XCTest
@testable import SwiftRedux

class StoreTests: XCTestCase {
    typealias CounterReducer = Reducer<CounterState>
    typealias CounterStore = Store<CounterState>
    
    var reducer: CounterReducer!
    var store: CounterStore!
    var subscriber: CounterStoreSubscriber?
    
    override func setUp() {
        reducer = { state, action in
            var state = state ?? CounterState()
            
            switch action {
            case _ as CounterActionIncrease:
                state.counter += 1
            default:
                break
            }
            
            return state
        }
        store = Store(reducer: reducer, state: nil)
        subscriber = CounterStoreSubscriber()
    }
    
    func testPristineStoreShouldHaveNoSubscriptions() {
        XCTAssertEqual(store.subscriptionCount, 0)
    }
    
    func testSubscribeShouldAddSubscription() {
        store.subscribe(subscriber!)
        XCTAssertEqual(store.subscriptionCount, 1)
    }
    
    func testSubscribeShouldPreventDuplicateSubscriptions() {
        store.subscribe(subscriber!)
        store.subscribe(subscriber!)
        XCTAssertEqual(store.subscriptionCount, 1)
    }
    
    func testSubscribeShouldImmediatelyNotifySubscriber() {
        store.subscribe(subscriber!)
        XCTAssert(subscriber!.updateWasInvoked)
    }
    
    func testUnsubscribeShouldRemoveSubscription() {
        store.subscribe(subscriber!)
        store.unsubscribe(subscriber!)
        XCTAssertEqual(store.subscriptionCount, 0)
    }
    
    func testDispatchShouldNotifySubscribers() {
        store.subscribe(subscriber!)
        store.dispatch(CounterActionIncrease())
        XCTAssert(subscriber!.updateWasInvoked)
        XCTAssertEqual(subscriber?.lastState?.counter, 1)
    }
}
