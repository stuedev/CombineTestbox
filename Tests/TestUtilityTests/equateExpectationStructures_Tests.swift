//
//  equateExpectationStructures_Tests.swift
//  
//
//  Created by Stefan Ueter on 30.03.23.
//

import Foundation
import XCTest
import CombineTestbox
import TestUtility


class equateExpectationStructures_Tests: XCTestCase
{
    // MARK: different count
    
    func test__different_count__notEqual()
    {
        _test(
            expectations1:
                {
                    "sub" > receiveValue(1)
                },
            expectations2:
                {
                    "sub" > receiveValue(1)
                    "sub" > receiveValue(2)
                },
            expectResult: .notEqual)
    }
    
    
    // MARK: different expectations

    func test__different_expectations__notEqual()
    {
        _test(
            expectations1:
                {
                    "sub" > receiveValue(1)
                },
            expectations2:
                {
                    group
                    {
                        "sub" > receiveValue(1)
                    }
                },
            expectResult: .notEqual)
    }

    
    func test__combine__different_type__not_equal()
    {
        _test(
            expectations1:
                {
                    "sub" > receiveValue(1)
                },
            expectations2:
                {
                    "sub" > receiveCompletion(.finished)
                },
            expectResult: .notEqual)
    }

    
    // MARK: - COMBINE EXPECTATION

    
    
    // MARK: receiveSubscriber specific

    func test__receiveSubscriber_specific__matching_values__equal()
    {
        _test(
            expectations1:
                {
                    "sub" > receiveSubscriber("aaa")
                },
            expectations2:
                {
                    "sub" > receiveSubscriber("aaa")
                },
            expectResult: .equal)
    }

    
    func test__receiveSubscriber_specific__mismatching_values__notEqual()
    {
        _test(
            expectations1:
                {
                    "sub" > receiveSubscriber("aaa")
                },
            expectations2:
                {
                    "sub" > receiveSubscriber("bbb")
                },
            expectResult: .notEqual)
    }

    
    // MARK: receiveSubscriber unspecific
    
    func test__receiveSubscriber_unspecific__equal()
    {
        _test(
            expectations1:
                {
                    "sub" > receiveSubscriber()
                },
            expectations2:
                {
                    "sub" > receiveSubscriber()
                },
            expectResult: .equal)
    }

    
    
    // MARK: receiveSubscription specific

    func test__receiveSubscription_specific__matching_values__equal()
    {
        _test(
            expectations1:
                {
                    "sub" > receiveSubscription("aaa")
                },
            expectations2:
                {
                    "sub" > receiveSubscription("aaa")
                },
            expectResult: .equal)
    }

    
    func test__receiveSubscription_specific__mismatching_values__notEqual()
    {
        _test(
            expectations1:
                {
                    "sub" > receiveSubscription("aaa")
                },
            expectations2:
                {
                    "sub" > receiveSubscription("bbb")
                },
            expectResult: .notEqual)
    }

    
    // MARK: receiveSubscription unspecific
    
    func test__receiveSubscription_unspecific__equal()
    {
        _test(
            expectations1:
                {
                    "sub" > receiveSubscription()
                },
            expectations2:
                {
                    "sub" > receiveSubscription()
                },
            expectResult: .equal)
    }

    
    // MARK: receiveValue specific
    
    func test__receiveValue_specific__matching_values__equal()
    {
        _test(
            expectations1:
                {
                    "sub" > receiveValue(1)
                },
            expectations2:
                {
                    "sub" > receiveValue(1)
                },
            expectResult: .equal)
    }
    
    
    func test__receiveValue_specific__mismatching_values__notEqual()
    {
        _test(
            expectations1:
                {
                    "sub" > receiveValue(1)
                },
            expectations2:
                {
                    "sub" > receiveValue(2)
                },
            expectResult: .notEqual)
    }
    

    // MARK: receiveValue unspecific
    
    func test__receiveValue_unspecific__equal()
    {
        _test(
            expectations1:
                {
                    "sub" > receiveValue()
                },
            expectations2:
                {
                    "sub" > receiveValue()
                },
            expectResult: .equal)
    }

    
    // MARK: receiveValue test
    
