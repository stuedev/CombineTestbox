//
//  unwrapFailure.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation
import CombineTestbox


public
func unwrapFailure
(
    _ failure: Failure
)
-> Failure
{
    if case .withStack(let failure, _) = failure
    {
        return failure
    }
    else
    {
        return failure
    }
}
