//
//  findExpectedFailures_Tests.swift
//  
//
//  Created by Stefan Ueter on 30.03.23.
//

import Foundation
import XCTest
@testable import CombineTestbox
import TestUtility


class findExpectedFailures_Tests: XCTestCase
{
    // MARK: failure types
    
    func test__unfulfilled()
    {
        _test(
            expectations:
                {
                    "sub" > receiveValue(1)     !! unfulfilled
                },
            expect: unfulfilled)
    }
    
    
    func test__fulfilledInverse()
    {
        _test(
            expectations:
                {
                    "sub" > receiveValue(1)     !! fulfilledInverse
                },
            expect: fulfilledInverse)
    }
    
    
    func test__mismatching()
    {
        _test(
            expectations:
                {
                    "sub" > receiveValue(1)     !! mismatching .. "sub" > receiveValue(1)
                },
            expect: mismatching .. "sub" > receiveValue(1))
    }
    
    
    func test__unexpected()
    {
        _test(
            expectations:
                {
                    "sub" > receiveValue(1)     !! unexpected .. "sub" > receiveValue(1)
                },
            expect: unexpected .. "sub" > receiveValue(1))
    }
    
    
    func test__no_failure()
    {
        _test(
            expectations:
                {
                    "sub" > receiveValue(1)
                },
            expect: nil)
    }
    
    
    // MARK: combine
    
    func test__combine()
    {
        _test(
            expectations:
                {
                    "sub" > receiveValue(1)     !! unfulfilled
                },
            expect: unfulfilled)
    }
    
    
    // MARK: custom
    
    func test__custom()
    {
        _test(
            expectations:
                {
                    custom("aaa")     !! unfulfilled
                },
            expect: unfulfilled)
    }
    
    
    // MARK: ignore
    
    func test__ignore()
    {
        _test(
            expectations:
                {
                    ignore()     !! unfulfilled
                },
            expect: unfulfilled)
    }
    
    
    // MARK: breakpoint
    
    func test__breakpoint()
    {
        _test(
            expectations:
                {
                    (stop ** "sub" > receiveValue(1))     !! unfulfilled
                },
            expect: unfulfilled)
    }
    
    
    // MARK: forEach
    
    func test__forEach()
    {
        _test(
            expectations:
                {
                    forEach([1,2])
                    {
                        "sub" > receiveValue($0)
                    }
                    !! unfulfilled
                },
            expect: unfulfilled)
    }
    
    
    func test__forEach__in_nested()
    {
        _test(
            expectations:
                {
                    forEach([1,2])
                    {
                        "sub" > receiveValue($0)    !! unfulfilled
                    }
                },
            expect: unfulfilled)
    }

    
    func test__forEach__in_nested__with_stack()
    {
        _test(
            expectations:
                {
                    forEach([1,2])
                    {
                        "sub" > receiveValue($0)    !! unfulfilled ~~ /1
                    }
                },
            expect: unfulfilled)
    }

    
    // MARK: function call
    
    func test__functionCall()
    {
        _test(
            expectations:
                {
                    let function =
                    {
                        (value: Int) in
                        
                        Function("function")
                        {
                            "sub" > receiveValue(1)
                        }
                    }
                    
                    call(function(1), "aaa")    !! unfulfilled
                },
            expect: unfulfilled)
    }
    
    
    func test__functionCall__in_function()
    {
        _test(
            expectations:
                {
                    let function =
                    {
                        (value: Int) in
                        
                        Function("function")
                        {
                            "sub" > receiveValue(1)     !! unfulfilled
                        }
                    }
                    
                    call(function(1), "aaa")
                },
            expect: unfulfilled)
    }

    
    func test__functionCall__in_function__with_stack()
    {
        _test(
            expectations:
                {
                    let function =
                    {
                        (value: Int) in
                        
                        Function("function")
                        {
                            "sub" > receiveValue(1)     !! unfulfilled ~~ /"aaa"
                        }
                    }
                    
                    call(function(1), "aaa")
                },
            expect: unfulfilled)
    }

    
    // MARK: group
    