    func test__receiveValue_test__requiresExplicitGuarantee()
    {
        _test(
            expectations1:
                {
                    "sub" > receiveValue { $0 as? Int == 1 }
                },
            expectations2:
                {
                    "sub" > receiveValue { $0 as? Int == 1 }
                },
            expectResult: .unableToEquate(reason: .combineTestVariant))
    }

    
    // MARK: receiveCompletion specific
    
    func test__receiveCompletion_specific__matching_finished__equal()
    {
        _test(
            expectations1:
                {
                    "sub" > receiveCompletion(.finished)
                },
            expectations2:
                {
                    "sub" > receiveCompletion(.finished)
                },
            expectResult: .equal)
    }

    
    func test__receiveCompletion_specific__mismatching_types__notEqual()
    {
        _test(
            expectations1:
                {
                    "sub" > receiveCompletion(.finished)
                },
            expectations2:
                {
                    "sub" > receiveCompletion(.failure(DummyError()))
                },
            expectResult: .notEqual)
    }

    
    func test__receiveCompletion_specific__matching_errors__equal()
    {
        _test(
            expectations1:
                {
                    "sub" > receiveCompletion(.failure(DummyError()))
                },
            expectations2:
                {
                    "sub" > receiveCompletion(.failure(DummyError()))
                },
            expectResult: .equal)
    }

    
    // MARK: receiveCompletion unspecific
    
    func test__receiveCompletion_unspecific__equal()
    {
        _test(
            expectations1:
                {
                    "sub" > receiveCompletion()
                },
            expectations2:
                {
                    "sub" > receiveCompletion()
                },
            expectResult: .equal)
    }


    // MARK: receiveCompletion test
    
    func test__receiveCompletion_test__requiresExplicitGuarantee()
    {
        _test(
            expectations1:
                {
                    "sub" > receiveCompletion { $0 is DummyError }
                },
            expectations2:
                {
                    "sub" > receiveCompletion { $0 is DummyError }
                },
            expectResult: .unableToEquate(reason: .combineTestVariant))
    }

    
    // MARK: requestDemand specific

    func test__requestDemand_specific__matching_demand__equal()
    {
        _test(
            expectations1:
                {
                    "sub" > requestDemand(.max(1))
                },
            expectations2:
                {
                    "sub" > requestDemand(.max(1))
                },
            expectResult: .equal)
    }

    
    func test__requestDemand_specific__mismatching_demand__notEqual()
    {
        _test(
            expectations1:
                {
                    "sub" > requestDemand(.max(1))
                },
            expectations2:
                {
                    "sub" > requestDemand(.max(2))
                },
            expectResult: .notEqual)
    }

    
    // MARK: requestDemand unspecific

    func test__requestDemand_unspecific__equal()
    {
        _test(
            expectations1:
                {
                    "sub" > requestDemand()
                },
            expectations2:
                {
                    "sub" > requestDemand()
                },
            expectResult: .equal)
    }

    
    // MARK: requestSyncDemand specific

    func test__requestSyncDemand_specific__matching_demand__equal()
    {
        _test(
            expectations1:
                {
                    "sub" > requestSyncDemand(.max(1))
                },
            expectations2:
                {
                    "sub" > requestSyncDemand(.max(1))
                },
            expectResult: .equal)
    }

    
    func test__requestSyncDemand_specific__mismatching_demand__notEqual()
    {
        _test(
            expectations1:
                {
                    "sub" > requestSyncDemand(.max(1))
                },
            expectations2:
                {
                    "sub" > requestSyncDemand(.max(2))
                },
            expectResult: .notEqual)
    }

    
    // MARK: requestSyncDemand unspecific

    func test__requestSyncDemand_unspecific__equal()
    {
        _test(
            expectations1:
                {
                    "sub" > requestSyncDemand()
                },
            expectations2:
                {
                    "sub" > requestSyncDemand()
                },
            expectResult: .equal)
    }

    
    // MARK: cancel
    
    func test__cancel__equal()
    {
        _test(
            expectations1:
                {
                    "sub" > cancel()
                },
            expectations2:
                {
                    "sub" > cancel()
                },
            expectResult: .equal)
    }

    
    // MARK: - CUSTOM EXPECTATION

