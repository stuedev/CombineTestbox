//
//  shortStringForFailure.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation
import CombineTestbox


public
func shortStringForFailure
(
    _ failure: Failure
)
-> String
{
    let failure = unwrapFailure(failure)
    
    switch failure
    {
        case .fulfilledInverse:
            
            return "fulfilledInverse"
            
            
        case .mismatchingEvent:
            
            return "mismatching"
            
            
        case .unexpectedEvent:
            
            return "unexpected"
            
            
        case .unfulfilled:
            
            return "unfulfilled"
            
            
        default:
            
            fatalError()    // unsupported
    }
}
