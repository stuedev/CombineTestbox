//
//  LoggerEvent.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


public
enum LoggerEvent
{
    case event(EventTypeEvent)
    
    case failure(inExpectation: Expectation,
                 failure: Failure,
                 isRedeemed: Bool)
    
    case debug(DebugTypeEvent)
}


extension LoggerEvent
{
    public
    enum EventTypeEvent
    {
        case matched(event: Event,
                     inExpectation: Expectation)
        
        case discarded(event: Event,
                       inExpectation: Expectation)
        
        case failed(event: Event,
                    inExpectation: Expectation,
                    failure: Failure,
                    isRedeemed: Bool)
    }
    
    
    public
    enum DebugTypeEvent
    {
        case test(event: Event,
                  context: TestContext,
                  inExpectation: Expectation)
        
        case testSuccessor(event: Event,
                           context: TestContext,
                           inExpectation: Expectation,
                           successor: Expectation)

        case expectationWantsToSetState(expectation: Expectation,
                                        state: ExpectationState,
                                        inExpectation: Expectation)
        
        case finalize(expectation: Expectation)
    }
}
