//
//  PrintLogger.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


public
class PrintLogger: Logger
{
    public
    override
    func didLog
    (
        _ event: LoggerEvent
    )
    {
        let string = Self.stringForEvent(event)
        
        Self.printString(string)
    }
    
    
    open
    class
    func printString
    (
        _ string: String
    )
    {
        fatal_bug("abstract")
    }
    
    
    static
    func stringForEvent
    (
        _ event: LoggerEvent
    )
    -> String
    {
        switch event
        {
            case .event(let event):
                
                switch event
                {
                    case .matched(let event,
                                  let expectation):
                        
                        return Events.eventMatched(event: event,
                                                   expectation: expectation)
                        
                        
                    case .discarded(let event,
                                    let expectation):
                        
                        return Events.eventDiscarded(event: event,
                                                     expectation: expectation)
                        
                        
                    case .failed(let event,
                                 let expectation,
                                 let failure,
                                 let isRedeemed):
                        
                        return Events.eventFailed(event: event,
                                                  expectation: expectation,
                                                  failure: failure,
                                                  isRedeemed: isRedeemed)
                }
                
                
            case .failure(let expectation,
                          let failure,
                          let isRedeemed):
                
                return Failures.failure(expectation: expectation,
                                        failure: failure,
                                        isRedeemed: isRedeemed)
                
                
            case .debug(let event):
                
                switch event
                {
                    case .test(let event, let context, let expectation):
                        
                        return Debug.Test.test(event: event,
                                               context: context,
                                               expectation: expectation)
                        
                        
                    case .testSuccessor(let event, let context, let expectation, let successor):
                        
                        return Debug.Test.testSuccessor(event: event,
                                                        context: context,
                                                        expectation: expectation,
                                                        successor: successor)
                        
                        
                    case .expectationWantsToSetState(let expectation,
                                                     let state,
                                                     let inExpectation):
                        
                        return Debug.State.expectationWantsToSetState(expectation: expectation,
                                                                      state: state,
                                                                      inExpectation: inExpectation)
                        
                    case .finalize(let expectation):
                        
                        return Debug.Finalize.finalize(expectation: expectation)
                }
        }
    }
    

    // MARK: - Generic methods

    open
    class
    func stringForComponents
    (
        _ components: [String]
    )
    -> String
    {
        let separator = Constants.PrintLogger.tabsBetweenComponents
        
        let string = components.joined(separator: separator)
        
        return string
    }

    
    open
    class
    func debugStringForComponents
    (
        _ components: [String]
    )
    -> String
    {
        Constants.PrintLogger.debug
        + " "
        + stringForComponents(components)
    }

    
    open
    class
    func stringForExpectation
    (
        _ expectation: Expectation
    )
    -> String
    {
        var string = expectation.shortDescription
        
        if expectation.isInverse
        {
            string += " (inverse)"
        }
        
        return string
    }
}
