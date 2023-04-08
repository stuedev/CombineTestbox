//
//  CombineExpectationType_Tests.swift
//  
//
//  Created by Stefan Ueter on 30.03.23.
//

import Foundation
@testable import CombineTestbox
import Quick
import Nimble


class CombineExpectationType_Tests: QuickSpec
{
    override
    func spec()
    {
        // MARK: receiveSubscriber
        
        describe("receiveSubscriber")
        {
            itBehavesLike(CombineEventType_Behaviour.self)
            {
                .init(event: .receiveSubscriber("aaa"),
                      specificType_matching: .receiveSubscriberSpecific("aaa"),
                      specificType_other: .receiveSubscriberSpecific("aaa"),
                      specificType_notMatching: .receiveSubscriberSpecific("bbb"),
                      unspecificType: .receiveSubscriberUnspecific,
                      unspecificType_other: .receiveSubscriberUnspecific,
                      testType_matching: nil,
                      testType_notMatching: nil,
                      strictness: .receiveSubscriber,
                      relevantTypes:
                        [
                            a_receiveSubscriberSpecific,
                            a_receiveSubscriberUnspecific
                        ])
            }
        }
        
        
        // MARK: receiveSubscription
        
        describe("receiveSubscription")
        {
            itBehavesLike(CombineEventType_Behaviour.self)
            {
                .init(event: .receiveSubscription("aaa"),
                      specificType_matching: .receiveSubscriptionSpecific("aaa"),
                      specificType_other: .receiveSubscriptionSpecific("aaa"),
                      specificType_notMatching: .receiveSubscriptionSpecific("bbb"),
                      unspecificType: .receiveSubscriptionUnspecific,
                      unspecificType_other: .receiveSubscriptionUnspecific,
                      testType_matching: nil,
                      testType_notMatching: nil,
                      strictness: .receiveSubscription,
                      relevantTypes:
                        [
                            a_receiveSubscriptionSpecific,
                            a_receiveSubscriptionUnspecific
                        ])
            }
        }
        
        
        // MARK: receiveValue
        
        describe("receiveValue")
        {
            itBehavesLike(CombineEventType_Behaviour.self)
            {
                .init(event: .receiveValue(1),
                      specificType_matching: .receiveValueSpecific(1),
                      specificType_other: .receiveValueSpecific(1),
                      specificType_notMatching: .receiveValueSpecific(2),
                      unspecificType: .receiveValueUnspecific,
                      unspecificType_other: .receiveValueUnspecific,
                      testType_matching: .receiveValueTest { $0 as? Int == 1 },
                      testType_notMatching: .receiveValueTest { $0 as? Int == 2 },
                      strictness: .receiveValue,
                      relevantTypes:
                        [
                            a_receiveValueSpecific,
                            a_receiveValueUnSpecific,
                            a_receiveValueTest
                        ]
                )
            }
        }

        
        // MARK: receiveCompletion
        
        describe("receiveCompletion")
        {
            itBehavesLike(CombineEventType_Behaviour.self)
            {
                .init(event: .receiveCompletion(.failure(DummyError("aaa"))),
                      specificType_matching: .receiveCompletionSpecific(.failure(DummyError("aaa"))),
                      specificType_other: .receiveCompletionSpecific(.failure(DummyError("aaa"))),
                      specificType_notMatching: .receiveCompletionSpecific(.failure(DummyError("bbb"))),
                      unspecificType: .receiveCompletionUnspecific,
                      unspecificType_other: .receiveCompletionUnspecific,
                      testType_matching: .receiveCompletionTestError { ($0 as? DummyError)?.message == "aaa" },
                      testType_notMatching: .receiveCompletionTestError { ($0 as? DummyError)?.message == "bbb" },
                      strictness: .receiveCompletion,
                      relevantTypes:
                        [
                            a_receiveCompletionSpecific,
                            a_receiveCompletionUnSpecific,
                            a_receiveCompletionTest
                        ]
                )
            }
            
            describe("test")
            {
                describe("finished")
                {
                    context("finished")
                    {
                        it("matched")
                        {
                            expect
                            {
                                CombineExpectationType.receiveCompletionSpecific(.finished)
                                    .test(with: CombineEventType.receiveCompletion(.finished))
                            }
                            .to(equal(.matched))
                        }
                    }
                    
                    context("failure")
                    {
                        it("notMatched")
                        {
                            expect
                            {
                                CombineExpectationType.receiveCompletionSpecific(.finished)
                                    .test(with: CombineEventType.receiveCompletion(.failure(DummyError("aaa"))))
                            }
                            .to(equal(.mismatched))
                        }
                    }
                }
                
                describe("failure")
                {
                    context("same error type")
                    {
                        it("matched")
                        {
                            expect
                            {
                                CombineExpectationType.receiveCompletionSpecific(.failure(DummyError("aaa")))
                                    .test(with: CombineEventType.receiveCompletion(.failure(DummyError("aaa"))))
                            }
                            .to(equal(.matched))
                        }
                    }
                    
                    context("different error type")
                    {
                        it("notMatched")
                        {
                            expect
                            {
                                CombineExpectationType.receiveCompletionSpecific(.failure(DummyError("aaa")))
                                    .test(with: CombineEventType.receiveCompletion(.failure(DummyError2("aaa"))))
                            }
                            .to(equal(.mismatched))
                        }
                    }
                }
            }
        }
        
        
        // MARK: requestDemand
        
        describe("requestDemand")
        {
            itBehavesLike(CombineEventType_Behaviour.self)
            {
                .init(event: .requestDemand(.max(1)),
                      specificType_matching: .requestDemandSpecific(.max(1)),
                      specificType_other: .requestDemandSpecific(.max(1)),
                      specificType_notMatching: .requestDemandSpecific(.max(2)),
                      unspecificType: .requestDemandUnspecific,
                      unspecificType_other: .requestDemandUnspecific,
                      testType_matching: nil,
                      testType_notMatching: nil,
                      strictness: .requestDemand,
                      relevantTypes:
                        [
                            a_requestDemandSpecific,
                            a_requestDemandUnspecific
                        ])
            }
        }


        // MARK: requestSyncDemand
        
        describe("requestSyncDemand")
        {
            itBehavesLike(CombineEventType_Behaviour.self)
            {
                .init(event: .requestSyncDemand(.max(1)),
                      specificType_matching: .requestSyncDemandSpecific(.max(1)),
                      specificType_other: .requestSyncDemandSpecific(.max(1)),
                      specificType_notMatching: .requestSyncDemandSpecific(.max(2)),
                      unspecificType: .requestSyncDemandUnspecific,
                      unspecificType_other: .requestSyncDemandUnspecific,
                      testType_matching: nil,
                      testType_notMatching: nil,
                      strictness: .requestSyncDemand,
                      relevantTypes:
                        [
                            a_requestSyncDemandSpecific,
                            a_requestSyncDemandUnspecific
                        ])
            }
        }
        
        
        // MARK: cancel
        
        describe("cancel")
        {
            itBehavesLike(CombineEventType_Behaviour.self)
            {
                .init(event: .cancel,
                      specificType_matching: .cancel,
                      specificType_other: .cancel,
                      specificType_notMatching: nil,
                      unspecificType: nil,
                      unspecificType_other: nil,
                      testType_matching: nil,
                      testType_notMatching: nil,
                      strictness: .cancel,
                      relevantTypes:
                        [
                            a_cancel
                        ])
            }
        }
    }
}



