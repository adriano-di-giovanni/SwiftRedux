//
//  SubscriptionTests.swift
//  SwiftReduxTests
//
//  Created by Adriano Di Giovanni on 30/04/2019.
//  Copyright © 2019 Adriano Di Giovanni. All rights reserved.
//

import XCTest
@testable import SwiftRedux

class SubscriptionTests: XCTestCase {
    typealias CounterSubscription = Subscription<CounterState>

    var subscriber: CounterStoreSubscriber?
    var subscription: CounterSubscription!

    override func setUp() {
        subscriber = CounterStoreSubscriber()
        subscription = Subscription(subscriber: subscriber)
    }
    
    func testWeakReferenceToSubscriber() {
        subscriber = nil
        XCTAssertNil(subscription.subscriber)
    }
    
    func testNotifyUpdateShouldReturnTrueWhenSubscriberExists() {
        let state = CounterState()
        let wasNotified = subscription.notifyUpdate(with: state)
        XCTAssert(wasNotified)
    }
    
    func testNotifyUpdateShouldInvokeUpdateOnSubscriber() {
        let state = CounterState()
        subscription.notifyUpdate(with: state)
        XCTAssert(subscriber!.updateWasInvoked)
    }
    
    func testNotifyUpdateShouldReturnFalseWhenSubscriberDoesntExist() {
        subscriber = nil
        let state = CounterState()
        let wasNotified = subscription.notifyUpdate(with: state)
        XCTAssertFalse(wasNotified)
    }
}
