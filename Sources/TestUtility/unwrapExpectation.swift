//
//  unwrapExpectation.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation
@testable import CombineTestbox


func unwrapExpectation
(
    _ expectation: Expectation
)
-> Expectation
{
    switch expectation
    {
        case let expectation as BreakpointExpectation:
            
            return expectation.expectation
            
            
        default:
            
            return expectation
    }
}
