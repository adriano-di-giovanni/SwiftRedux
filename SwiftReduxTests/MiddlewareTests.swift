//
//  MiddlewareTests.swift
//  SwiftReduxTests
//
//  Created by Adriano Di Giovanni on 30/04/2019.
//  Copyright © 2019 Adriano Di Giovanni. All rights reserved.
//

import XCTest
@testable import SwiftRedux

class MiddlewareTests: XCTestCase {
    typealias AlphabetMiddleware = Middleware<AlphabetState>
    typealias AlphabetReducer = Reducer<AlphabetState>
    typealias AlphabetStore = Store<AlphabetState>
    
    var middleware: [AlphabetMiddleware]!
    var reducer: AlphabetReducer!
    var store: AlphabetStore!
    
    override func setUp() {
        middleware = [createMiddleware(letter: "a"), createMiddleware(letter: "b"), createMiddleware(letter: "c")]
        reducer = { state, action in
            var state = state ?? AlphabetState()
            switch action {
            case let add as AlphabetActionAdd:
                state.letters.append(add.letter)
            default:
                break
            }
            return state
        }
        store = Store(reducer: reducer, state: nil, middleware: middleware)
    }
    
    func test() {
        XCTAssertEqual(store.state.letters, "abc")
    }
    
    func createMiddleware(letter: Character) -> AlphabetMiddleware {
        return { dispatch, getState in
            return { next in
                return { action in
                    if action is SwiftReduxActionInitialize {
                        dispatch(AlphabetActionAdd(letter: letter))
                    }
                    next(action)
                }
            }
        }
    }
}
