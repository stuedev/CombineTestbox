//
//  FeatureTestCase+API.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation
import CombineTestbox
import Combine
import GeneratedTestCase


extension FeatureTestCase
{
    // MARK: test
    
    static
    func test
    (
        _ name: String,
        setup: @escaping SetupClosure,
        @ExpectationBuilder expectations buildExpectations: () -> [Expectation],
        @ExpectationBuilder expectationsInverse buildExpectationsInverse: () -> [Expectation],
        reportedEvents: EventTypeOptions? = nil,
        debug buildDebug: (BuildDebugConfigClosure)? = nil,
        GUARANTEE_EQUAL_STRUCTURE guaranteeStructureIsEqual: Bool? = nil,
        file: StaticString = #file,
        line: UInt = #line
    )
    -> [Test]
    {
        __testFocussed(name,
                       setup: setup,
                       expectations: buildExpectations,
                       expectationsInverse: buildExpectationsInverse,
                       focusNormal: false,
                       focusSingleInverse: false,
                       focusDoubleInverse: false,
                       focusTripleInverse: false,
                       reportedEvents: reportedEvents,
                       buildDebug: buildDebug,
                       guaranteeStructureIsEqual: guaranteeStructureIsEqual,
                       file: file,
                       line: line)
    }

    
    static
    func test
    (
        _ name: String,
        setup: @escaping SetupClosure,
        @ExpectationBuilder fexpectations buildExpectations: () -> [Expectation],
        @ExpectationBuilder expectationsInverse buildExpectationsInverse: () -> [Expectation],
        reportedEvents: EventTypeOptions? = nil,
        debug buildDebug: (BuildDebugConfigClosure)? = nil,
        GUARANTEE_EQUAL_STRUCTURE guaranteeStructureIsEqual: Bool? = nil,
        file: StaticString = #file,
        line: UInt = #line
    )
    -> [Test]
    {
        __testFocussed(name,
                       setup: setup,
                       expectations: buildExpectations,
                       expectationsInverse: buildExpectationsInverse,
                       focusNormal: true,
                       focusSingleInverse: false,
                       focusDoubleInverse: false,
                       focusTripleInverse: false,
                       reportedEvents: reportedEvents,
                       buildDebug: buildDebug,
                       guaranteeStructureIsEqual: guaranteeStructureIsEqual,
                       file: file,
                       line: line)
    }

    
    static
    func test
    (
        _ name: String,
        setup: @escaping SetupClosure,
        @ExpectationBuilder expectations buildExpectations: () -> [Expectation],
        @ExpectationBuilder fexpectationsInverse buildExpectationsInverse: () -> [Expectation],
        reportedEvents: EventTypeOptions? = nil,
        debug buildDebug: (BuildDebugConfigClosure)? = nil,
        GUARANTEE_EQUAL_STRUCTURE guaranteeStructureIsEqual: Bool? = nil,
        file: StaticString = #file,
        line: UInt = #line
    )
    -> [Test]
    {
        __testFocussed(name,
                       setup: setup,
                       expectations: buildExpectations,
                       expectationsInverse: buildExpectationsInverse,
                       focusNormal: false,
                       focusSingleInverse: true,
                       focusDoubleInverse: false,
                       focusTripleInverse: false,
                       reportedEvents: reportedEvents,
                       buildDebug: buildDebug,
                       guaranteeStructureIsEqual: guaranteeStructureIsEqual,
                       file: file,
                       line: line)
    }

    
    static
    func test
    (
        _ name: String,
        setup: @escaping SetupClosure,
        @ExpectationBuilder f2expectations buildExpectations: () -> [Expectation],
        @ExpectationBuilder expectationsInverse buildExpectationsInverse: () -> [Expectation],
        reportedEvents: EventTypeOptions? = nil,
        debug buildDebug: (BuildDebugConfigClosure)? = nil,
        GUARANTEE_EQUAL_STRUCTURE guaranteeStructureIsEqual: Bool? = nil,
        file: StaticString = #file,
        line: UInt = #line
    )
    -> [Test]
    {
        __testFocussed(name,
                       setup: setup,
                       expectations: buildExpectations,
                       expectationsInverse: buildExpectationsInverse,
                       focusNormal: false,
                       focusSingleInverse: false,
                       focusDoubleInverse: true,
                       focusTripleInverse: false,
                       reportedEvents: reportedEvents,
                       buildDebug: buildDebug,
                       guaranteeStructureIsEqual: guaranteeStructureIsEqual,
                       file: file,
                       line: line)
    }

    
    static
    func test
    (
        _ name: String,
        setup: @escaping SetupClosure,
        @ExpectationBuilder expectations buildExpectations: () -> [Expectation],
        @ExpectationBuilder f3expectationsInverse buildExpectationsInverse: () -> [Expectation],
        reportedEvents: EventTypeOptions? = nil,
        debug buildDebug: (BuildDebugConfigClosure)? = nil,
        GUARANTEE_EQUAL_STRUCTURE guaranteeStructureIsEqual: Bool? = nil,
        file: StaticString = #file,
        line: UInt = #line
    )
    -> [Test]
    {
        __testFocussed(name,
                       setup: setup,
                       expectations: buildExpectations,
                       expectationsInverse: buildExpectationsInverse,
                       focusNormal: false,
                       focusSingleInverse: false,
                       focusDoubleInverse: false,
                       focusTripleInverse: true,
                       reportedEvents: reportedEvents,
                       buildDebug: buildDebug,
                       guaranteeStructureIsEqual: guaranteeStructureIsEqual,
                       file: file,
                       line: line)
    }

    
    static
    func test
    (
        _ name: String,
        setup: @escaping SetupClosure,
        @ExpectationBuilder fexpectations buildExpectations: () -> [Expectation],
        @ExpectationBuilder fexpectationsInverse buildExpectationsInverse: () -> [Expectation],
        reportedEvents: EventTypeOptions? = nil,
        debug buildDebug: (BuildDebugConfigClosure)? = nil,
        GUARANTEE_EQUAL_STRUCTURE guaranteeStructureIsEqual: Bool? = nil,
        file: StaticString = #file,
        line: UInt = #line
    )
    -> [Test]
    {
        __testFocussed(name,
                       setup: setup,
                       expectations: buildExpectations,
                       expectationsInverse: buildExpectationsInverse,
                       focusNormal: true,
                       focusSingleInverse: true,
                       focusDoubleInverse: false,
                       focusTripleInverse: false,
                       reportedEvents: reportedEvents,
                       buildDebug: buildDebug,
                       guaranteeStructureIsEqual: guaranteeStructureIsEqual,
                       file: file,
                       line: line)
    }

    
    
