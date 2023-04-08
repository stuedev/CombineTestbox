//
//  ExpectationState.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation
import StateMachine


public
enum ExpectationState
{
    case idle
    
    case fulfilled
    
    case failed(Failure)
}


extension ExpectationState: ImplementsStateMachine
{
    public
    static
    func canTransition
    (
        from fromValue: ExpectationState,
        to toValue: ExpectationState
    )
    -> Bool
    {
        switch (fromValue, toValue)
        {
            case
                (.idle, .fulfilled),
                (.idle, .failed):
                
                return true
                
                
            default:
                
                return false
        }
    }
}


extension ExpectationState
{
    var icon: String
    {
        switch self
        {
            case .idle:         return Constants.Icons.idle
            case .fulfilled:    return Constants.Icons.matched
            case .failed:       return Constants.Icons.failed
        }
    }
}


extension ExpectationState: CustomStringConvertible
{
    public
    var description: String
    {
        let string: String
        
        switch self
        {
            case .idle:
                
                string = "idle"
            
            
            case .fulfilled:
                
                string = "fulfilled"
            
            
            case .failed(let failure):
                
                string = "failed(" + failure.description + ")"
        }
        
        return self.icon + " " + string
    }
}


// MARK: - DesiredExpectationState

public
struct DesiredExpectationState: CustomStringConvertible
{
    let state: ExpectationState
    
    public
    var description: String
    {
        "desired(" + state.description + ")"
    }
}


// MARK: - FinalExpectationState

public
struct FinalExpectationState
{
    let state: ExpectationState
    
    public
    var description: String
    {
        "final(" + state.description + ")"
    }
}
