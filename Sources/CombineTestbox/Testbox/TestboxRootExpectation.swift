//
//  TestboxRootExpectation.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


class TestboxRootExpectation: NestingExpectationBase
{
    public
    override
    func performTest
    (
        with event: Event,
        context: TestContext
    )
    throws
    {
        try super.performTest(with: event,
                              context: context)
        
        /*
         if the event returns as idle, were safe to discard it at the top level.
         */
        
        if event.isIdle
        {
            event.discard(in: self)
        }
    }
    
    
    public
    override
    func performExpectationWantsToSetState
    (
        expectation: Expectation,
        desiredState: DesiredExpectationState
    )
    -> FinalExpectationState
    {
        /*
         here, we check if the expectation has an *expected failure* attached and if it was properly met.
         */
        
        let newState = checkExpectedFailure(in: expectation,
                                            with: desiredState.state)

        return FinalExpectationState(state: newState)
    }
    
    
    internal
    func checkExpectedFailure
    (
        in expectation: Expectation,
        with state: ExpectationState
    )
    -> ExpectationState
    {
        let newState: ExpectationState
        
        switch (expectation.expectedFailure, state)
        {
            /*
             if we expected a failure, but we finish without a failure, fail with *unmetExpectedFailure*.
             */
                
            case
                (.some(let expectedFailure), .fulfilled),
                (.some(let expectedFailure), .idle):
                
                expectedFailure.state = .failed
                
                let failure = Failure.unmetExpectedFailure(expectedFailure.failure)
                
                newState = .failed(failure)
                
            
            case (.some(let failureExpectation), .failed(let failure)):
                
                failureExpectation.tryRedeem(with: failure)
                
                switch failureExpectation.state
                {
                    case .redeemed:
                        
                        newState = .failed(failure)
                        
            
                    /*
                     if we failed with a different failure than we expected, fail with *mismatchingExpectedFailure*.
                     */
                        
                    case .failed:
                        
                        let failure = Failure.mismatchingExpectedFailure(failure)
                        
                        newState = .failed(failure)
                        
                        
                    case .idle:
                        
                        fatal_bug("unexpected")
                }
                
                
            default:
                
                newState = state
        }
        
        return newState
    }
    
    
    public
    override
    func desiredFinalState() -> ExpectationState
    {
        .fulfilled
    }
    
    
    public
    override
    var shortDescription: String
    {
        "Testbox root"
    }
}
