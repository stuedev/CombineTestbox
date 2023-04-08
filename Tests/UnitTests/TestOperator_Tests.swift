//
//  TestOperator_Tests.swift
//  
//
//  Created by Stefan Ueter on 30.03.23.
//

import Foundation
@testable import CombineTestbox
import Combine
import XCTest
import Nimble


class TestOperator_Tests: XCTestCase
{
    // MARK: receiveSubscriber
    
    func test_receiveSubscriber()
    {
        test_TestOperator_EventType(
            act:
                {
                    sut_testOperator in
                    
                    let subscriber = Subscriber_Stub()
                    
                    sut_testOperator.receive(subscriber: subscriber)
                },
            testEventType:
                {
                    switch $0
                    {
                        case .receiveSubscriber("Subscriber_Stub"):     return true
                        default:                                        return false
                    }
                }
        )
    }
    

    // MARK: receiveSubscription
    
    func test_receiveSubscription()
    {
        test_TestOperator_Inner_EventType(
            act:
                {
                    sut_testOperatorInner in
                    
                    let subscription = Subscription_Stub()
                    
                    sut_testOperatorInner.receive(subscription: subscription)
                },
            testEventType:
                {
                    switch $0
                    {
                        case .receiveSubscription("Subscription_Stub"):     return true
                        default:                                            return false
                    }
                }
        )
    }

    
    // MARK: receiveValue
    
    func test_receiveValue()
    {
        test_TestOperator_Inner_EventType(
            act:
                {
                    sut_testOperatorInner in
                    
                    _ = sut_testOperatorInner.receive(1)
                },
            testEventType:
                {
                    switch $0
                    {
                        case .receiveValue(let value):
                            
                            return equateAny(value, 1)
                        
                        default:    return false
                    }
                },
            expectedEventCount: 2,  // .receiveValue, .requestSyncDemand
            eventIndexToTest: 0     // first event
        )
    }

    
    // MARK: receiveCompletion
    
    func test_receiveCompletion_finished()
    {
        test_TestOperator_Inner_EventType(
            act:
                {
                    sut_testOperatorInner in
                    
                    sut_testOperatorInner.receive(completion: .finished)
                },
            testEventType:
                {
                    switch $0
                    {
                        case .receiveCompletion(.finished):     return true
                        default:                                return false
                    }
                }
        )
    }

    
    func test_receiveCompletion_failure()
    {
        test_TestOperator_Inner_EventType(
            act:
                {
                    sut_testOperatorInner in
                    
                    sut_testOperatorInner.receive(completion: .failure(DummyError("aaa")))
                },
            testEventType:
                {
                    switch $0
                    {
                        case .receiveCompletion(.failure(let error)):
                            
                            return type(of: error) == DummyError.self
                            
                        default:    return false
                    }
                }
        )
    }

    
    // MARK: requestDemand
    
    func test_requestDemand()
    {
        test_TestOperator_Inner_EventType(
            act:
                {
                    sut_testOperatorInner in
                    
                    sut_testOperatorInner.request(.max(1))
                },
            testEventType:
                {
                    switch $0
                    {
                        case .requestDemand(.max(1)):   return true
                        default:                        return false
                    }
                }
        )
    }

    
    // MARK: requestSyncDemand
    
    func test_requestSyncDemand()
    {
        test_TestOperator_Inner_EventType(
            act:
                {
                    sut_testOperatorInner in
                    
                    _ = sut_testOperatorInner.receive(1)
                },
            testEventType:
                {
                    switch $0
                    {
                        case .requestSyncDemand(Subscriber_Stub.syncDemand):    return true
                        default:                                                return false
                    }
                },
            expectedEventCount: 2,  // receiveValue, requestSyncDemand
            eventIndexToTest: 1     // second event
        )
    }

    
    // MARK: requestSyncDemand
    
    func test_cancel()
    {
        test_TestOperator_Inner_EventType(
            act:
                {
                    sut_testOperatorInner in
                    
                    sut_testOperatorInner.cancel()
                },
            testEventType:
                {
                    switch $0
                    {
                        case .cancel:   return true
                        default:        return false
                    }
                }
        )
    }

}



// MARK: - test methods

func test_TestOperator_EventType
(
    act: (TestOperator<Int, Error>) -> Void,
    testEventType: @escaping (CombineEventType) -> Bool,
    file: StaticString = #file,
    line: UInt = #line
)
{
    // arrange
    
    let upstream = Publisher_Stub()
    let testbox = Testbox_Mock()
    
    let sut_testOperator = TestOperator(upstream: upstream,
                                        testbox: testbox,
                                        probe: "aaa")
    
    
    // act

    act(sut_testOperator)
    
    
    // assert
    
    expect(file: file,
           line: line,
           testbox.events)
        .to(haveCount(1))
    
    let firstEvent = testbox.events.first!
    
    expect(file: file,
           line: line,
           firstEvent.type)
        .to(
            passTest
            {
                if case .combine = $0 { return true }
                else { return false }
            }
        )
    
    guard case .combine(_, let combineEvent) = firstEvent.type
    else
    {
        fatalError()    // we just checked the case before
    }
    
    expect(file: file,
           line: line,
           combineEvent).to(passTest(testEventType))
}


func test_TestOperator_Inner_EventType
(
    act: (TestOperator<Int, Error>.Inner) -> Void,
    testEventType: @escaping (CombineEventType) -> Bool,
    expectedEventCount: Int = 1,
    eventIndexToTest: Int = 0,
    file: StaticString = #file,
    line: UInt = #line
)
{
    // arrange
    
    let upstream = Publisher_Stub()
    let subscriber = Subscriber_Stub()
    let testbox = Testbox_Mock()
    
    let sut_testOperatorInner = TestOperator.Inner(upstream: upstream,
                                                   subscriber: subscriber,
                                                   testbox: testbox,
                                                   probe: "aaa")
    
    
    // act
    
    act(sut_testOperatorInner)
    
    
    // assert
    
    expect(file: file,
           line: line,
           testbox.events)
        .to(haveCount(expectedEventCount))
    
    guard let eventToTest = testbox.events[safe: eventIndexToTest]
    else
    {
        fail()
        
        return
    }
    
    expect(file: file,
           line: line,
           eventToTest.type)
        .to(
            passTest
            {
                if case .combine = $0 { return true }
                else { return false }
            }
        )

    guard case .combine(_, let combineEvent) = eventToTest.type
    else
    {
        fatalError()    // we just checked the case before
    }

    expect(file: file,
           line: line,
           combineEvent).to(passTest(testEventType))
}
