//
//  FeatureTestCase.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation
@testable import CombineTestbox
import Combine
import XCTest
import GeneratedTestCase
import TestUtility


class FeatureTestCase: GeneratedTestCase
{
    // MARK: __testFocussed
    
    static
    func __testFocussed
    (
        _ name: String,
        setup: @escaping SetupClosure,
        @ExpectationBuilder expectations buildExpectations: () -> [Expectation],
        @ExpectationBuilder expectationsInverse buildExpectationsInverse: () -> [Expectation],
        focusNormal: Bool,
        focusSingleInverse: Bool,
        focusDoubleInverse: Bool,
        focusTripleInverse: Bool,
        reportedEvents: EventTypeOptions?,
        buildDebug: (BuildDebugConfigClosure)?,
        guaranteeStructureIsEqual: Bool?,
        file: StaticString = #file,
        line: UInt = #line
    )
    -> [Test]
    {
        let expectationsNormal = buildExpectations()
        let expectationsInverse = buildExpectationsInverse()
        
        if guaranteeStructureIsEqual == true
        {
            // ok
        }
        else
        {
            let result = equateExpectationStructures(expectationsNormal,
                                                     expectationsInverse)
            
            switch result
            {
                case .equal:
                    
                    break   // ok
                    
                    
                case .notEqual:

                    fatal_inconsistentStructure(name: name,
                                                info: nil,
                                                expectationsNormal,
                                                expectationsInverse)
                    
                    
                case .unableToEquate(let reason):
                    
                    fatal_inconsistentStructure(name: name,
                                                info: reason.description,
                                                expectationsNormal,
                                                expectationsInverse)
            }
        }
        
        let Tests =
        [
            __testNormal(name: name,
                         setup: setup,
                         buildExpectations: buildExpectations,
                         isFocussed: focusNormal,
                         reportedEvents: reportedEvents,
                         buildDebug: buildDebug,
                         file: file,
                         line: line),
            
            __testSingleInversion(name: name,
                                  setup: setup,
                                  buildExpectations: buildExpectationsInverse,
                                  isFocussed: focusSingleInverse,
                                  reportedEvents: reportedEvents,
                                  buildDebug: buildDebug,
                                  file: file,
                                  line: line),
            
            __testDoubleInversion(name: name,
                                  setup: setup,
                                  buildExpectations: buildExpectations,
                                  isFocussed: focusDoubleInverse,
                                  reportedEvents: reportedEvents,
                                  buildDebug: buildDebug,
                                  file: file,
                                  line: line),

            __testTripleInversion(name: name,
                                  setup: setup,
                                  buildExpectations: buildExpectationsInverse,
                                  isFocussed: focusTripleInverse,
                                  reportedEvents: reportedEvents,
                                  buildDebug: buildDebug,
                                  file: file,
                                  line: line)
        ]
        
        return Tests
    }

    
    
    // MARK: __testNormal
    
    private
    static
    func __testNormal
    (
        name: String,
        setup: @escaping SetupClosure,
        @ExpectationBuilder buildExpectations: () -> [Expectation],
        isFocussed: Bool,
        reportedEvents: EventTypeOptions? = nil,
        buildDebug: (BuildDebugConfigClosure)?,
        file: StaticString = #file,
        line: UInt = #line
    )
    -> Test
    {
        __test(name: name + " (normal)",
               setup: setup,
               expectations: buildExpectations(),
               isFocussed: isFocussed,
               reportedEvents: reportedEvents,
               buildDebug: buildDebug,
               file: file,
               line: line)
    }

    
    // MARK: __testSingleInversion
    
    private
    static
    func __testSingleInversion
    (
        name: String,
        setup: @escaping SetupClosure,
        @ExpectationBuilder buildExpectations: () -> [Expectation],
        isFocussed: Bool,
        reportedEvents: EventTypeOptions? = nil,
        buildDebug: (BuildDebugConfigClosure)?,
        file: StaticString = #file,
        line: UInt = #line
    )
    -> Test
    {
        let expectations =
            CombineTestbox.buildExpectations
            {
                not(buildExpectations: buildExpectations)
            }
        
        return
            __test(name: name + " (inverted)",
                   setup: setup,
                   expectations: expectations,
                   isFocussed: isFocussed,
                   reportedEvents: reportedEvents,
                   buildDebug: buildDebug,
                   file: file,
                   line: line)
    }

    
    // MARK: __testDoubleInversion
    
    private
    static
    func __testDoubleInversion
    (
        name: String,
        setup: @escaping SetupClosure,
        @ExpectationBuilder buildExpectations: () -> [Expectation],
        isFocussed: Bool,
        reportedEvents: EventTypeOptions? = nil,
        buildDebug: (BuildDebugConfigClosure)?,
        file: StaticString = #file,
        line: UInt = #line
    )
    -> Test
    {
        let expectations =
            CombineTestbox.buildExpectations
            {
                not
                {
                    not(buildExpectations: buildExpectations)
                }
            }
        
        return
            __test(name: name + " (double inverted)",
                   setup: setup,
                   expectations: expectations,
                   isFocussed: isFocussed,
                   reportedEvents: reportedEvents,
                   buildDebug: buildDebug,
                   file: file,
                   line: line)
    }

    
    // MARK: __testTripleInversion
    
