//
//  NotExpectation_Tests.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation
import CombineTestbox
import Combine
import XCTest
import GeneratedTestCase


class NotExpectation_Tests: FeatureTestCase
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
        // MARK: multiple
        
        test(
            "multiple",
            setup:
                {
                    testbox, subject, sub in
                    
                    subject.send(1)
                    subject.send(2)
                },
            expectations:
                {
                    not
                    {
                        "sub" > receiveValue(1)     !! fulfilledInverse
                        "sub" > receiveValue(2)
                    }
                },
            expectationsInverse:
                {
                    not
                    {
                        "sub" > receiveValue(1)
                        "sub" > receiveValue(2)
                    }
                }
        )
        
        
        // MARK: - WITH SUCCESSOR
        
        category("with successor")
        {
            
            // MARK: successor matching
            
            category("successor matching")
            {
                
                // MARK: inverse not fulfilled
                
                test(
                    "inverse not fulfilled",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(2)
                        },
                    expectations:
                        {
                            not("sub" > receiveValue(1))
                            
                            "sub" > receiveValue(2)
                        },
                    expectationsInverse:
                        {
                            /*
                             expection inside not is double-inverted, and is not fulfilled here.
                             
                             but the failure on the second expectation is evaluated first.
                             */
                            
                            not("sub" > receiveValue(1))
                            
                            "sub" > receiveValue(2)     !! fulfilledInverse
                        }
                )


                // MARK: inverse fulfilled
                
                test(
                    "inverse fulfilled",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                            subject.send(2)
                        },
                    expectations:
                        {
                            not("sub" > receiveValue(1)    !! fulfilledInverse)
                            
                            "sub" > receiveValue(2)
                        },
                    expectationsInverse:
                        {
                            /*
                             expectation inside not is double-inverted, so it fulfills normally
                             */
                            
                            not("sub" > receiveValue(1))
                            
                            "sub" > receiveValue(2)     !! fulfilledInverse
                        }
                )
            }

            
            // MARK: successor not matching
            
            category("successor not matching")
            {
                
                // MARK: inverse not fulfilled
                
                test(
                    "inverse not fulfilled",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(3)
                        },
                    expectations:
                        {
                            not("sub" > receiveValue(1))
                            
                            "sub" > receiveValue(2)     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            not("sub" > receiveValue(1)    !! unfulfilled)
                            
                            "sub" > receiveValue(2)
                        }
                )


                // MARK: inverse fulfilled
                
                test(
                    "inverse fulfilled",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                            subject.send(3)
                        },
                    expectations:
                        {
                            not("sub" > receiveValue(1)    !! fulfilledInverse)
                            
                            "sub" > receiveValue(2)
                        },
                    expectationsInverse:
                        {
                            not("sub" > receiveValue(1))
                            
                            "sub" > receiveValue(2)
                        }
                )
            }
            

            // MARK: successor outside nested
            
            /*
             test if event is forwarded to successor outside the nested structure
             */
            
            category("successor outside nested")
            {
                // MARK: successor matching
                
                test(
                    "successor matching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(2)
                        },
                    expectations:
                        {
                            /*
                             value (2) event is forwarded to successor outside the group and fulfilled there. not and group fulfill successively.
                             */
                            
                            group
                            {
                                not("sub" > receiveValue(1))
                            }
                            
                            "sub" > receiveValue(2)
                        },
                    expectationsInverse:
                        {
                            group
                            {
                                not("sub" > receiveValue(1))
                            }
                            !! fulfilledInverse
                            
                            "sub" > receiveValue(2)     !! fulfilledInverse
                        }
                )

                
                // MARK: successor not matching
                
                test(
                    "successor not matching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(3)
                        },
                    expectations:
                        {
                            group
                            {
                                not("sub" > receiveValue(1))
                            }
                            
                            "sub" > receiveValue(2)     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            group
                            {
                                not("sub" > receiveValue(1))
                            }
                            !! fulfilledInverse
                            
                            "sub" > receiveValue(2)
                        }
                )
            }
        }
        
        
        // MARK: - CHAINED NOTS
        
        category("chained nots")
        {
            
            // MARK: without successor
            
            category("without successor")
            {
                
                // MARK: not matching
                
                test(
                    "not matching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(3)
                        },
                    expectations:
                        {
                            not("sub" > receiveValue(1))

                            not("sub" > receiveValue(2))
                        },
                    expectationsInverse:
                        {
                            not("sub" > receiveValue(1)    !! unfulfilled)

                            not("sub" > receiveValue(2))
                        }
                )

                
                // MARK: matching first
                
                test(
                    "matching first",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                        },
                    expectations:
                        {
                            not("sub" > receiveValue(1)    !! fulfilledInverse)

                            not("sub" > receiveValue(2))
                        },
                    expectationsInverse:
                        {
                            not("sub" > receiveValue(1))

                            not("sub" > receiveValue(2)     !! unfulfilled)
                        }
                )

                
                // MARK: matching second
                
                test(
                    "matching second",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(2)
                        },
                    expectations:
                        {
                            not("sub" > receiveValue(1))

                            not("sub" > receiveValue(2)    !! fulfilledInverse)
                        },
                    expectationsInverse:
                        {
                            /*
                             value (2) is forwarded to the expectation inside the second not and fulfills there (double-inverted).
                             
                             the expectation inside the first not is double-inverse and unfulfilled.
                             */
                            
                            not("sub" > receiveValue(1)     !! unfulfilled)

                            not("sub" > receiveValue(2))
                        }
                )
            }
            

            // MARK: with successor
            
            category("with successor")
            {
                
                // MARK: not matching
                
                test(
                    "not matching",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(3)
                        },
                    expectations:
                        {
                            not("sub" > receiveValue(1))

                            not("sub" > receiveValue(2))
                            
                            "sub" > receiveValue(3)
                        },
                    expectationsInverse:
                        {
                            not("sub" > receiveValue(1))

                            not("sub" > receiveValue(2))

                            "sub" > receiveValue(3) !! fulfilledInverse
                        }
                )

                
                // MARK: matching first
                
                test(
                    "matching first",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                        },
                    expectations:
                        {
                            not("sub" > receiveValue(1)    !! fulfilledInverse)

                            not("sub" > receiveValue(2))

                            "sub" > receiveValue(3)     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            not("sub" > receiveValue(1))

                            not("sub" > receiveValue(2)     !! unfulfilled)

                            "sub" > receiveValue(3)
                        }
                )

                
                // MARK: matching second
                
                test(
                    "matching second",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(2)
                        },
                    expectations:
                        {
                            not("sub" > receiveValue(1))

                            not("sub" > receiveValue(2)    !! fulfilledInverse)

                            "sub" > receiveValue(3)     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            not("sub" > receiveValue(1)     !! unfulfilled)

                            not("sub" > receiveValue(2))

                            "sub" > receiveValue(3)
                        }
                )
            }
        }
        
        
        // MARK: - INSIDE SECTION WITH SUCCESSOR
        
        category("inside section with successor")
        {
            
            // MARK: successor matching
            
            test(
                "successor matching",
                setup:
                    {
                        testbox, subject, sub in
                        
                        testbox.section("section")
                        {
                            subject.send(2)
                        }
                    },
                expectations:
                    {
                        /*
                         value (2) must be handled inside the section and cannot be forwarded to the successor. Thats why successor remains unfulfilled.
                         */
                        
                        section("section")
                        {
                            not("sub" > receiveValue(1))
                        }
                        
                        "sub" > receiveValue(2)     !! unfulfilled
                    },
                expectationsInverse:
                    {
                        section("section")
                        {
                            not("sub" > receiveValue(1))
                        }
                        !! fulfilledInverse
                        
                        "sub" > receiveValue(2)     !! fulfilledInverse
                    },
                reportedEvents: [.receiveValue, .section]
            )

            
            // MARK: successor not matching
            
            test(
                "successor not matching",
                setup:
                    {
                        testbox, subject, sub in
                        
                        testbox.section("section")
                        {
                            subject.send(3)
                        }
                    },
                expectations:
                    {
                        section("section")
                        {
                            not("sub" > receiveValue(1))
                        }
                        
                        "sub" > receiveValue(2)     !! unfulfilled
                    },
                expectationsInverse:
                    {
                        section("section")
                        {
                            not("sub" > receiveValue(1))
                        }
                        !! fulfilledInverse
                        
                        "sub" > receiveValue(2)
                    },
                reportedEvents: [.receiveValue, .section]
            )
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
                        
                        subject.send(2)
                    },
                expectations:
                    {
                        not("sub" > receiveValue(1))
                        
                        strict(.receiveValue)
                        {
                            "sub" > receiveValue(2)
                        }
                    },
                expectationsInverse:
                    {
                        not("sub" > receiveValue(1)     !! unfulfilled)
                        
                        strict(.receiveValue)
                        {
                            "sub" > receiveValue(2)
                        }
                    }
            )

            
            // MARK: mismatching
            
            test(
                "mismatching",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(3)
                    },
                expectations:
                    {
                        /*
                         value (3) is forwarded to successor (strict), but not matched in the expectation inside.
                         "not" fulfills. the expectation inside strict remains unfulfilled.
                         */
                        
                        not("sub" > receiveValue(1))
                        
                        strict(.receiveValue)
                        {
                            "sub" > receiveValue(2)     !! mismatching .. "sub" > receiveValue(3)
                        }
                    },
                expectationsInverse:
                    {
                        not("sub" > receiveValue(1))
                        
                        strict(.receiveValue)
                        {
                            "sub" > receiveValue(2)     !! mismatching .. "sub" > receiveValue(3)
                        }
                    }
            )
        }
        
        
        // MARK: - MANUAL TEST CASES

        /*
         ⚠️ These tests cannot be tested automatically. Instead, they are tested MANUALLY by inspecting the behaviour in the console.
         */
        
        category("MANUAL TEST CASES")
        {
            
            // MARK: successor is nested
            
            /*
             background:
             
             this case is to check if NOT fulfills after value (2) is matched in the successor.
             
             NOT should fulfill after an event was matched in its successor, because this means that the job of NOT is done and subsequent events are handled in the following expectations.
             */
            
            category("successor is nested")
            {
                test(
                    "",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(2)
                        },
                    expectations:
                        {
                            not("sub" > receiveValue(1))
                            
                            group
                            {
                                "sub" > receiveValue(2)
                                "sub" > receiveValue(3)     !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            not("sub" > receiveValue(1)     !! unfulfilled)
                            
                            group
                            {
                                "sub" > receiveValue(2)
                                "sub" > receiveValue(3)
                            }
                        }
                )
            }
        }
    }
}
