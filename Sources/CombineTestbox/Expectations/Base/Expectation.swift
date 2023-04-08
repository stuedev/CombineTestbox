//
//  Expectation.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


public
protocol Expectation: AnyObject, CustomStringConvertible
{
    // MARK: static config
    
    static
    var inversionBehaviour: InversionBehaviour { get }
    
    static
    var finalTreeStructure: FinalTreeConfig.Structures? { get }
    
    
    
    // MARK: members
    
    var parent: Expectation? { get set }
    
    var successor: Expectation? { get set }
    
    var sourceInfo: SourceInfo { get }
    
    var isInverse: Bool { get set }
    
    var stack: Stack { get set }
    
    var shortDescription: String { get }
    
    var config: TestboxConfiguration! { get set }
    
    var expectedFailure: ExpectedFailure? { get set }

    
    
    // MARK: state
    
    var state: ExpectationState { get }
    
    
    
    // MARK: required methods
    
    /**
     Called recursively through the expectation tree after Testbox was initialized with expectations.
     */
    func postInit()
    
    
    /**
     Test an event with the expectation using the *TestContext*.
     
     Throws a *FailureError* if a (nested) expectation failed during the test.
     */
    func performTest
    (
        with event: Event,
        context: TestContext
    )
    throws
    
    
    /**
     Called when `expectation` has issued the desire to set its state. This method is called recursively (bottom-up) and (typically) bubbles up until the TestboxRootExpectation where the *final* state is returned (top-down) to the `expectation`.
     
     This method can be overridden to alter the *desired* state at any place in the expectation tree.
     */
    func performExpectationWantsToSetState
    (
        expectation: Expectation,
        desiredState: DesiredExpectationState
    )
    -> FinalExpectationState
    
    
    /**
     Sets the *final* state of the expectation.
     
     Throws a FailureError if the state is `.failed`.
     */
    func setState
    (
        _ finalState: FinalExpectationState
    )
    throws
    
    
    /**
     Called to trigger the `finalize` pass on this expectation and nested expectations.
     
     Throws a *FailureError* if an expectation failed during finalization.
     */
    func performFinalize() throws
    
    
    /**
     Called to trigger the `finalize` pass on this expectation.
     
     Throws a *FailureError* if an expectation failed during finalization.
     */
    func performFinalizeSelf() throws
    
    
    /**
     Returns the *desired* state for this expectation. It typically depends on whether this expectation is inverse or not.
     */
    func desiredFinalState() -> ExpectationState
    
    
    /**
     Returns a string representing this expectation in the *Final Tree*. The config is used to determine, for example, whether this expectation (type) should be displayed or not.
     */
    func finalTreeString
    (
        level: Int,
        config: FinalTreeConfig
    )
    -> String?
    
    
    /**
     Returns a string representing this expectation in the *Successor Tree*.
     */
    func successorTreeString
    (
        level: Int
    )
    -> String
}



// MARK: methods

extension Expectation
{
    // MARK: test
    
    func test
    (
        with event: Event,
        context: TestContext
    )
    throws
    {
        guard self.isIdle
        else
        {
            fatal_bug("unexpected")
        }
        
        guard event.isIdle
        else
        {
            fatal_bug("unexpected")
        }
        
        
        self.config.logger.log(.debug(.test(event: event,
                                            context: context,
                                            inExpectation: self)))
        
        try self.performTest(with: event,
                             context: context)
    }
    
    
    
    // MARK: test successor
    
    func testSuccessor
    (
        with event: Event,
        context: TestContext
    )
    throws
    {
        if let successor
        {
            self.config.logger.log(.debug(.testSuccessor(event: event,
                                                         context: context,
                                                         inExpectation: self,
                                                         successor: successor)))
            
            
            try successor.test(with: event,
                               context: context)
            
            /*
             if the event was matched in the successor, we try to finalize this expectation.
             
             Note: testing events in successors usually only happens in "late-fulfilling" expectations, which fulfill using *finalize*.
             */
            
            if event.isMatched
            {
                try self.finalize()
            }
        }
    }

    
    
    // MARK: fulfill
    
    func fulfill() throws
    {
        let state: ExpectationState
        
        switch self.isInverse
        {
            case false:
                
                state = .fulfilled
                
                
            case true:
                
                let failure = Failure.fulfilledInverse
                
                state = .failed(failure)
        }
        
        try self.wantToSetState(state)
    }
    
    
    
    // MARK: fail
    
    func fail
    (
        with failure: Failure,
        context: TestContext
    )
    throws
    {
        guard context.canFail == true
        else
        {
            return
        }
        
        try self.wantToSetState(.failed(failure))
    }
    
    
    
