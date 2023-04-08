//
//  Combine_ReceiveSubscriber_Tests.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation
import CombineTestbox
import Combine
import XCTest
import GeneratedTestCase


class Combine_ReceiveSubscriber_Tests: FeatureTestCase
{
    override
    static
    func setUp()
    {
        Testbox.config.debug.state = false
        Testbox.config.debug.test = false
        Testbox.config.reportedEvents = .receiveSubscriber
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
                            
                            // receiveSubscriber("Sink") event is produced during setup
                        },
                    expectations:
                        {
                            "sub" > receiveSubscriber("Sink")
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveSubscriber("Sink")     !! fulfilledInverse
                        }
                )
                
                
                // MARK: mismatching name
                
                test(
                    "mismatching name",
                    setup:
                        {
                            testbox, subject, sub in
                        },
                    expectations:
                        {
                            "sub" > receiveSubscriber("aaa")     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveSubscriber("aaa")
                        }
                )
                
                
                // MARK: missing
                
                test(
                    "missing",
                    setup:
                        {
                            testbox, subject, sub in

                            // receiveSubscriber("Sink") event is produced during setup, but not reported!
                        },
                    expectations:
                        {
                            "sub" > receiveSubscriber("Sink")     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveSubscriber("Sink")
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

                            // receiveSubscriber("Sink") event is produced during setup
                        },
                    expectations:
                        {
                            "sub" > receiveSubscriber()
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveSubscriber()     !! fulfilledInverse
                        },
                    reportedEvents: .receiveSubscriber
                )
                
                
                // MARK: missing
                
                test(
                    "missing",
                    setup:
                        {
                            testbox, subject, sub in

                            // receiveSubscriber("Sink") event is produced during setup, but not reported!
                        },
                    expectations:
                        {
                            "sub" > receiveSubscriber()     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveSubscriber()
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

                            // receiveSubscriber("Sink") event is produced during setup
                        },
                    expectations:
                        {
                            strict(.receiveSubscriber)
                            {
                                "sub" > receiveSubscriber("Sink")
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveSubscriber)
                            {
                                "sub" > receiveSubscriber("Sink")
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

                            // receiveSubscriber("Sink") event is produced during setup
                        },
                    expectations:
                        {
                            strict(.receiveSubscriber)
                            {
                                "sub" > receiveSubscriber("aaa")    !! mismatching .. "sub" > receiveSubscriber("Sink")
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveSubscriber)
                            {
                                "sub" > receiveSubscriber("aaa")    !! mismatching .. "sub" > receiveSubscriber("Sink")
                            }
                        }
                )
                
                
                // MARK: missing
                
                test(
                    "missing",
                    setup:
                        {
                            testbox, subject, sub in

                            // receiveSubscriber("Sink") event is produced during setup, but not reported!
                        },
                    expectations:
                        {
                            strict(.receiveSubscriber)
                            {
                                "sub" > receiveSubscriber("Sink")   !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveSubscriber)
                            {
                                "sub" > receiveSubscriber("Sink")
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

                            // receiveSubscriber("Sink") event is produced during setup
                        },
                    expectations:
                        {
                            strict(.receiveSubscriber)
                            {
                                "sub" > receiveSubscriber()
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveSubscriber)
                            {
                                "sub" > receiveSubscriber()
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

                            // receiveSubscriber("Sink") event is produced during setup, but not reported!
                        },
                    expectations:
                        {
                            strict(.receiveSubscriber)
                            {
                                "sub" > receiveSubscriber()     !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveSubscriber)
                            {
                                "sub" > receiveSubscriber()
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

                        // receiveSubscriber("Sink") event is produced during setup

                        subject.send(1)
                    },
                expectations:
                    {
                        strict(.receiveSubscriber)
                        {
                            "sub" > receiveValue(1)     !! unexpected .. "sub" > receiveSubscriber("Sink")
                        }
                    },
                expectationsInverse:
                    {
                        strict(.receiveSubscriber)
                        {
                            "sub" > receiveValue(1)     !! unexpected .. "sub" > receiveSubscriber("Sink")
                        }
                    },
                reportedEvents: [.receiveSubscriber, .receiveValue]
            )
        }
    }
}
