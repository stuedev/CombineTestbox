//
//  StrictExpectation_Tests.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation
import CombineTestbox
import Combine
import XCTest
import GeneratedTestCase


class StrictExpectation_Tests: FeatureTestCase
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
            
            // MARK: relevant strictness
            
            category("relevant strictness")
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
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)
                            }
                            !! fulfilledInverse
                        }
                )

                
                // MARK: mismatching
                
                test(
                    "mismatching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(2)
                        },
                    expectations:
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)     !! mismatching .. "sub" > receiveValue(2)
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)     !! mismatching .. "sub" > receiveValue(2)
                            }
                        }
                )

                
                // MARK: unexpected

                test(
                    "unexpected",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                            subject.send(2)     // unexpected
                        },
                    expectations:
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)
                            }
                            !! unexpected .. "sub" > receiveValue(2)
                        },
                    expectationsInverse:
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)
                            }
                            !! unexpected .. "sub" > receiveValue(2)
                        }
                )
            }
            
            
            // MARK: irrelevant strictness
            
            category("irrelevant strictness")
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
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveValue(1)
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveValue(1)
                            }
                            !! fulfilledInverse
                        }
                )

                
                // MARK: mismatching

                test(
                    "mismatching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(2)
                        },
                    expectations:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveValue(1)     !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveValue(1)
                            }
                        }
                )


                // MARK: unexpected

                test(
                    "unexpected",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                            subject.send(2)     // unexpected
                        },
                    expectations:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveValue(1)
                            }
                        },
                    expectationsInverse:
                        {
                            /*
                             first value matches and fulfills strict
                             second value doesnt matter
                             */
                            
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveValue(1)
                            }
                            !! fulfilledInverse
                        }
                )
            }
            
            
            // MARK: multiple strictnesses
            
            category("multiple strictnesses")
            {
                
                // MARK: matching
                
                test(
                    "matching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                            subject.send(completion: .finished)
                        },
                    expectations:
                        {
                            strict([.receiveValue, .receiveCompletion])
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveCompletion(.finished)
                            }
                        },
                    expectationsInverse:
                        {
                            strict([.receiveValue, .receiveCompletion])
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveCompletion(.finished)
                            }
                            !! fulfilledInverse
                        },
                    reportedEvents: [.receiveValue, .receiveCompletion]
                )

                
                // MARK: mismatching
                
                test(
                    "mismatching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(2)     // mismatching
                            subject.send(completion: .finished)
                        },
                    expectations:
                        {
                            strict([.receiveValue, .receiveCompletion])
                            {
                                "sub" > receiveValue(1)     !! mismatching .. "sub" > receiveValue(2)
                                "sub" > receiveCompletion(.finished)
                            }
                        },
                    expectationsInverse:
                        {
                            strict([.receiveValue, .receiveCompletion])
                            {
                                "sub" > receiveValue(1)     !! mismatching .. "sub" > receiveValue(2)
                                "sub" > receiveCompletion(.finished)
                            }
                        },
                    reportedEvents: [.receiveValue, .receiveCompletion]
                )

                
                // MARK: unexpected

                test(
                    "unexpected",
                    setup:
                        {
                            testbox, subject, sub in

                            subject.send(1)
                            subject.send(2)     // unexpected
                            subject.send(completion: .finished)
                        },
                    expectations:
                        {
                            /*
                             failure is applied to the current expectation inside strict
                             */
                            
                            strict([.receiveValue, .receiveCompletion])
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveCompletion(.finished)    !! unexpected .. "sub" > receiveValue(2)
                            }
                        },
                    expectationsInverse:
                        {
                            strict([.receiveValue, .receiveCompletion])
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveCompletion(.finished)    !! unexpected .. "sub" > receiveValue(2)
                            }
                        },
                    reportedEvents: [.receiveValue, .receiveCompletion]
                )
            }

        }
        
        
        // MARK: - NESTED STRICTNESS
        
        category("nested strictness")
        {
            
            // MARK: relevant strictnesses
            
            category("relevant strictnesses")
            {
                
                // MARK: both matching
                
                test(
                    "both matching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                            subject.send(completion: .finished)
                        },
                    expectations:
                        {
                            strict(.receiveValue)
                            {
                                strict(.receiveCompletion)
                                {
                                    "sub" > receiveValue(1)
                                    "sub" > receiveCompletion(.finished)
                                }
                            }
                        },
                    expectationsInverse:
                        {
                            /*
                             outer strict can fulfill, but is inverse, so it fails
                             */
                            
                            strict(.receiveValue)
                            {
                                strict(.receiveCompletion)
                                {
                                    "sub" > receiveValue(1)
                                    "sub" > receiveCompletion(.finished)
                                }
                            }
                            !! fulfilledInverse
                        },
                    reportedEvents: [.receiveValue, .receiveCompletion]
                )

                
                // MARK: outer mismatching
                
                test(
                    "outer mismatching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(2)
                            subject.send(completion: .finished)
                        },
                    expectations:
                        {
                            strict(.receiveValue)
                            {
                                strict(.receiveCompletion)
                                {
                                    "sub" > receiveValue(1)     !! mismatching .. "sub" > receiveValue(2)
                                    "sub" > receiveCompletion(.finished)
                                }
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveValue)
                            {
                                strict(.receiveCompletion)
                                {
                                    "sub" > receiveValue(1)     !! mismatching .. "sub" > receiveValue(2)
                                    "sub" > receiveCompletion(.finished)
                                }
                            }
                        },
                    reportedEvents: [.receiveValue, .receiveCompletion]
                )

                
                // MARK: inner mismatching
                
                test(
                    "inner mismatching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                            subject.send(completion: .failure(DummyError()))
                        },
                    expectations:
                        {
                            strict(.receiveValue)
                            {
                                strict(.receiveCompletion)
                                {
                                    "sub" > receiveValue(1)
                                    "sub" > receiveCompletion(.finished)    !! mismatching .. "sub" > receiveCompletion(.failure(DummyError()))
                                }
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveValue)
                            {
                                strict(.receiveCompletion)
                                {
                                    "sub" > receiveValue(1)
                                    "sub" > receiveCompletion(.finished)    !! mismatching .. "sub" > receiveCompletion(.failure(DummyError()))
                                }
                            }
                        },
                    reportedEvents: [.receiveValue, .receiveCompletion]
                )

                
                // MARK: unexpected
                
                test(
                    "unexpected",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                            subject.send(2)
                            subject.send(completion: .finished)
                        },
                    expectations:
                        {
                            strict(.receiveValue)
                            {
                                strict(.receiveCompletion)
                                {
                                    "sub" > receiveValue(1)
                                    "sub" > receiveCompletion(.finished)    !! unexpected .. "sub" > receiveValue(2)
                                }
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveValue)
                            {
                                strict(.receiveCompletion)
                                {
                                    "sub" > receiveValue(1)
                                    "sub" > receiveCompletion(.finished)    !! unexpected .. "sub" > receiveValue(2)
                                }
                            }
                        },
                    reportedEvents: [.receiveValue, .receiveCompletion]
                )
            }

            
            // MARK: irrelevant strictnesses
            
            category("irrelevant strictnesses")
            {
                
                // MARK: both matching
                
                test(
                    "both matching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                            subject.send(completion: .finished)
                        },
                    expectations:
                        {
                            strict(.receiveSubscriber)
                            {
                                strict(.receiveSubscription)
                                {
                                    "sub" > receiveValue(1)
                                    "sub" > receiveCompletion(.finished)
                                }
                            }
                        },
                    expectationsInverse:
                        {
                            /*
                             outer strict can fulfill, but is inverse, so it fails
                             */
                            
                            strict(.receiveSubscriber)
                            {
                                strict(.receiveSubscription)
                                {
                                    "sub" > receiveValue(1)
                                    "sub" > receiveCompletion(.finished)
                                }
                            }
                            !! fulfilledInverse
                        },
                    reportedEvents: [.receiveValue, .receiveCompletion]
                )

                
                // MARK: outer mismatching
                
                test(
                    "outer mismatching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(2)
                            subject.send(completion: .finished)
                        },
                    expectations:
                        {
                            strict(.receiveSubscriber)
                            {
                                strict(.receiveSubscription)
                                {
                                    "sub" > receiveValue(1)     !! unfulfilled
                                    "sub" > receiveCompletion(.finished)
                                }
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveSubscriber)
                            {
                                strict(.receiveSubscription)
                                {
                                    "sub" > receiveValue(1)
                                    "sub" > receiveCompletion(.finished)
                                }
                            }
                        },
                    reportedEvents: [.receiveValue, .receiveCompletion]
                )

                
                // MARK: inner mismatching
                
                test(
                    "inner mismatching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                            subject.send(completion: .failure(DummyError()))
                        },
                    expectations:
                        {
                            strict(.receiveSubscriber)
                            {
                                strict(.receiveSubscription)
                                {
                                    "sub" > receiveValue(1)
                                    "sub" > receiveCompletion(.finished)    !! unfulfilled
                                }
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveSubscriber)
                            {
                                strict(.receiveSubscription)
                                {
                                    "sub" > receiveValue(1)
                                    "sub" > receiveCompletion(.finished)
                                }
                            }
                        },
                    reportedEvents: [.receiveValue, .receiveCompletion]
                )

                
                // MARK: unexpected
                
                test(
                    "unexpected",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                            subject.send(2)
                            subject.send(completion: .finished)
                        },
                    expectations:
                        {
                            strict(.receiveSubscriber)
                            {
                                strict(.receiveSubscription)
                                {
                                    "sub" > receiveValue(1)
                                    "sub" > receiveCompletion(.finished)
                                }
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveSubscriber)
                            {
                                strict(.receiveSubscription)
                                {
                                    "sub" > receiveValue(1)
                                    "sub" > receiveCompletion(.finished)
                                }
                            }
                            !! fulfilledInverse
                        },
                    reportedEvents: [.receiveValue, .receiveCompletion]
                )
            }
        }


        // MARK: - WITH SUCCESSOR
        
        category("with successor")
        {
            
            // MARK: matching
            
            test(
                "matching",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                        subject.send(2)
                        subject.send(3)
                    },
                expectations:
                    {
                        strict(.receiveValue)
                        {
                            "sub" > receiveValue(1)
                            "sub" > receiveValue(2)
                        }

                        "sub" > receiveValue(3)
                    },
                expectationsInverse:
                    {
                        /*
                         failure happens on successor, because it is checked before strict (which also can fulfill)
                         */
                        
                        strict(.receiveValue)
                        {
                            "sub" > receiveValue(1)
                            "sub" > receiveValue(2)
                        }

                        "sub" > receiveValue(3)     !! fulfilledInverse
                    }
            )


            // MARK: unexpected
            
            test(
                "unexpected",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                        subject.send(2)
                        subject.send(3)     // unexpected
                        subject.send(4)
                    },
                expectations:
                    {
                        /*
                         unexpected event is handled in strict (by design)
                         */
                        
                        strict(.receiveValue)
                        {
                            "sub" > receiveValue(1)
                            "sub" > receiveValue(2)
                        }
                        !! unexpected .. "sub" > receiveValue(3)

                        "sub" > receiveValue(4)
                    },
                expectationsInverse:
                    {
                        strict(.receiveValue)
                        {
                            "sub" > receiveValue(1)
                            "sub" > receiveValue(2)
                        }
                        !! unexpected .. "sub" > receiveValue(3)

                        "sub" > receiveValue(4)
                    }
            )
        }
        
        
        // MARK: - AS SUCCESSOR
        
        test(
            "as successor",
            setup:
                {
                    testbox, subject, sub in
                    
                    subject.send(1)
                    subject.send(2)
                    subject.send(3)
                },
            expectations:
                {
                    "sub" > receiveValue(1)
                    
                    strict(.receiveValue)
                    {
                        "sub" > receiveValue(2)
                        "sub" > receiveValue(3)
                    }
                },
            expectationsInverse:
                {
                    "sub" > receiveValue(1)     !! fulfilledInverse
                    
                    strict(.receiveValue)
                    {
                        "sub" > receiveValue(2)
                        "sub" > receiveValue(3)
                    }
                }
        )

        
        // MARK: - CHAINED STRICTS
        
        category("chained stricts")
        {
            
            // MARK: matching
            
            test(
                "matching",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                        subject.send(2)
                    },
                expectations:
                    {
                        strict(.receiveValue)
                        {
                            "sub" > receiveValue(1)
                        }
                        
                        strict(.receiveValue)
                        {
                            "sub" > receiveValue(2)
                        }
                    },
                expectationsInverse:
                    {
                        strict(.receiveValue)
                        {
                            "sub" > receiveValue(1)
                        }
                        !! fulfilledInverse
                        
                        strict(.receiveValue)
                        {
                            "sub" > receiveValue(2)
                        }
                    }
            )
            
            
            // MARK: unexpected
            
            test(
                "unexpected",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                        subject.send(3)     // unexpected
                    },
                expectations:
                    {
                        /*
                         value (3) is forwarded to successor (second string), where it isnt matched and fails due to strictness.
                         */
                        
                        strict(.receiveValue)
                        {
                            "sub" > receiveValue(1)
                        }
                        
                        strict(.receiveValue)
                        {
                            "sub" > receiveValue(2)     !! mismatching .. "sub" > receiveValue(3)
                        }
                    },
                expectationsInverse:
                    {
                        strict(.receiveValue)
                        {
                            "sub" > receiveValue(1)
                        }
                        
                        strict(.receiveValue)
                        {
                            "sub" > receiveValue(2)     !! mismatching .. "sub" > receiveValue(3)
                        }
                    }
            )
        }
            
        
        // MARK: - WITH SURROUNDS
        
        test(
            "with surrounds",
            setup:
                {
                    testbox, subject, sub in
                    
                    subject.send(1)
                    subject.send(2)
                    subject.send(3)
                    subject.send(4)
                    subject.send(5)
                },
            expectations:
                {
                    "sub" > receiveValue(1)
                    
                    strict(.receiveValue)
                    {
                        "sub" > receiveValue(2)
                    }
                    
                    "sub" > receiveValue(3)
                    
                    strict(.receiveValue)
                    {
                        "sub" > receiveValue(4)
                    }
                    
                    "sub" > receiveValue(5)
                },
            expectationsInverse:
                {
                    "sub" > receiveValue(1)     !! fulfilledInverse
                    
                    strict(.receiveValue)
                    {
                        "sub" > receiveValue(2)
                    }
                    
                    "sub" > receiveValue(3)
                    
                    strict(.receiveValue)
                    {
                        "sub" > receiveValue(4)
                    }
                    
                    "sub" > receiveValue(5)
                }
        )
    }
}
