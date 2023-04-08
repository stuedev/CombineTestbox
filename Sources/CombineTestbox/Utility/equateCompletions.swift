//
//  equateCompletions.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation
import Combine


public
func equateCompletions
(
    _ completion1: Subscribers.Completion<Swift.Error>,
    _ completion2: Subscribers.Completion<Swift.Error>
)
-> Bool
{
    switch (completion1, completion2)
    {
        case (.finished, .finished):
            
            return true

            
        case (.failure(let error1), .failure(let error2)):
            
            let isEqual = equateAny(error1, error2)
            
            return isEqual
            
            
        default:
            
            return false
    }
}
