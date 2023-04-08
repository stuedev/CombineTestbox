//
//  IgnoreExpectation_Tests.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation
import CombineTestbox
import Combine
import XCTest
import GeneratedTestCase


class IgnoreExpectation_Tests: FeatureTestCase
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
            // MARK: alone
            
            category("alone")
            {
                
                // MARK: with ignored event
                
                test(
                    "with ignored event",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(99)
                        },
                    expectations:
                        {
                            ignore()
                        },
                    expectationsInverse:
                        {
                            /*
                             inverse ignore doesnt fulfill
                             */
                            
                            ignore()
                        }
                )
                
                
                // MARK: without ignored event
                
                test(
                    "without ignored event",
                    setup:
                        {
                            testbox, subject, sub in
                        },
                    expectations:
                        {
                            ignore()
                        },
                    expectationsInverse:
                        {
                            /*
                             inverse ignore doesnt fulfill
                             */
                            
                            ignore()
                        }
                )
            }
            
            
            // MARK: ignore top
            
            category("ignore top")
            {
                
                // MARK: with ignored event
                
                category("with ignored event")
                {
                    
                    // MARK: successor matching
                    
                    test(
                        "successor matching",
                        setup:
                            {
                                testbox, subject, sub in
                                
                                subject.send(99)    // ignored
                                subject.send(1)
                            },
                        expectations:
                            {
                                ignore()
                                
                                "sub" > receiveValue(1)
                            },
                        expectationsInverse:
                            {
                                ignore()
                                
                                "sub" > receiveValue(1)     !! fulfilledInverse
                            }
                    )
                    
                    
                    // MARK: successor mismatching
                    
                    test(
                        "successor mismatching",
                        setup:
                            {
                                testbox, subject, sub in
                                
                                subject.send(99)    // ignored
                                subject.send(2)
                            },
                        expectations:
                            {
                                ignore()
                                
                                "sub" > receiveValue(1)     !! unfulfilled
                            },
                        expectationsInverse:
                            {
                                ignore()
                                
                                "sub" > receiveValue(1)
                            }
                    )
                }
                
                
                // MARK: without ignored event
                
                category("without ignored event")
                {
                    
                    // MARK: successor matching
                    
                    test(
                        "successor matching",
                        setup:
                            {
                                testbox, subject, sub in
                                
                                subject.send(1)
                            },
                        expectations:
                            {
                                ignore()
                                
                                "sub" > receiveValue(1)
                            },
                        expectationsInverse:
                            {
                                ignore()
                                
                                "sub" > receiveValue(1)     !! fulfilledInverse
                            }
                    )
                    
                    
                    // MARK: successor mismatching
                    
                    test(
                        "successor mismatching",
                        setup:
                            {
                                testbox, subject, sub in
                                
                                subject.send(2)
                            },
                        expectations:
                            {
                                ignore()
                                
                                "sub" > receiveValue(1)     !! unfulfilled
                            },
                        expectationsInverse:
                            {
                                ignore()
                                
                                "sub" > receiveValue(1)
                            }
                    )
                }
            }
            
            
            // MARK: ignore bottom
            
            category("ignore bottom")
            {
                
                // MARK: with ignored event
                
                category("with ignored event")
                {
                    
                    // MARK: predecessor matching
                    
                    test(
                        "predecessor matching",
                        setup:
                            {
                                testbox, subject, sub in
                                
                                subject.send(1)
                                subject.send(99)    // ignored
                            },
                        expectations:
                            {
                                "sub" > receiveValue(1)
                                
                                ignore()
                            },
                        expectationsInverse:
                            {
                                "sub" > receiveValue(1)     !! fulfilledInverse
                                
                                ignore()
                            }
                    )
                    
                    
                    // MARK: predecessor mismatching
                    
                    test(
                        "predecessor mismatching",
                        setup:
                            {
                                testbox, subject, sub in
                                
                                subject.send(2)
                                subject.send(99)    // ignored
                            },
                        expectations:
                            {
                                "sub" > receiveValue(1)     !! unfulfilled
                                
                                ignore()
                            },
                        expectationsInverse:
                            {
                                "sub" > receiveValue(1)
                                
                                ignore()
                            }
                    )
                }
                
                
                // MARK: without ignored event
                
                category("without ignored event")
                {
                    
                    // MARK: predecessor matching
                    
                    test(
                        "predecessor matching",
                        setup:
                            {
                                testbox, subject, sub in
                                
                                subject.send(1)
                            },
                        expectations:
                            {
                                "sub" > receiveValue(1)
                                
                                ignore()
                            },
                        expectationsInverse:
                            {
                                "sub" > receiveValue(1)     !! fulfilledInverse
                                
                                ignore()
                            }
                    )
                    
                    
                    // MARK: predecessor mismatching
                    
                    test(
                        "predecessor mismatching",
                        setup:
                            {
                                testbox, subject, sub in
                                
                                subject.send(2)
                            },
                        expectations:
                            {
                                "sub" > receiveValue(1)     !! unfulfilled
                                
                                ignore()
                            },
                        expectationsInverse:
                            {
                                "sub" > receiveValue(1)
                                
                                ignore()
                            }
                    )
                }
            }
        }
            
        
        // MARK: - CHAINED IGNORE
        
        category("chained ignore")
        {
            // MARK: alone
            
            category("alone")
            {
                
                // MARK: with ignored event
                
                test(
                    "with ignored event",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(99)
                        },
                    expectations:
                        {
                            ignore()
                            
                            ignore()
                        },
                    expectationsInverse:
                        {
                            ignore()

                            ignore()
                        }
                )

                
                // MARK: without ignored event
                
                test(
                    "without ignored event",
                    setup:
                        {
                            testbox, subject, sub in
                        },
                    expectations:
                        {
                            ignore()
                            
                            ignore()
                        },
                    expectationsInverse:
                        {
                            ignore()
                            
                            ignore()
                        }
                )
            }

            
            // MARK: ignore top
            
            category("ignore top")
            {
                
                // MARK: with ignored event
                
                category("with ignored event")
                {
                    
                    // MARK: successor matching
                    
                    test(
                        "successor matching",
                        setup:
                            {
                                testbox, subject, sub in
                                
                                subject.send(99)    // ignored
                                subject.send(1)
                            },
                        expectations:
                            {
                                ignore()
                                
                                ignore()
                                
                                "sub" > receiveValue(1)
                            },
                        expectationsInverse:
                            {
                                ignore()
                                
                                ignore()
                                
                                "sub" > receiveValue(1)     !! fulfilledInverse
                            }
                    )
                }
                
                
                // MARK: without ignored event
                
                category("without ignored event")
                {
                    
                    // MARK: successor matching
                    
                    test(
                        "successor matching",
                        setup:
                            {
                                testbox, subject, sub in
                                
                                subject.send(1)
                            },
                        expectations:
                            {
                                ignore()
                                
                                ignore()
                                
                                "sub" > receiveValue(1)
                            },
                        expectationsInverse:
                            {
                                ignore()
                                
                                ignore()
                                
                                "sub" > receiveValue(1)     !! fulfilledInverse
                            }
                    )
                }
            }
            
            
            // MARK: ignore bottom
            
            category("ignore bottom")
            {
                
                // MARK: with ignored event
                
                category("with ignored event")
                {
                    
                    // MARK: successor matching
                    
                    test(
                        "successor matching",
                        setup:
                            {
                                testbox, subject, sub in
                                
                                subject.send(1)
                                subject.send(99)    // ignored
                            },
                        expectations:
                            {
                                "sub" > receiveValue(1)

                                ignore()
                                
                                ignore()
                            },
                        expectationsInverse:
                            {
                                "sub" > receiveValue(1)     !! fulfilledInverse

                                ignore()
                                
                                ignore()
                            }
                    )
                }
                
                
                // MARK: without ignored event
                
                category("without ignored event")
                {
                    
                    // MARK: successor matching
                    
                    test(
                        "successor matching",
                        setup:
                            {
                                testbox, subject, sub in
                                
                                subject.send(1)
                            },
                        expectations:
                            {
                                "sub" > receiveValue(1)

                                ignore()
                                
                                ignore()
                            },
                        expectationsInverse:
                            {
                                "sub" > receiveValue(1)     !! fulfilledInverse

                                ignore()
                                
                                ignore()
                            }
                    )
                }
            }
        }
        
        
        // MARK: - INSIDE STRICT
        
        category("inside strict")
        {
            // MARK: ignore top
            
            category("ignore top")
            {
                
                // MARK: with ignored event
                
                test(
                    "with ignored event",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(99)    // ignored
                            subject.send(1)
                        },
                    expectations:
                        {
                            strict(.receiveValue)
                            {
                                ignore()
                                
                                "sub" > receiveValue(1)
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveValue)
                            {
                                ignore()
                                
                                "sub" > receiveValue(1)
                            }
                            !! fulfilledInverse
                        }
                )


                // MARK: without ignored event
                
                test(
                    "without ignored event",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                        },
                    expectations:
                        {
                            strict(.receiveValue)
                            {
                                ignore()
                                
                                "sub" > receiveValue(1)
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveValue)
                            {
                                ignore()
                                
                                "sub" > receiveValue(1)
                            }
                            !! fulfilledInverse
                        }
                )
            }

            
            // MARK: ignore bottom
            
            category("ignore bottom")
            {
                
                // MARK: with ignored event
                
                test(
                    "with ignored event",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                            subject.send(99)    // ignored
                        },
                    expectations:
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)

                                ignore()
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)

                                ignore()
                            }
                            !! fulfilledInverse
                        }
                )


                // MARK: without ignored event
                
                test(
                    "without ignored event",
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

                                ignore()
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)

                                ignore()
                            }
                            !! fulfilledInverse
                        }
                )
            }
        }
        
        
        // MARK: - INTO STRICT
        
        category("into strict")
        {
            
            // MARK: matching
            
            test(
                "matching",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(99)    // ignored
                        subject.send(1)
                    },
                expectations:
                    {
                        ignore()
                        
                        strict(.receiveValue)
                        {
                            "sub" > receiveValue(1)
                        }
                    },
                expectationsInverse:
                    {
                        ignore()
                        
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
                        
                        subject.send(99)    // ignored
                        subject.send(2)
                    },
                expectations:
                    {
                        /*
                         value (2) isnt matched inside strict, so it is handled in ignore (ignored).
                         the expectation inside strict fails as unfulfilled.
                         
                         rule: successors shouldnt fail
                         */
                        
                        ignore()
                        
                        strict(.receiveValue)
                        {
                            "sub" > receiveValue(1)     !! unfulfilled
                        }
                    },
                expectationsInverse:
                    {
                        ignore()
                        
                        strict(.receiveValue)
                        {
                            "sub" > receiveValue(1)
                        }
                    }
            )
        }
    }
}