    func test_group()
    {
        _test(
            expectations:
                {
                    group
                    {
                        "sub" > receiveValue(1)
                    }
                    !! unfulfilled
                },
            expect: unfulfilled
        )
    }
    
    
    func test_group__in_nested()
    {
        _test(
            expectations:
                {
                    group
                    {
                        "sub" > receiveValue(1)     !! unfulfilled
                    }
                },
            expect: unfulfilled
        )
    }
    

    // MARK: not
    
    func test_not()
    {
        _test(
            expectations:
                {
                    not
                    {
                        "sub" > receiveValue(1)
                    }
                    !! unfulfilled
                },
            expect: unfulfilled
        )
    }
    
    
    func test_not__in_nested()
    {
        _test(
            expectations:
                {
                    not
                    {
                        "sub" > receiveValue(1)     !! unfulfilled
                    }
                },
            expect: unfulfilled
        )
    }

    
    // MARK: section
    
    func test_section()
    {
        _test(
            expectations:
                {
                    section("aaa")
                    {
                        "sub" > receiveValue(1)
                    }
                    !! unfulfilled
                },
            expect: unfulfilled
        )
    }
    
    
    func test_section__in_nested()
    {
        _test(
            expectations:
                {
                    section("aaa")
                    {
                        "sub" > receiveValue(1)     !! unfulfilled
                    }
                },
            expect: unfulfilled
        )
    }

    
    // MARK: strict
    
    func test_strict()
    {
        _test(
            expectations:
                {
                    strict(.receiveValue)
                    {
                        "sub" > receiveValue(1)
                    }
                    !! unfulfilled
                },
            expect: unfulfilled
        )
    }
    
    
    func test_strict__in_nested()
    {
        _test(
            expectations:
                {
                    strict(.receiveValue)
                    {
                        "sub" > receiveValue(1)     !! unfulfilled
                    }
                },
            expect: unfulfilled
        )
    }

    
    // MARK: unordered
    
    func test_unordered()
    {
        _test(
            expectations:
                {
                    unordered
                    {
                        "sub" > receiveValue(1)
                    }
                    !! unfulfilled
                },
            expect: unfulfilled
        )
    }
    
    
    func test_unordered__in_nested()
    {
        _test(
            expectations:
                {
                    unordered
                    {
                        "sub" > receiveValue(1)     !! unfulfilled
                    }
                },
            expect: unfulfilled
        )
    }
}


// MARK: - generic test method

fileprivate
func _test
(
    @ExpectationBuilder expectations buildExpectations: () -> [Expectation],
    expect expectedFailureType: (Failure)?,
    file: StaticString = #file,
    line: UInt = #line
)
{
    let expectations = buildExpectations()
    
    let actualExpectedFailure = findExpectedFailures(in: expectations).first
    
    var actualFailureType = actualExpectedFailure?.1.failure
    
    if case .withStack(let failure, _) = actualFailureType
    {
        actualFailureType = failure
    }
    
    switch (actualFailureType, expectedFailureType)
    {
        case
            (.unfulfilled, .unfulfilled),
            (.fulfilledInverse, .fulfilledInverse),
            (.mismatchingEvent, .mismatchingEvent),
            (.unexpectedEvent, .unexpectedEvent):
            
            break   // equal

            
        case
            (.mismatchingExpectedFailure, _),
            (.unmetExpectedFailure, _):
            
            fatalError()    // unsupported
            
            
        case (.some, .some):    // else (unequal failure types)
            
            XCTFail("not equal",
                    file: file,
                    line: line)
            
            
        case (.none, .some):
            
            XCTFail("expected some, found none",
                    file: file,
                    line: line)
            
            
        case (.some, .none):
            
            XCTFail("expected none, found some",
                    file: file,
                    line: line)

            
        case (.none, .none):
            
            break
    }
}