// MARK: - CombineEventType Behaviour

fileprivate
class CombineEventType_Behaviour: Behavior<CombineEventType_Context>
{
    static
    override
    var name: String
    {
        "behaviour"
    }
    
    
    static
    override
    func spec(_ aContext: @escaping () -> CombineEventType_Context)
    {
        let c = aContext()
        
        describe("isAffectedByStrictness")
        {
            context("affectingStrictness")
            {
                it("true")
                {
                    expect(c.event.isAffectedBy(c.strictness_affecting)).to(beTrue())
                }
            }
            
            context("notAffectingStrictness")
            {
                it("false")
                {
                    expect(c.event.isAffectedBy(c.strictness_notAffecting)).to(beFalse())
                }
            }
        }
        
        describe("test related")
        {
            let setups: [(String, CombineExpectationType?, CombineTypeTestResult)] =
            [
                ("specific_matching", c.specificType_matching, .matched),
                ("specific_notMatching", c.specificType_notMatching, .mismatched),
                ("unspecific", c.unspecificType, .matched),
                ("test_matching", c.testType_matching, .matched),
                ("test_not_matching", c.testType_notMatching, .mismatched)
            ]
            
            for setup in setups
            {
                let (name, type, result) = setup
                
                guard let type
                else
                {
                    continue
                }
                
                context(name)
                {
                    it(String(describing: result))
                    {
                        expect(type.test(with: c.event)).to(equal(result))
                    }
                }
            }
        }
        
        describe("test unrelated")
        {
            it("all notEvaluated")
            {
                let unrelatedTypes = c.unrelatedTypes
                
                for buildUnrelatedType in unrelatedTypes
                {
                    let unrelatedType = buildUnrelatedType.build()
                    
                    expect
                    {
                        unrelatedType.test(with: c.event)
                    }
                    .to(equal(.incompatibleTypes))
                }
            }
        }
        
        describe("equals")
        {
            describe("specific")
            {
                context("and matching specific")
                {
                    it("true")
                    {
                        expect
                        {
                            equateCombineExpectationTypes(c.specificType_matching, c.specificType_other)
                        }
                        .to(beTrue())
                    }
                }

                if let specificType_notMatching = c.specificType_notMatching
                {
                    context("and not matching specific")
                    {
                        it("false")
                        {
                            expect
                            {
                                equateCombineExpectationTypes(specificType_notMatching, c.specificType_other)
                            }
                            .to(beFalse())
                        }
                    }
                }
            }
        }
    }
}



