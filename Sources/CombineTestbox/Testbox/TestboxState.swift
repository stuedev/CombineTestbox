//
//  TestboxState.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation
import StateMachine


public
enum TestboxState
{
    case idle
    
    case succeeded
    
    case failed(inExpectation: Expectation,
                failure: Failure,
                isRedeemed: Bool)
}


extension TestboxState: ImplementsStateMachine
{
    public
    static
    func canTransition
    (
        from fromValue: TestboxState,
        to toValue: TestboxState
    )
    -> Bool
    {
        switch (fromValue, toValue)
        {
            case
                (.idle, .succeeded),
                (.idle, .failed):
                
                return true
                
                
            default:
                
                return false
        }
    }
}