    private
    static
    func __testTripleInversion
    (
        name: String,
        setup: @escaping SetupClosure,
        @ExpectationBuilder buildExpectations: () -> [Expectation],
        isFocussed: Bool,
        reportedEvents: EventTypeOptions? = nil,
        buildDebug: (BuildDebugConfigClosure)?,
        file: StaticString = #file,
        line: UInt = #line
    )
    -> Test
    {
        let expectations =
            CombineTestbox.buildExpectations
            {
                not
                {
                    not
                    {
                        not(buildExpectations: buildExpectations)
                    }
                }
            }
        
        return
            __test(name: name + " (triple inverted)",
                   setup: setup,
                   expectations: expectations,
                   isFocussed: isFocussed,
                   reportedEvents: reportedEvents,
                   buildDebug: buildDebug,
                   file: file,
                   line: line)
    }

    
    
    
    // MARK: __test
    
    private
    static
    func __test
    (
        name: String,
        setup: @escaping SetupClosure,
        expectations: [Expectation],
        isFocussed: Bool,
        reportedEvents: EventTypeOptions? = nil,
        buildDebug: (BuildDebugConfigClosure)?,
        file: StaticString = #file,
        line: UInt = #line
    )
    -> Test
    {
        let expectedFailures = findExpectedFailures(in: expectations)
        
        let firstExpectedFailure = expectedFailures.first
        
        let expectedResultString: String
        
        if let firstExpectedFailure
        {
            expectedResultString = shortStringForFailure(firstExpectedFailure.expectedFailure.failure)
        }
        else
        {
            expectedResultString = "success"
        }

        let modifiedName = name + " -> " + expectedResultString
        
        let block =
        {
            let testbox = Testbox(expectations: expectations)
            
            if let reportedEvents
            {
                testbox.config.reportedEvents = reportedEvents
            }
            
            if let buildDebug
            {
                var debugOptions = CombineTestbox.DebugConfig()
                buildDebug(&debugOptions)
                testbox.config.debug = debugOptions
            }
            
            let subject = PassthroughSubject<Int, Error>()
            
            let sub = subject.testSink(testbox, probe: "sub")
            
            setup(testbox, subject, sub)
            
            testbox.wait(timeout: 0.001)    // 1 ms
            
            checkTestboxState(testbox.state,
                              with: firstExpectedFailure,
                              file: file,
                              line: line)
        }
        
        return
            .init(name: modifiedName,
                  block: block,
                  isFocussed: isFocussed)
    }
}


// MARK: checkTestboxState

/**
 checks if the *TestboxState* matches the expectedFailure
 */
func checkTestboxState
(
    _ state: TestboxState,
    with expectedFailure: (Expectation, ExpectedFailure)?,
    file: StaticString = #file,
    line: UInt = #line
)
{
    switch (state, expectedFailure)
    {
        case (.idle, _):
            
            fatalError("unexpected")

            
        case
            (.succeeded, .some):
            
            let message = "testbox succeeded dispite expectedFailure"
            
            XCTFail(message,
                    file: file,
                    line: line)
            
            return

            
        case
            (.succeeded, .none),
            (.failed, .none):
            
            break
            
            
        case (.failed(let actual_expectation, let actual_failure, _), .some((_, let expected_expectedFailure))):

            let expected_failure = unwrapFailure(expected_expectedFailure.failure)

            guard expected_failure.equals(actual_failure)
            else
            {
                let message = "mismatching expected failure. expected `\(expected_failure.description)`, actual: `\(actual_failure.description)`"
                
                XCTFail(message,
                        file: file,
                        line: line)
                
                return
            }

            guard let actual_expectedFailure = actual_expectation.expectedFailure
            else
            {
                let message = "failed expectation has no expectedFailure"
                
                XCTFail(message,
                        file: file,
                        line: line)
                
                return
            }
            
            guard actual_expectedFailure.failure.equals(expected_failure)
            else
            {
                let message = "mismatching expected failure on (actual) failed expectation. expected `\(expected_failure)`, actual: `\(actual_expectedFailure.failure)`"
                
                XCTFail(message,
                        file: file,
                        line: line)
                
                return
            }
    }
}


// MARK: fatal_inconsistentStructure

fileprivate
func fatal_inconsistentStructure
(
    name: String,
    info: String?,
    _ expectations1: [Expectation],
    _ expectations2: [Expectation]
)
{
    let string =
        """
        structure of both expectation builders is not equal
        
        test case name: "\(name)"
        
        info: \(info ?? "<none>")
        
        expectations 1:
        \({
            let config = FinalTreeConfig()
            
            var string = ""
            
            for exp in expectations1
            {
                string += exp.finalTree(config: config)
            }
        
            return string
        }())

        expectations 2:
        \({
            let config = FinalTreeConfig()
            
            var string = ""
            
            for exp in expectations2
            {
                string += exp.finalTree(config: config)
            }
        
            return string
        }())
        
        """

    fatalError(string)
}



// MARK: typealiases

public
typealias SetupClosure = (Testbox, PassthroughSubject<Int, Error>, Cancellable) -> Void

public
typealias BuildDebugConfigClosure = (inout CombineTestbox.DebugConfig) -> Void
