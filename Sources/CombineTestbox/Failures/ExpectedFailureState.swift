//
//  ExpectedFailureState.swift
//  
//
//  Created by Stefan Ueter on 27.03.23.
//

import Foundation
import StateMachine


enum ExpectedFailureState
{
    case idle
    
    case failed

    case redeemed
}


extension ExpectedFailureState: ImplementsStateMachine
{
    public
    static
    func canTransition
    (
        from fromValue: ExpectedFailureState,
        to toValue: ExpectedFailureState
    )
    -> Bool
    {
        switch (fromValue, toValue)
        {
            case
                (.idle, .redeemed),
                (.idle, .failed):
                
                return true
                
                
            default:
                
                return false
        }
    }
}


extension ExpectedFailureState
{
    var icon: String
    {
        switch self
        {
            case .idle:         return Constants.Icons.idle
            case .redeemed:     return Constants.Icons.matched
            case .failed:       return Constants.Icons.failed
        }
    }
}
