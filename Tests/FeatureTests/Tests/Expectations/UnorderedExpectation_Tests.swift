//
//  UnorderedExpectation_Tests.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation
import CombineTestbox
import Combine
import XCTest
import GeneratedTestCase


class UnorderedExpectation_Tests: FeatureTestCase
{
    override
    static
    func setUp()
    {
        Testbox.config.debug.state = false
        Testbox.config.debug.test = false
        Testbox.config.reportedEvents = .receiveValue
    }
    
    
    @TestBuilder
    override
    static
    func buildTests() -> [Test]
    {
        // MARK: - SIMPLE
        
        category("simple")
        {
            // MARK: described order
            
            category("described order")
            {
                // MARK: all matching
                
                test(
                    "all matching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                            subject.send(2)
                        },
                    expectations:
                        {
                            unordered
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)
                            }
                        },
                    expectationsInverse:
                        {
                            unordered
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)
                            }
                            !! fulfilledInverse
                        }
                )

                
                // MARK: one missing
                
                test(
                    "one missing",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                            // subject.send(2)      // missing
                        },
                    expectations:
                        {
                            unordered
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)     !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            unordered
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)
                            }
                        }
                )

            }

            
            // MARK: different order
            
            category("different order")
            {
                // MARK: all matching
                
                test(
                    "all matching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                            subject.send(2)
                        },
                    expectations:
                        {
                            unordered
                            {
                                "sub" > receiveValue(2)
                                "sub" > receiveValue(1)
                            }
                        },
                    expectationsInverse:
                        {
                            unordered
                            {
                                "sub" > receiveValue(2)
                                "sub" > receiveValue(1)
                            }
                            !! fulfilledInverse
                        }
                )

                
                // MARK: one missing
                
                test(
                    "one missing",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                            // subject.send(2)      // missing
                        },
                    expectations:
                        {
                            unordered
                            {
                                "sub" > receiveValue(2)     !! unfulfilled
                                "sub" > receiveValue(1)
                            }
                        },
                    expectationsInverse:
                        {
                            unordered
                            {
                                "sub" > receiveValue(2)
                                "sub" > receiveValue(1)
                            }
                        }
                )

            }
        }

        
        // MARK: - WITH STRICT
        
        category("with strict")
        {
            // MARK: matching
            
            test(
                "matching",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                    },
                expectations:
                    {
                        unordered
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)
                            }
                        }
                    },
                expectationsInverse:
                    {
                        unordered
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)
                            }
                        }
                        !! fulfilledInverse
                    }
            )

            
            // MARK: mismatching
            
            /*
             Motivation:
             
             Unordered tests events with its nested expectations using a "dry run", meaning that nested expectations will not fail. This is important, because the order of events is not defined.
             
             For example, one event could lead to a failure inside the first expectation, but be matched inside the following expectation. There would be no reason to raise a failure then.
             
             In this example, the expectation inside Strict merely remains unfulfilled.
             */
            
            test(
                "mismatching",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                    },
                expectations:
                    {
                        unordered
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(2)     !! unfulfilled
                            }
                        }
                    },
                expectationsInverse:
                    {
                        unordered
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(2)
                            }
                        }
                    }
            )

            
            // MARK: missing
            
            /*
             motivation:
             
             test if unordered will try to fulfill its children before itself
             */
            
            test(
                "missing",
                setup:
                    {
                        testbox, subject, sub in
                        
                    },
                expectations:
                    {
                        unordered
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)     !! unfulfilled
                            }
                        }
                    },
                expectationsInverse:
                    {
                        unordered
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)
                            }
                        }
                    }
            )

        }
        
        
        // MARK: - EXPECTATIONS WITH SUCCESSORS
        
        category("expectations with successors")
        {
            
            // MARK: strict
            
            test(
                "strict",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                        subject.send(2)
                    },
                expectations:
                    {
                        unordered
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)
                            }
                            
                            "sub" > receiveValue(2)
                        }
                    },
                expectationsInverse:
                    {
                        unordered
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)
                            }
                            
                            "sub" > receiveValue(2)
                        }
                        !! fulfilledInverse
                    }
            )
            
            
            // MARK: ignore
            
            /*
             Motivation:
             
            When Unordered sends an event to test in Ignore, the event will **always** be discarded, because Unordered **deactivates** successor-forwarding on its nested expectations.
             */
            
            test(
                "ignore",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                        subject.send(2)
                    },
                expectations:
                    {
                        unordered
                        {
                            ignore()
                            
                            "sub" > receiveValue(2)     !! unfulfilled
                        }
                    },
                expectationsInverse:
                    {
                        unordered
                        {
                            ignore()

                            "sub" > receiveValue(2)
                        }
                    }
            )
        }
        
        
        // MARK: - WITH SECTION

        test(
            "with section",
            setup:
                {
                    testbox, subject, sub in
                    
                    subject.send(1)
                    
                    testbox.section("section")
                    {
                        subject.send(2)
                    }
                },
            expectations:
                {
                    unordered
                    {
                        section("section")
                        {
                            "sub" > receiveValue(2)
                        }
                        
                        "sub" > receiveValue(1)
                    }
                },
            expectationsInverse:
                {
                    unordered
                    {
                        section("section")
                        {
                            "sub" > receiveValue(2)
                        }
                        
                        "sub" > receiveValue(1)
                    }
                    !! fulfilledInverse
                },
            reportedEvents: [.receiveValue, .section]
        )
    }
}
