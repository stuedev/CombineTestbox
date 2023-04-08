//
//  ExpectationBase.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation
import StateMachine


/**
 Base class conforming to `Expectation`
 */
public
class ExpectationBase: Expectation
{
    // MARK: static config
    
    public
    class
    var inversionBehaviour: InversionBehaviour { .custom }
    
    public
    class
    var finalTreeStructure: FinalTreeConfig.Structures? { nil }
    
    
    
    // MARK: members
    
    public
    var parent: Expectation?

    public
    var successor: Expectation?

    public
    var sourceInfo: SourceInfo
    
    public
    var isInverse: Bool = false
    
    public
    var stack: Stack = .init()
    
    public
    var config: TestboxConfiguration!
    
    public
    var expectedFailure: ExpectedFailure?
    
    
    
    // MARK: state
    
    @StateMachine
    public private(set)
    var state: ExpectationState = .idle
    
    
    
    // MARK: init
    
    init
    (
        sourceInfo: SourceInfo
    )
    {
        self.sourceInfo = sourceInfo
    }
    
    
    
    // MARK: methods
    
    public
    func postInit()
    {
        self.verifyFailureExpectation()
    }
    
    
    public
    func verifyFailureExpectation()
    {
        /*
         if we have an expected failure with a stack attached, check if the stack applies to us. If not, remove the expected failure.
         */
        
        if let expectedFailure,
           case .withStack(let failure, let stackDescription) = expectedFailure.failure
        {
            if stack.test(with: stackDescription)
            {
                self.expectedFailure = ExpectedFailure(failure: failure)
            }
            else
            {
                self.expectedFailure = nil
            }
        }
    }
    
    
    public
    func performTest
    (
        with event: Event,
        context: TestContext
    )
    throws
    {
        fatal_bug("abstract")
    }
    
    
    public
    func performExpectationWantsToSetState
    (
        expectation: Expectation,
        desiredState: DesiredExpectationState
    )
    -> FinalExpectationState
    {
        if let parent
        {
            return parent.expectationWantsToSetState(expectation: expectation,
                                                     desiredState: desiredState)
        }
        else
        {
            return FinalExpectationState(state: desiredState.state)
        }
    }
    
    
    public
    func setState
    (
        _ finalState: FinalExpectationState
    )
    throws
    {
        if case .idle = finalState.state
        {
            return
        }
        
        
        self.state = finalState.state
        
        if case .failed(let failure) = self.state
        {
            let isRedeemed = self.expectedFailure?.state == .redeemed
            
            let error = FailureError(inExpectation: self,
                                     failure: failure,
                                     isRedeemed: isRedeemed)
            
            throw error
        }
    }
    
    
    public
    func performFinalize() throws
    {
        try self.performFinalizeSelf()
    }
    
    
    public
    func performFinalizeSelf() throws
    {
        let state = desiredFinalState()
        
        try self.wantToSetState(state)
    }
    
    
    public
    func desiredFinalState() -> ExpectationState
    {
        switch self.isInverse
        {
            case false:
                
                let failure = Failure.unfulfilled
                
                return .failed(failure)
                
                
            case true:
                
                return .idle
        }
    }
    
    
    
    // MARK: - Debug / Logging
    
    public
    func finalTreeString
    (
        level: Int,
        config: FinalTreeConfig
    )
    -> String?
    {
        /*
         if our expectation defines a visibleStructure, and its not contained in the options, dont return a string
         */
        
        if let finalTreeVisibleStructure = Self.finalTreeStructure,
           config.visibleStructures.contains(finalTreeVisibleStructure) == false
        {
            switch self.state
            {
                /*
                 if we have a failure or redeemed expected failure, string must be printed
                 */
                    
                case .failed:
                    
                    break
                    
                    
                default:
                    
                    return nil
            }
        }
        
        let indent = "\t" * level
        
        return indent + self.description
    }

    
    public
    func successorTreeString
    (
        level: Int
    )
    -> String
    {
        let indent = "\t" * level
        
        var string = indent + Constants.Icons.idle + " " + self.shortDescription
        
        if self.isInverse
        {
            string += " " + "(inverse)"
        }
        
        if let parent = self.parent
        {
            string += ("\t" * 3) + " " + Constants.Icons.parent + " " + parent.shortDescription
        }
        
        if let successor = self.successor
        {
            string += ("\t" * 3) + " " + Constants.Icons.successor + " " + successor.shortDescription
        }
        
        return string
    }
    
    
    
    // MARK: shortDescription
    
    public
    var shortDescription: String
    {
        fatal_bug("abstract")
    }
}
