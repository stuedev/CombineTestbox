//
//  GroupExpectation_Tests.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//


import Foundation
import CombineTestbox
import Combine
import XCTest
import GeneratedTestCase


class GroupExpectation_Tests: FeatureTestCase
{
    override
    static
    func setUp()
    {
        Testbox.config.debug.state = false
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
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)
                            }
                        },
                    expectationsInverse:
                        {
                            group
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
                        },
                    expectations:
                        {
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)     !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            group
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
                            /*
                             event for value (1) is ignored.
                             expectation for value (1) is not fulfilled
                             */
                            
                            group
                            {
                                "sub" > receiveValue(2)
                                "sub" > receiveValue(1)     !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            group
                            {
                                "sub" > receiveValue(2)
                                "sub" > receiveValue(1)
                            }
                        }
                )
            }
        }
        
        
        // MARK: - NESTED GROUPS
        
        category("nested groups")
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
                        group
                        {
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)
                            }
                        }
                    },
                expectationsInverse:
                    {
                        group
                        {
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)
                            }
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
                    },
                expectations:
                    {
                        group
                        {
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)     !! unfulfilled
                            }
                        }
                    },
                expectationsInverse:
                    {
                        group
                        {
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)
                            }
                        }
                    }
            )
        }
        
        
        // MARK: - WITH FOREACH
        
        category("with forEach")
        {
            
            // MARK: all matching
            
            test(
                "with forEach",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                        subject.send(2)
                    },
                expectations:
                    {
                        group
                        {
                            forEach([1,2])
                            {
                                "sub" > receiveValue($0)
                            }
                        }
                    },
                expectationsInverse:
                    {
                        group
                        {
                            forEach([1,2])
                            {
                                "sub" > receiveValue($0)
                            }
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
                    },
                expectations:
                    {
                        group
                        {
                            forEach([1,2])
                            {
                                "sub" > receiveValue($0)    !! unfulfilled ~~ /2
                            }
                        }
                    },
                expectationsInverse:
                    {
                        group
                        {
                            forEach([1,2])
                            {
                                "sub" > receiveValue($0)
                            }
                        }
                    }
            )
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
                        group
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)
                            }
                        }
                    },
                expectationsInverse:
                    {
                        group
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)
                            }
                        }
                        !! fulfilledInverse
                    }
            )

            
            // MARK: missing
            
            test(
                "missing",
                setup:
                    {
                        testbox, subject, sub in
                        
                        // subject.send(1)  // missing
                    },
                expectations:
                    {
                        group
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)     !! unfulfilled
                            }
                        }
                    },
                expectationsInverse:
                    {
                        group
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)
                            }
                        }
                    }
            )
        }
        
        
        // MARK: - INSIDE STRICT
        
        category("inside strict")
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
                        strict(.receiveValue)
                        {
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)
                            }
                        }
                    },
                expectationsInverse:
                    {
                        strict(.receiveValue)
                        {
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)
                            }
                        }
                        !! fulfilledInverse
                    }
            )

            
            // MARK: one mismatching
            
            test(
                "one mismatching",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                        subject.send(3)     // mismatching
                    },
                expectations:
                    {
                        strict(.receiveValue)
                        {
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)     !! mismatching .. "sub" > receiveValue(3)
                            }
                        }
                    },
                expectationsInverse:
                    {
                        strict(.receiveValue)
                        {
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)     !! mismatching .. "sub" > receiveValue(3)
                            }
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
                        subject.send(2)
                        subject.send(3)     // unexpected
                    },
                expectations:
                    {
                        strict(.receiveValue)
                        {
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)
                            }
                        }
                        !! unexpected .. "sub" > receiveValue(3)
                    },
                expectationsInverse:
                    {
                        strict(.receiveValue)
                        {
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)
                            }
                        }
                        !! unexpected .. "sub" > receiveValue(3)
                    }
            )

            
            // MARK: missing
            
            test(
                "missing",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                    },
                expectations:
                    {
                        strict(.receiveValue)
                        {
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)     !! unfulfilled
                            }
                        }
                    },
                expectationsInverse:
                    {
                        strict(.receiveValue)
                        {
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)
                            }
                        }
                    }
            )
        }
    }
}
