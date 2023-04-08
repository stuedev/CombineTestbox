//
//  File.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation
@testable import CombineTestbox


public
func findExpectedFailures
(
    in expectations: [Expectation]
)
-> [(expectation: Expectation, expectedFailure: ExpectedFailure)]
{
    var results: [(expectation: Expectation, expectedFailure: ExpectedFailure)] = []
    
    for exp in expectations
    {
        results += findExpectedFailures(in: exp)
    }
    
    return results
}


func findExpectedFailures
(
    in expectation: Expectation
)
-> [(expectation: Expectation, expectedFailure: ExpectedFailure)]
{
    var results: [(expectation: Expectation, expectedFailure: ExpectedFailure)] = []

    if let expectedFailure = expectation.expectedFailure
    {
        results += [(expectation: expectation, expectedFailure: expectedFailure)]
    }
    
    switch expectation
    {
        case let exp as ForEachExpectation<Int>:
            
            let expectations = exp.body(exp.values.first!)
            
            results += findExpectedFailures(in: expectations)
            
            
        case let exp as FunctionCallExpectation:
            
            let expectations = exp.function.buildExpectations()
            
            results += findExpectedFailures(in: expectations)
            
            
        case let exp as NestingExpectation:
            
            results += findExpectedFailures(in: exp.expectations)
            
            
        default:
            
            break
    }
    
    return results
}