    // MARK: ftest
    
    static
    func ftest
    (
        _ name: String,
        setup: @escaping SetupClosure,
        @ExpectationBuilder expectations buildExpectations: () -> [Expectation],
        @ExpectationBuilder expectationsInverse buildExpectationsInverse: () -> [Expectation],
        reportedEvents: EventTypeOptions? = nil,
        debug buildDebug: (BuildDebugConfigClosure)? = nil,
        GUARANTEE_EQUAL_STRUCTURE guaranteeStructureIsEqual: Bool? = nil,
        file: StaticString = #file,
        line: UInt = #line
    )
    -> [Test]
    {
        __testFocussed(name,
                       setup: setup,
                       expectations: buildExpectations,
                       expectationsInverse: buildExpectationsInverse,
                       focusNormal: true,
                       focusSingleInverse: true,
                       focusDoubleInverse: true,
                       focusTripleInverse: true,
                       reportedEvents: reportedEvents,
                       buildDebug: buildDebug,
                       guaranteeStructureIsEqual: guaranteeStructureIsEqual,
                       file: file,
                       line: line)
    }

    
    static
    func ftest
    (
        _ name: String,
        setup: @escaping SetupClosure,
        @ExpectationBuilder fexpectations buildExpectations: () -> [Expectation],
        @ExpectationBuilder expectationsInverse buildExpectationsInverse: () -> [Expectation],
        reportedEvents: EventTypeOptions? = nil,
        debug buildDebug: (BuildDebugConfigClosure)? = nil,
        GUARANTEE_EQUAL_STRUCTURE guaranteeStructureIsEqual: Bool? = nil,
        file: StaticString = #file,
        line: UInt = #line
    )
    -> [Test]
    {
        __testFocussed(name,
                       setup: setup,
                       expectations: buildExpectations,
                       expectationsInverse: buildExpectationsInverse,
                       focusNormal: true,
                       focusSingleInverse: false,
                       focusDoubleInverse: false,
                       focusTripleInverse: false,
                       reportedEvents: reportedEvents,
                       buildDebug: buildDebug,
                       guaranteeStructureIsEqual: guaranteeStructureIsEqual,
                       file: file,
                       line: line)
    }

    
    static
    func ftest
    (
        _ name: String,
        setup: @escaping SetupClosure,
        @ExpectationBuilder expectations buildExpectations: () -> [Expectation],
        @ExpectationBuilder fexpectationsInverse buildExpectationsInverse: () -> [Expectation],
        reportedEvents: EventTypeOptions? = nil,
        debug buildDebug: (BuildDebugConfigClosure)? = nil,
        GUARANTEE_EQUAL_STRUCTURE guaranteeStructureIsEqual: Bool? = nil,
        file: StaticString = #file,
        line: UInt = #line
    )
    -> [Test]
    {
        __testFocussed(name,
                       setup: setup,
                       expectations: buildExpectations,
                       expectationsInverse: buildExpectationsInverse,
                       focusNormal: false,
                       focusSingleInverse: true,
                       focusDoubleInverse: false,
                       focusTripleInverse: false,
                       reportedEvents: reportedEvents,
                       buildDebug: buildDebug,
                       guaranteeStructureIsEqual: guaranteeStructureIsEqual,
                       file: file,
                       line: line)
    }

    
    static
    func ftest
    (
        _ name: String,
        setup: @escaping SetupClosure,
        @ExpectationBuilder f2expectations buildExpectations: () -> [Expectation],
        @ExpectationBuilder expectationsInverse buildExpectationsInverse: () -> [Expectation],
        reportedEvents: EventTypeOptions? = nil,
        debug buildDebug: (BuildDebugConfigClosure)? = nil,
        GUARANTEE_EQUAL_STRUCTURE guaranteeStructureIsEqual: Bool? = nil,
        file: StaticString = #file,
        line: UInt = #line
    )
    -> [Test]
    {
        __testFocussed(name,
                       setup: setup,
                       expectations: buildExpectations,
                       expectationsInverse: buildExpectationsInverse,
                       focusNormal: false,
                       focusSingleInverse: false,
                       focusDoubleInverse: true,
                       focusTripleInverse: false,
                       reportedEvents: reportedEvents,
                       buildDebug: buildDebug,
                       guaranteeStructureIsEqual: guaranteeStructureIsEqual,
                       file: file,
                       line: line)
    }

    
    static
    func ftest
    (
        _ name: String,
        setup: @escaping SetupClosure,
        @ExpectationBuilder expectations buildExpectations: () -> [Expectation],
        @ExpectationBuilder f3expectationsInverse buildExpectationsInverse: () -> [Expectation],
        reportedEvents: EventTypeOptions? = nil,
        debug buildDebug: (BuildDebugConfigClosure)? = nil,
        GUARANTEE_EQUAL_STRUCTURE guaranteeStructureIsEqual: Bool? = nil,
        file: StaticString = #file,
        line: UInt = #line
    )
    -> [Test]
    {
        __testFocussed(name,
                       setup: setup,
                       expectations: buildExpectations,
                       expectationsInverse: buildExpectationsInverse,
                       focusNormal: false,
                       focusSingleInverse: false,
                       focusDoubleInverse: false,
                       focusTripleInverse: true,
                       reportedEvents: reportedEvents,
                       buildDebug: buildDebug,
                       guaranteeStructureIsEqual: guaranteeStructureIsEqual,
                       file: file,
                       line: line)
    }

    
    static
    func ftest
    (
        _ name: String,
        setup: @escaping SetupClosure,
        @ExpectationBuilder fexpectations buildExpectations: () -> [Expectation],
        @ExpectationBuilder fexpectationsInverse buildExpectationsInverse: () -> [Expectation],
        reportedEvents: EventTypeOptions? = nil,
        debug buildDebug: (BuildDebugConfigClosure)? = nil,
        GUARANTEE_EQUAL_STRUCTURE guaranteeStructureIsEqual: Bool? = nil,
        file: StaticString = #file,
        line: UInt = #line
    )
    -> [Test]
    {
        __testFocussed(name,
                       setup: setup,
                       expectations: buildExpectations,
                       expectationsInverse: buildExpectationsInverse,
                       focusNormal: true,
                       focusSingleInverse: true,
                       focusDoubleInverse: false,
                       focusTripleInverse: false,
                       reportedEvents: reportedEvents,
                       buildDebug: buildDebug,
                       guaranteeStructureIsEqual: guaranteeStructureIsEqual,
                       file: file,
                       line: line)
    }
}
