//
//  equateFailures.swift
//  
//
//  Created by Stefan Ueter on 30.03.23.
//

import Foundation
@testable import CombineTestbox


public
func equateFailures
(
    _ failure1: Failure,
    _ failure2: Failure
)
-> Bool
{
    let failure1 = unwrapFailure(failure1)
    let failure2 = unwrapFailure(failure2)

    return failure1.equals(failure2)
}