// MARK: CombineEventType Context

fileprivate
struct CombineEventType_Context
{
    let event: CombineEventType

    let specificType_matching: CombineExpectationType

    let specificType_other: CombineExpectationType

    let specificType_notMatching: CombineExpectationType?

    let unspecificType: CombineExpectationType?
    
    let unspecificType_other: CombineExpectationType?
    
    let testType_matching: CombineExpectationType?

    let testType_notMatching: CombineExpectationType?

    let strictness_affecting: EventTypeOptions
    
    let relevantTypes: [TypeBuilder]
    
    
    var strictness_notAffecting: EventTypeOptions
    {
        .all.subtracting(self.strictness_affecting)
    }
    
    var unrelatedTypes: [TypeBuilder]
    {
        allCombineEventTypes
            .filter
            {
                type in
                
                !(self.relevantTypes.contains { $0 === type })
            }
    }
    
    
    internal
    init
    (
        event: CombineEventType,
        specificType_matching: CombineExpectationType,
        specificType_other: CombineExpectationType,
        specificType_notMatching: CombineExpectationType?,
        unspecificType: CombineExpectationType?,
        unspecificType_other: CombineExpectationType?,
        testType_matching: CombineExpectationType?,
        testType_notMatching: CombineExpectationType?,
        strictness: EventTypeOptions,
        relevantTypes: [TypeBuilder]
    )
    {
        self.event = event
        self.specificType_matching = specificType_matching
        self.specificType_other = specificType_other
        self.specificType_notMatching = specificType_notMatching
        self.unspecificType = unspecificType
        self.unspecificType_other = unspecificType_other
        self.testType_matching = testType_matching
        self.testType_notMatching = testType_notMatching
        self.strictness_affecting = strictness
        self.relevantTypes = relevantTypes
    }
}



// MARK: - Utility

fileprivate
class TypeBuilder: CustomStringConvertible
{
    let build: () -> CombineExpectationType
    
    
    init(build: @escaping () -> CombineExpectationType)
    {
        self.build = build
    }

    
    var description: String
    {
        build().description
    }
}

fileprivate let a_receiveSubscriberSpecific: TypeBuilder = .init { .receiveSubscriberSpecific("aaa") }
fileprivate let a_receiveSubscriberUnspecific: TypeBuilder = .init { .receiveSubscriberUnspecific }

fileprivate let a_receiveSubscriptionSpecific: TypeBuilder = .init { .receiveSubscriptionSpecific("aaa") }
fileprivate let a_receiveSubscriptionUnspecific: TypeBuilder = .init { .receiveSubscriptionUnspecific }

fileprivate let a_receiveValueSpecific: TypeBuilder = .init { .receiveValueSpecific(1) }
fileprivate let a_receiveValueUnSpecific: TypeBuilder = .init { .receiveValueUnspecific }
fileprivate let a_receiveValueTest: TypeBuilder = .init { .receiveValueTest { $0 as? Int == 1 } }

fileprivate let a_receiveCompletionSpecific: TypeBuilder = .init { .receiveCompletionSpecific(.finished) }
fileprivate let a_receiveCompletionUnSpecific: TypeBuilder = .init { .receiveCompletionUnspecific }
fileprivate let a_receiveCompletionTest: TypeBuilder = .init { .receiveCompletionTestError { ($0 as? DummyError)?.message == "aaa" } }

fileprivate let a_requestDemandSpecific: TypeBuilder = .init { .requestDemandSpecific(.unlimited) }
fileprivate let a_requestDemandUnspecific: TypeBuilder = .init { .requestDemandUnspecific }

fileprivate let a_requestSyncDemandSpecific: TypeBuilder = .init { .requestSyncDemandSpecific(.unlimited) }
fileprivate let a_requestSyncDemandUnspecific: TypeBuilder = .init { .requestSyncDemandUnspecific }

fileprivate let a_cancel: TypeBuilder = .init { .cancel }

fileprivate
var allCombineEventTypes: [TypeBuilder] =
    [
        a_receiveSubscriberSpecific,
        a_receiveSubscriberUnspecific,
        
        a_receiveSubscriptionSpecific,
        a_receiveSubscriptionUnspecific,
        
        a_receiveValueSpecific,
        a_receiveValueUnSpecific,
        a_receiveValueTest,
        
        a_receiveCompletionSpecific,
        a_receiveCompletionUnSpecific,
        a_receiveCompletionTest,
        
        a_requestDemandSpecific,
        a_requestDemandUnspecific,

        a_requestSyncDemandSpecific,
        a_requestSyncDemandUnspecific,
        
        a_cancel
    ]
