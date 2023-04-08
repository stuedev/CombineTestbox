//
//  Testbox_finish_Tests.swift
//  
//
//  Created by Stefan Ueter on 30.03.23.
//

import Foundation
@testable import CombineTestbox
import XCTest
import TestUtility


class Testbox_finish_Tests: XCTestCase
{
    // MARK: - report event
    
    
    
    // MARK: expectations fulfilled
    
    /**
     Scenario:
     
     Expectations fulfill right after the event was reported.
     
     
     Expectation:
     
     Testbox finishes with success right after the event was reported.
     */
    func test__expectations_fulfilled__after_report__testbox_success()
    {
        // arrange
        
        let sut_testbox =
            Testbox
            {
                "sub" > receiveValue(1)
            }

        sut_testbox.config.recorder = { _ in }

        let event = Event.combineEvent(probe: "sub",
                                       type: .receiveValue(1))
        
        
        // act
        
        sut_testbox.reportEvent(event)
        
        
        // assert
        
        guard case .succeeded = sut_testbox.state
        else
        {
            XCTFail()
            return
        }
    }
    
    
    // MARK: expectations not fulfilled
    
    /**
     Scenario:
     
     Expectations remain idle.
     
     
     Expectation:
     
     Testbox does not finish, remains *idle*.
     */
    func test__expectations_not_fulfilled__testbox_idle()
    {
        // arrange
        
        let sut_testbox =
            Testbox
            {
                "sub" > receiveValue(1)
            }
        
        sut_testbox.config.recorder = { _ in }
        
        
        // assert
        
        guard case .idle = sut_testbox.state
        else
        {
            XCTFail()
            return
        }
    }

    
    // MARK: expectations failed
    
    /**
     Scenario:
     
     Expectations fail right after event was reported.
     
     
     Expectation:
     
     Testbox finishes with failure right after event was reported.
     */
    func test__expectations_failed__after_report__testbox_failed()
    {
        // arrange
        
        let sut_testbox =
            Testbox
            {
                strict(.receiveValue)
                {
                    "sub" > receiveValue(1)
                }
            }
        
        sut_testbox.config.recorder = { _ in }

        let event = Event.combineEvent(probe: "sub",
                                       type: .receiveValue(2))
        
        
        // act
        
        sut_testbox.reportEvent(event)
        
        
        // assert
        
        guard case .failed(let expectation, let failure, let isRedeemed) = sut_testbox.state
        else
        {
            XCTFail()
            return
        }
        
        guard case .equal = equateExpectations(expectation,
                                               "sub" > receiveValue(1))
        else
        {
            XCTFail()
            return
        }
        
        guard equateFailures(failure,
                             mismatching .. "sub" > receiveValue(2))
        else
        {
            XCTFail()
            return
        }
        
        guard isRedeemed == false
        else
        {
            XCTFail()
            return
        }
    }

    
    // MARK: - timeout
    
    
    
    // MARK: expectations fulfilled
    
    /**
     Scenario:
     
     Expectations fulfill after timeout.
     
     
     Expectation:
     
     Testbox remains *idle* right after event was reported.
     
     Testbox finishes with success after timeout.
     
     
     Note:
     
      *strict* is fulfilled during the *finalize* pass.
     */
    func test__expectations_fulfilled__after_timeout__testbox_idle_then_success()
    {
        // arrange
        
        let sut_testbox =
            Testbox
            {
                strict(.receiveValue)
                {
                    "sub" > receiveValue(1)
                }
            }
        
        let event = Event.combineEvent(probe: "sub",
                                       type: .receiveValue(1))
        
        
        // act
        
        sut_testbox.reportEvent(event)
        
        
        // assert
        
        guard case .idle = sut_testbox.state
        else
        {
            XCTFail()
            return
        }
        
        
        // act
        
        sut_testbox.wait(timeout: 0.1)
        
        
        // assert
        
        guard case .succeeded = sut_testbox.state
        else
        {
            XCTFail()
            return
        }
    }
    

    // MARK: expectations failed
    
    /**
     Scenario:
     
     Expectations remain unfulfilled after timeout.
     
     
     Expectation:
     
     Testbox fails with *unfulfilled* after timeout.
     */
    func test__timeout_finalize__failure()
    {
        // arrange
        
        let sut_testbox =
            Testbox
            {
                strict(.receiveValue)
                {
                    "sub" > receiveValue(1)
                }
            }
        
        sut_testbox.config.recorder = { _ in }

        
        // assert
        
        guard case .idle = sut_testbox.state
        else
        {
            XCTFail()
            return
        }
        
        
        // act
        
        sut_testbox.wait(timeout: 0.1)
        
        
        // assert
        
        guard case .failed(let expectation, let failure, let isRedeemed) = sut_testbox.state
        else
        {
            XCTFail()
            return
        }
        
        guard case .equal = equateExpectations(expectation,
                                               "sub" > receiveValue(1))
        else
        {
            XCTFail()
            return
        }
        
        guard equateFailures(failure,
                             unfulfilled)
        else
        {
            XCTFail()
            return
        }
        
        guard isRedeemed == false
        else
        {
            XCTFail()
            return
        }
    }
}