    // MARK: wantToSetState
    
    func wantToSetState
    (
        _ state: ExpectationState
    )
    throws
    {
        self.config.logger.log(.debug(.expectationWantsToSetState(expectation: self,
                                                                  state: state,
                                                                  inExpectation: self)))
        
        let finalState: FinalExpectationState
        
        if let parent = self.parent
        {
            let desiredState = DesiredExpectationState(state: state)
            
            finalState = parent.expectationWantsToSetState(expectation: self,
                                                           desiredState: desiredState)
        }
        else
        {
            finalState = .init(state: state)
        }
        
        try self.setState(finalState)
    }
    
    
    
    // MARK: expectationWantsToSetState
    
    func expectationWantsToSetState
    (
        expectation: Expectation,
        desiredState: DesiredExpectationState
    )
    -> FinalExpectationState
    {
        var desiredState = desiredState
        
        /*
         if were *inverse* and our *behaviour* dictates it, reset expectation (.idle).
         */
        
        if self.isInverse,
           Self.inversionBehaviour == .resetUnfulfilledChildren,
           case .failed(let failure) = desiredState.state,
           case .unfulfilled = failure
        {
            desiredState = .init(state: .idle)
        }
        
        self.config.logger.log(.debug(.expectationWantsToSetState(expectation: expectation,
                                                                  state: desiredState.state,
                                                                  inExpectation: self)))
        
        let finalState = self.performExpectationWantsToSetState(expectation: expectation,
                                                                desiredState: desiredState)
        
        return finalState
    }
    
    
    
    // MARK: finalize
    
    func finalize() throws
    {
        /*
         if this expectation already has a final state, we do nothing.
         */
        
        guard self.isIdle
        else
        {
            return
        }
        
        
        self.config.logger.log(.debug(.finalize(expectation: self)))
        
        try self.performFinalize()
    }
    
    
    
    // MARK: isIdle
    
    var isIdle: Bool
    {
        if case .idle = self.state { return true }
        else { return false }
    }
    
    
    
    // MARK: isFulfilled
    
    var isFulfilled: Bool
    {
        if case .fulfilled = self.state { return true }
        else { return false }
    }
    
    
    
    // MARK: expectFailure
    
    @discardableResult
    public
    func expectFailure
    (
        _ failure: Failure
    )
    -> Self
    {
        self.expectedFailure = ExpectedFailure(failure: failure)
        
        return self
    }
    
    
    @discardableResult
    public
    func expectFailure
    (
        buildFailure: () -> Failure
    )
    -> Self
    {
        let failure = buildFailure()
        
        return self.expectFailure(failure)
    }
}


// MARK: - description

extension Expectation
{
    public
    var description: String
    {
        var string = self.state.icon + " " + self.shortDescription
        
        if self.isInverse
        {
            string += " " + "(inverse)"
        }
        
        if self.stack.hasEntries
        {
            string += " [" + self.stack.shortDescription.truncate(maxLength: 50) + "]"
        }
        
        if case .failed(let failure) = self.state
        {
            if let expectedFailure
            {
                switch expectedFailure.state
                {
                    case .idle:
                        
                        string += " " + Constants.Icons.failed + " [failure] [expectation not checked] " + expectedFailure.failure.description
                        
                    case .redeemed:
                        
                        string += " \(expectedFailure.state.icon) [failure] [redeemed] " + failure.description    // NOTE: we print failure here, because its more important (failure expectation can be slightly different)
                        
                    case .failed:
                        
                        string += " \(expectedFailure.state.icon) [failure] [unmet expectation] " + expectedFailure.failure.description
                }
            }
            else
            {
                string += " " + Constants.Icons.failed + " [failure] " + failure.description
            }
        }
        else
        {
            if let expectedFailure
            {
                switch expectedFailure.state
                {
                    case .idle:
                        
                        string += " \(expectedFailure.state.icon) [expected failure] [not checked] " + expectedFailure.failure.description
                        
                    case .redeemed:
                        
                        string += " \(expectedFailure.state.icon) [expected failure] [redeemed] " + expectedFailure.failure.description
                        
                    case .failed:
                        
                        string += " \(expectedFailure.state.icon) [expected failure] [unmet] " + expectedFailure.failure.description
                }
            }
        }

        return string
    }
}


// MARK: - Logging / Debugging

extension Expectation
{
    func finalTree
    (
        config: FinalTreeConfig = .init()
    )
    -> String
    {
        let string =
            self.finalTreeString(level: 0,
                                 config: config)
            ?? "<no string>"
        
        return string
    }
    
    
    func successorTree() -> String
    {
        let string = self.successorTreeString(level: 0)
        
        return string
    }
}