    func test__custom__same_message__equal()
    {
        _test(
            expectations1:
                {
                    custom("aaa")
                },
            expectations2:
                {
                    custom("aaa")
                },
            expectResult: .equal)
    }

    
    func test__custom__different_message__notEqual()
    {
        _test(
            expectations1:
                {
                    custom("aaa")
                },
            expectations2:
                {
                    custom("bbb")
                },
            expectResult: .notEqual)
    }

    
    // MARK: - IGNORE
    
    func test__ignore__equal()
    {
        _test(
            expectations1:
                {
                    ignore()
                },
            expectations2:
                {
                    ignore()
                },
            expectResult: .equal)
    }

    
    // MARK: - BREAKPOINT
    
    func test__breakpoint__matching_expectation__equal()
    {
        _test(
            expectations1:
                {
                    stop ** "sub" > receiveValue(1)
                },
            expectations2:
                {
                    stop ** "sub" > receiveValue(1)
                },
            expectResult: .equal)
    }

    
    func test__breakpoint__mismatching_expectation__notEqual()
    {
        _test(
            expectations1:
                {
                    stop ** "sub" > receiveValue(1)
                },
            expectations2:
                {
                    stop ** "sub" > receiveValue(2)
                },
            expectResult: .notEqual)
    }

    
    
    // MARK: - FOREACH
    
    func test__forEach__Int__all_equal__equal()
    {
        _test(
            expectations1:
                {
                    forEach("aaa", [1,2])
                    {
                        "sub" > receiveValue($0)
                    }
                },
            expectations2:
                {
                    forEach("aaa", [1,2])
                    {
                        "sub" > receiveValue($0)
                    }
                },
            expectResult: .equal)
    }

    
    func test__forEach__Int__mismatching_title__notEqual()
    {
        _test(
            expectations1:
                {
                    forEach("aaa", [1,2])
                    {
                        "sub" > receiveValue($0)
                    }
                },
            expectations2:
                {
                    forEach("bbb", [1,2])
                    {
                        "sub" > receiveValue($0)
                    }
                },
            expectResult: .notEqual)
    }

    
    func test__forEach__Int__mismatching_values__notEqual()
    {
        _test(
            expectations1:
                {
                    forEach("aaa", [1,2])
                    {
                        "sub" > receiveValue($0)
                    }
                },
            expectations2:
                {
                    forEach("aaa", [1,2,3])
                    {
                        "sub" > receiveValue($0)
                    }
                },
            expectResult: .notEqual)
    }

    
    func test__forEach__Int__mismatching_structure__notEqual()
    {
        _test(
            expectations1:
                {
                    forEach("aaa", [1,2])
                    {
                        "sub" > receiveValue($0)
                    }
                },
            expectations2:
                {
                    forEach("aaa", [1,2])
                    {
                        "sub" > receiveValue($0)
                        "sub" > receiveCompletion(.finished)
                    }
                },
            expectResult: .notEqual)
    }

    
    func test__forEach__String__all_equal__equal()
    {
        _test(
            expectations1:
                {
                    forEach("aaa", ["a","b"])
                    {
                        "sub" > receiveValue($0)
                    }
                },
            expectations2:
                {
                    forEach("aaa", ["a","b"])
                    {
                        "sub" > receiveValue($0)
                    }
                },
            expectResult: .equal)
    }

    
    func test__forEach__different_types__notSupported()
    {
        _test(
            expectations1:
                {
                    forEach("aaa", [1,2])
                    {
                        value in
                        
                        "sub" > receiveCompletion(.finished)
                    }
                },
            expectations2:
                {
                    forEach("aaa", ["a","b"])
                    {
                        value in
                        
                        "sub" > receiveCompletion(.finished)
                    }
                },
            expectResult: .unableToEquate(reason: .forEachWithUnsupportedGenericType))
    }

    
    func test__forEach__Double__notSupported()
    {
        _test(
            expectations1:
                {
                    forEach("aaa", [1.0, 1.1])
                    {
                        "sub" > receiveValue($0)
                    }
                },
            expectations2:
                {
                    forEach("aaa", [1.0, 1.1])
                    {
                        "sub" > receiveValue($0)
                    }
                },
            expectResult: .unableToEquate(reason: .forEachWithUnsupportedGenericType))
    }
    
    
    // MARK: - FUNCTION CALL
    
