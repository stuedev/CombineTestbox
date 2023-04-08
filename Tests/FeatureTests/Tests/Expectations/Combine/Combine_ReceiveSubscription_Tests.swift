//
//  Combine_ReceiveSubscription_Tests.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation
import CombineTestbox
import Combine
import XCTest
import GeneratedTestCase


class Combine_ReceiveSubscription_Tests: FeatureTestCase
{
    override
    static
    func setUp()
    {
        Testbox.config.debug.state = false
        Testbox.config.debug.test = false
        Testbox.config.reportedEvents = .receiveSubscription
    }
    
    
    @TestBuilder
    override
    static
    func buildTests() -> [Test]
    {
        // MARK: - NOT STRICT
        
        category("not strict")
        {
            // MARK: specific
            
            category("specific")
            {
                // MARK: matching name
                
                test(
                    "matching name",
                    setup:
                        {
                            testbox, subject, sub in

                            // receiveSubscription("PassthroughSubject") event is produced during setup
                        },
                    expectations:
                        {
                            "sub" > receiveSubscription("PassthroughSubject")
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveSubscription("PassthroughSubject")     !! fulfilledInverse
                        }
                )
                
                
                // MARK: mismatching name
                
                test(
                    "mismatching name",
                    setup:
                        {
                            testbox, subject, sub in

                            // receiveSubscription("PassthroughSubject") event is produced during setup
                        },
                    expectations:
                        {
                            "sub" > receiveSubscription("aaa")     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveSubscription("aaa")
                        }
                )
                
                
                // MARK: missing
                
                test(
                    "missing",
                    setup:
                        {
                            testbox, subject, sub in

                            // receiveSubscription("PassthroughSubject") event is produced during setup, but not reported!
                        },
                    expectations:
                        {
                            "sub" > receiveSubscription("PassthroughSubject")     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveSubscription("PassthroughSubject")
                        },
                    reportedEvents: EventTypeOptions.none
                )
            }
            
            
            // MARK: unspecific
            
            category("unspecific")
            {
                // MARK: present
                
                test(
                    "present",
                    setup:
                        {
                            testbox, subject, sub in

                            // receiveSubscription("PassthroughSubject") event is produced during setup
                        },
                    expectations:
                        {
                            "sub" > receiveSubscription()
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveSubscription()     !! fulfilledInverse
                        }
                )
                
                
                // MARK: missing
                
                test(
                    "missing",
                    setup:
                        {
                            testbox, subject, sub in

                            // receiveSubscription("PassthroughSubject") event is produced during setup, but not reported!
                        },
                    expectations:
                        {
                            "sub" > receiveSubscription()     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveSubscription()
                        },
                    reportedEvents: EventTypeOptions.none
                )
            }
        }
        
        
        // MARK: - STRICT
        
        category("strict")
        {
            // MARK: specific
            
            category("specific")
            {
                // MARK: matching name
                
                test(
                    "matching name",
                    setup:
                        {
                            testbox, subject, sub in

                            // receiveSubscription("PassthroughSubject") event is produced during setup
                        },
                    expectations:
                        {
                            strict(.receiveSubscription)
                            {
                                "sub" > receiveSubscription("PassthroughSubject")
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveSubscription)
                            {
                                "sub" > receiveSubscription("PassthroughSubject")
                            }
                            !! fulfilledInverse
                        }
                )
                
                
                // MARK: mismatching name
                
                test(
                    "mismatching name",
                    setup:
                        {
                            testbox, subject, sub in

                            // receiveSubscription("PassthroughSubject") event is produced during setup
                        },
                    expectations:
                        {
                            strict(.receiveSubscription)
                            {
                                "sub" > receiveSubscription("aaa")      !! mismatching .. "sub" > receiveSubscription("PassthroughSubject")
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveSubscription)
                            {
                                "sub" > receiveSubscription("aaa")      !! mismatching .. "sub" > receiveSubscription("PassthroughSubject")
                            }
                        }
                )
                
                
                // MARK: missing
                
                test(
                    "missing",
                    setup:
                        {
                            testbox, subject, sub in

                            // receiveSubscription("PassthroughSubject") event is produced during setup, but not reported!
                        },
                    expectations:
                        {
                            strict(.receiveSubscription)
                            {
                                "sub" > receiveSubscription("PassthroughSubject")  !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveSubscription)
                            {
                                "sub" > receiveSubscription("PassthroughSubject")
                            }
                        },
                    reportedEvents: EventTypeOptions.none
                )
            }
            
            
            // MARK: unspecific
            
            category("unspecific")
            {
                // MARK: present
                
                test(
                    "present",
                    setup:
                        {
                            testbox, subject, sub in

                            // receiveSubscription("PassthroughSubject") event is produced during setup
                        },
                    expectations:
                        {
                            strict(.receiveSubscription)
                            {
                                "sub" > receiveSubscription()
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveSubscription)
                            {
                                "sub" > receiveSubscription()
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

                            // receiveSubscription("PassthroughSubject") event is produced during setup, but not reported!
                        },
                    expectations:
                        {
                            strict(.receiveSubscription)
                            {
                                "sub" > receiveSubscription()     !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveSubscription)
                            {
                                "sub" > receiveSubscription()
                            }
                        },
                    reportedEvents: EventTypeOptions.none
                )
            }
            
            
            // MARK: unexpected
            
            test(
                "unexpected",
                setup:
                    {
                        testbox, subject, sub in

                        // receiveSubscription("PassthroughSubject") event is produced during setup

                        subject.send(1)
                    },
                expectations:
                    {
                        strict(.receiveSubscription)
                        {
                            "sub" > receiveValue(1)     !! unexpected .. "sub" > receiveSubscription("PassthroughSubject")
                        }
                    },
                expectationsInverse:
                    {
                        strict(.receiveSubscription)
                        {
                            "sub" > receiveValue(1)     !! unexpected .. "sub" > receiveSubscription("PassthroughSubject")
                        }
                    },
                reportedEvents: [.receiveSubscription, .receiveValue]
            )
        }
    }
}
