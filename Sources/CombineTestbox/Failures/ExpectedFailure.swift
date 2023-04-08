//
//  ExpectedFailure.swift
//  
//
//  Created by Stefan Ueter on 27.03.23.
//

import Foundation
import StateMachine


public
class ExpectedFailure
{
    @StateMachine
    var state: ExpectedFailureState = .idle
    
    let failure: Failure
    
    
    init
    (
        failure: Failure
    )
    {
        self.failure = failure
    }
    
    
    func tryRedeem
    (
        with failure: Failure
    )
    {
        if failure.equals(self.failure)
        {
            self.state = .redeemed
        }
        else
        {
            self.state = .failed
        }
    }
}


extension ExpectedFailure: CustomDebugStringConvertible
{
    public
    var debugDescription: String
    {
        self.state.icon + " " + failure.description
    }
}