    func test__function_call__all_matching__equal()
    {
        _test(
            expectations1:
                {
                    let function =
                    {
                        (value: Int) in
                        
                        Function("function")
                        {
                            "sub" > receiveValue(value)
                        }
                    }
                    
                    call(function(1), "aaa")
                },
            expectations2:
                {
                    let function =
                    {
                        (value: Int) in

                        Function("function")
                        {
                            "sub" > receiveValue(value)
                        }
                    }
                    
                    call(function(1), "aaa")
                },
            expectResult: .equal)
    }

    
    func test__function_call__mismatching_context__notEqual()
    {
        _test(
            expectations1:
                {
                    let function =
                    {
                        (value: Int) in
                        
                        Function("function")
                        {
                            "sub" > receiveValue(value)
                        }
                    }
                    
                    call(function(1), "aaa")
                },
            expectations2:
                {
                    let function =
                    {
                        (value: Int) in

                        Function("function")
                        {
                            "sub" > receiveValue(value)
                        }
                    }
                    
                    call(function(1), "bbb")
                },
            expectResult: .notEqual)
    }

    
    func test__function_call__mismatching_structure__notEqual()
    {
        _test(
            expectations1:
                {
                    let function =
                    {
                        (value: Int) in
                        
                        Function("function")
                        {
                            "sub" > receiveValue(value)
                        }
                    }
                    
                    call(function(1), "aaa")
                },
            expectations2:
                {
                    let function =
                    {
                        (value: Int) in

                        Function("function")
                        {
                            "sub" > receiveValue(value)
                            "sub" > receiveCompletion(.finished)
                        }
                    }
                    
                    call(function(1), "aaa")
                },
            expectResult: .notEqual)
    }
    
    
    // MARK: - GROUP
    
    func test__group__all_matching__equal()
    {
        _test(
            expectations1:
                {
                    group("aaa")
                    {
                        "sub" > receiveValue(1)
                    }
                },
            expectations2:
                {
                    group("aaa")
                    {
                        "sub" > receiveValue(1)
                    }
                },
            expectResult: .equal)
    }

    
    func test__group__mismatching_title__notEqual()
    {
        _test(
            expectations1:
                {
                    group("aaa")
                    {
                        "sub" > receiveValue(1)
                    }
                },
            expectations2:
                {
                    group("bbb")
                    {
                        "sub" > receiveValue(1)
                    }
                },
            expectResult: .notEqual)
    }

    
    func test__group__mismatching_structure__notEqual()
    {
        _test(
            expectations1:
                {
                    group("aaa")
                    {
                        "sub" > receiveValue(1)
                    }
                },
            expectations2:
                {
                    group("aaa")
                    {
                        "sub" > receiveValue(1)
                        "sub" > receiveValue(2)
                    }
                },
            expectResult: .notEqual)
    }

    
    // MARK: - NOT
    
    func test__not__matching_structure__equal()
    {
        _test(
            expectations1:
                {
                    not
                    {
                        "sub" > receiveValue(1)
                    }
                },
            expectations2:
                {
                    not
                    {
                        "sub" > receiveValue(1)
                    }
                },
            expectResult: .equal)
    }

    
    func test__not__mismatching_structure__notEqual()
    {
        _test(
            expectations1:
                {
                    not
                    {
                        "sub" > receiveValue(1)
                    }
                },
            expectations2:
                {
                    not
                    {
                        "sub" > receiveValue(1)
                        "sub" > receiveValue(2)
                    }
                },
            expectResult: .notEqual)
    }

    
    // MARK: - SECTION
    
    func test__section__all_matching__equal()
    {
        _test(
            expectations1:
                {
                    section("aaa")
                    {
                        "sub" > receiveValue(1)
                    }
                },
            expectations2:
                {
                    section("aaa")
                    {
                        "sub" > receiveValue(1)
                    }
                },
            expectResult: .equal)
    }

    
    func test__section__mismatching_title__notEqual()
    {
        _test(
            expectations1:
                {
                    section("aaa")
                    {
                        "sub" > receiveValue(1)
                    }
                },
            expectations2:
                {
                    section("bbb")
                    {
                        "sub" > receiveValue(1)
                    }
                },
            expectResult: .notEqual)
    }

    
    func test__section__mismatching_structure__notEqual()
    {
        _test(
            expectations1:
                {
                    section("aaa")
                    {
                        "sub" > receiveValue(1)
                    }
                },
            expectations2:
                {
                    section("aaa")
                    {
                        "sub" > receiveValue(1)
                        "sub" > receiveValue(2)
                    }
                },
            expectResult: .notEqual)
    }

    
    // MARK: - STRICT
    
