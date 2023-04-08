//
//  TestboxRootExpectation_state_Tests.swift
//  
//
//  Created by Stefan Ueter on 30.03.23.
//

import Foundation
@testable import CombineTestbox
import Combine
import XCTest
import TestUtility


class TestboxRootExpectation_state_Tests: XCTestCase
{
    // MARK: - test
    
    
    
    // MARK: expectations fulfilled
    
    /**
     Scenario:
     
     Expectations fulfill right after event being tested.
     
     
     Expectation:
     
     TestboxRootExpectation is fulfilled right after event being tested.
     */
    func test__expectations_fulfilled__after_test__root_fulfills()
    {
        // arrange
        
        let expectations =
            buildExpectations
            {
                "sub" > receiveValue(1)
            }

        let sourceInfo = SourceInfo(file: #file, line: #line)

        let sut_rootExpectation = TestboxRootExpectation(expectations: expectations,
                                                     sourceInfo: sourceInfo)
        
        let logger = StubbedLogger()
        
        sut_rootExpectation.config = .init()
        sut_rootExpectation.config.logger = logger
        sut_rootExpectation.config.recorder = { _ in }

        sut_rootExpectation.postInit()
        
        let event = Event.combineEvent(probe: "sub",
                                       type: .receiveValue(1))
        event.logger = logger
        
        let context = TestContext()
        
        
        // act
        
        do
        {
            try sut_rootExpectation.test(with:event,
                                     context: context)
        }
        catch
        {
            XCTFail()
            return
        }
        
        
        // assert
        
        guard case .fulfilled = sut_rootExpectation.state
        else
        {
            XCTFail()
            return
        }
    }

    
    // MARK: expectations failed
    
    /**
     Scenario:
     
     Expectations failed right after event being tested.
     
     
     Expectation:
     
     TestboxRootExpectation remains *idle* right after event being tested.
     */
    func test__expectations_failed__after_test__root_idle()
    {
        // arrange
        
        let expectations =
            buildExpectations
            {
                strict(.receiveValue)
                {
                    "sub" > receiveValue(1)     // mismatching
                }
            }

        let sourceInfo = SourceInfo(file: #file, line: #line)

        let sut_rootExpectation = TestboxRootExpectation(expectations: expectations,
                                                     sourceInfo: sourceInfo)
        
        let logger = StubbedLogger()
        
        sut_rootExpectation.config = .init()
        sut_rootExpectation.config.logger = logger
        sut_rootExpectation.config.recorder = { _ in }

        sut_rootExpectation.postInit()
        
        let event = Event.combineEvent(probe: "sub",
                                       type: .receiveValue(2))
        event.logger = logger
        
        let context = TestContext()
        
        
        // act
        
        do
        {
            try sut_rootExpectation.test(with:event,
                                     context: context)
        }
        catch
        {
            // ignore failure
        }
        
        
        // assert
        
        guard case .idle = sut_rootExpectation.state
        else
        {
            XCTFail()
            return
        }
    }

    
    // MARK: - finalize
    
    
    
    // MARK: expectations fulfilled

    /**
     Scenario:
     
     Expectations fulfilled after being finalized.
     
     
     Expectation:
     
     TestboxRootExpectation fulfills after being finalized.
     */
    func test__expectations_fulfilled__after_finalize__root_fulfills()
    {
        // arrange
        
        let expectations =
            buildExpectations
            {
                strict(.receiveValue)
                {
                    "sub" > receiveValue(1)
                }
            }

        let sourceInfo = SourceInfo(file: #file, line: #line)

        let sut_rootExpectation = TestboxRootExpectation(expectations: expectations,
                                                     sourceInfo: sourceInfo)
        
        let logger = StubbedLogger()
        
        sut_rootExpectation.config = .init()
        sut_rootExpectation.config.logger = logger
        sut_rootExpectation.config.recorder = { _ in }

        sut_rootExpectation.postInit()
        
        let event = Event.combineEvent(probe: "sub",
                                       type: .receiveValue(1))
        event.logger = logger
        
        let context = TestContext()
        
        
        // act
        
        do
        {
            try sut_rootExpectation.test(with:event,
                                     context: context)
        }
        catch
        {
            XCTFail()
            return
        }
        
        
        // assert
        
        guard case .idle = sut_rootExpectation.state
        else
        {
            XCTFail()
            return
        }
        
        
        // act
        
        do
        {
            try sut_rootExpectation.finalize()
        }
        catch
        {
            XCTFail()
            return
        }
        
        
        // assert
        
        guard case .fulfilled = sut_rootExpectation.state
        else
        {
            XCTFail()
            return
        }
    }

    
    // MARK: expectations failed

    /**
     Scenario:
     
     Expectations failed after being finalized.
     
     
     Expectation:
     
     TestboxRootExpectation remains idle after being finalized.
     */
    func test__expectations_failed__after_finalize__root_idle()
    {
        // arrange
        
        let expectations =
            buildExpectations
            {
                strict(.receiveValue)
                {
                    "sub" > receiveValue(1)
                    "sub" > receiveValue(2)     // unfulfilled
                }
            }

        let sourceInfo = SourceInfo(file: #file, line: #line)

        let sut_rootExpectation = TestboxRootExpectation(expectations: expectations,
                                                         sourceInfo: sourceInfo)
        
        let logger = StubbedLogger()
        
        sut_rootExpectation.config = .init()
        sut_rootExpectation.config.logger = logger
        sut_rootExpectation.config.recorder = { _ in }

        sut_rootExpectation.postInit()
        
        let event = Event.combineEvent(probe: "sub",
                                       type: .receiveValue(1))
        event.logger = logger
        
        let context = TestContext()
        
        
        // act
        
        do
        {
            try sut_rootExpectation.test(with:event,
                                     context: context)
        }
        catch
        {
            XCTFail()
            return
        }
        
        
        // assert
        
        guard case .idle = sut_rootExpectation.state
        else
        {
            XCTFail()
            return
        }
        
        
        // act
        
        do
        {
            try sut_rootExpectation.finalize()
        }
        catch
        {
            // ignore failure
        }
        
        
        // assert
        
        guard case .idle = sut_rootExpectation.state
        else
        {
            XCTFail()
            return
        }
    }

}
