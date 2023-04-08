//
//  DSL+ExpectedFailures.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation


precedencegroup ExpectedFailurePrecedenceGroup
{
    lowerThan: TernaryPrecedence
    associativity: left
}

infix operator !!: ExpectedFailurePrecedenceGroup


public
func !!
(
    expectation: Expectation,
    failureType: Failure
)
-> Expectation
{
    expectation.expectFailure(failureType)
    
    return expectation
}
