//
//  EventState.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation
import StateMachine


public
enum EventState
{
    case idle
    
    case matched(Expectation)
    
    case discarded(Expectation)
}


extension EventState: ImplementsStateMachine
{
    public
    static
    func canTransition
    (
        from fromValue: EventState,
        to toValue: EventState
    )
    -> Bool
    {
        switch (fromValue, toValue)
        {
            case
                (.idle, matched),
                (.idle, discarded):
                
                return true
                
                
            default:
                
                return false
        }
    }
}


extension EventState
{
    internal
    var icon: String
    {
        switch self
        {
            case .idle:         return Constants.Icons.idle
                
            case .matched:      return Constants.Icons.matched
                
            case .discarded:    return Constants.Icons.discarded
        }
    }
}