    func test__strict__all_matching__equal()
    {
        _test(
            expectations1:
                {
                    strict(.receiveValue)
                    {
                        "sub" > receiveValue(1)
                    }
                },
            expectations2:
                {
                    strict(.receiveValue)
                    {
                        "sub" > receiveValue(1)
                    }
                },
            expectResult: .equal)
    }

    
    func test__strict__mismatching_strictness__notEqual()
    {
        _test(
            expectations1:
                {
                    strict(.receiveValue)
                    {
                        "sub" > receiveValue(1)
                    }
                },
            expectations2:
                {
                    strict(.receiveCompletion)
                    {
                        "sub" > receiveValue(1)
                    }
                },
            expectResult: .notEqual)
    }

    
    func test__strict__mismatching_structure__notEqual()
    {
        _test(
            expectations1:
                {
                    strict(.receiveValue)
                    {
                        "sub" > receiveValue(1)
                    }
                },
            expectations2:
                {
                    strict(.receiveValue)
                    {
                        "sub" > receiveValue(1)
                        "sub" > receiveValue(2)
                    }
                },
            expectResult: .notEqual)
    }

    
    // MARK: - UNORDERED
    
    func test__unordered__matching_structure__equal()
    {
        _test(
            expectations1:
                {
                    unordered
                    {
                        "sub" > receiveValue(1)
                        "sub" > receiveValue(2)
                    }
                },
            expectations2:
                {
                    unordered
                    {
                        "sub" > receiveValue(1)
                        "sub" > receiveValue(2)
                    }
                },
            expectResult: .equal)
    }

    
    func test__unordered__mismatching_structure__notEqual()
    {
        _test(
            expectations1:
                {
                    unordered
                    {
                        "sub" > receiveValue(1)
                        "sub" > receiveValue(2)
                    }
                },
            expectations2:
                {
                    unordered
                    {
                        "sub" > receiveValue(1)
                        "sub" > receiveValue(2)
                        "sub" > receiveValue(3)
                    }
                },
            expectResult: .notEqual)
    }

    
    func test__unordered__differently_ordered_structure__notEqual()
    {
        _test(
            expectations1:
                {
                    unordered
                    {
                        "sub" > receiveValue(1)
                        "sub" > receiveValue(2)
                    }
                },
            expectations2:
                {
                    unordered
                    {
                        "sub" > receiveValue(2)
                        "sub" > receiveValue(1)
                    }
                },
            expectResult: .notEqual)
    }

    

}


// MARK: - generic test func

fileprivate
func _test
(
    @ExpectationBuilder expectations1 buildExpectations1: () -> [Expectation],
    @ExpectationBuilder expectations2 buildExpectations2: () -> [Expectation],
    expectResult expectedResult: EquateExpectationStructureResult,
    file: StaticString = #file,
    line: UInt = #line
)
{
    let expectations1 = buildExpectations1()
    let expectations2 = buildExpectations2()
    
    let actualResult = equateExpectationStructures(expectations1,
                                                   expectations2)

    let isMatching: Bool
    
    switch (expectedResult, actualResult)
    {
        case
            (.equal, .equal),
            (.notEqual, .notEqual):
            
            isMatching = true

            
        case (.unableToEquate(let reason1), .unableToEquate(let reason2)):
            
            switch (reason1, reason2)
            {
                case
                    (.combineTestVariant, .combineTestVariant),
                    (.forEachWithUnsupportedGenericType, .forEachWithUnsupportedGenericType):
                    
                    isMatching = true
                    
                    
                default:

                    isMatching = false
            }
            
            
        default:

            isMatching = false
    }
    
    if isMatching == false
    {
        XCTFail("mismatching result, expected: `\(expectedResult)`, actual: `\(actualResult)`",
                file: file,
                line: line)
    }
}
