//
//  Combine_RequestDemand_Tests.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation
import CombineTestbox
import Combine
import XCTest
import GeneratedTestCase


class Combine_RequestDemand_Tests: FeatureTestCase
{
    override
    static
    func setUp()
    {
        Testbox.config.debug.state = false
        Testbox.config.debug.test = false
        Testbox.config.reportedEvents = .requestDemand
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
                // MARK: matching demand
                
                test(
                    "matching demand",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            // .unlimited demand is requested during setup
                        },
                    expectations:
                        {
                            "sub" > requestDemand(.unlimited)
                        },
                    expectationsInverse:
                        {
                            "sub" > requestDemand(.unlimited)   !! fulfilledInverse
                        }
                )
                
                
                // MARK: mismatching demand
                
                test(
                    "mismatching name",
                    setup:
                        {
                            testbox, subject, sub in

                            // .unlimited demand is requested during setup
                        },
                    expectations:
                        {
                            "sub" > requestDemand(.max(99))     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > requestDemand(.max(99))
                        }
                )
                
                
                // MARK: missing
                
                test(
                    "missing",
                    setup:
                        {
                            testbox, subject, sub in

                            // .unlimited demand is requested during setup, but not reported!
                        },
                    expectations:
                        {
                            "sub" > requestDemand(.unlimited)   !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > requestDemand(.unlimited)
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

                            // .unlimited demand is requested during setup
                        },
                    expectations:
                        {
                            "sub" > requestDemand()
                        },
                    expectationsInverse:
                        {
                            "sub" > requestDemand()     !! fulfilledInverse
                        }
                )
                
                
                // MARK: missing
                
                test(
                    "missing",
                    setup:
                        {
                            testbox, subject, sub in

                            // .unlimited demand is requested during setup, but not reported!
                        },
                    expectations:
                        {
                            "sub" > requestDemand()     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > requestDemand()
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
                // MARK: matching demand
                
                test(
                    "matching demand",
                    setup:
                        {
                            testbox, subject, sub in

                            // .unlimited demand is requested during setup
                        },
                    expectations:
                        {
                            strict(.requestDemand)
                            {
                                "sub" > requestDemand(.unlimited)
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.requestDemand)
                            {
                                "sub" > requestDemand(.unlimited)
                            }
                            !! fulfilledInverse
                        }
                )
                
                
                // MARK: mismatching demand
                
                test(
                    "mismatching demand",
                    setup:
                        {
                            testbox, subject, sub in

                            // .unlimited demand is requested during setup
                        },
                    expectations:
                        {
                            strict(.requestDemand)
                            {
                                "sub" > requestDemand(.max(99))     !! mismatching .. "sub" > requestDemand(.unlimited)
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.requestDemand)
                            {
                                "sub" > requestDemand(.max(99))     !! mismatching .. "sub" > requestDemand(.unlimited)
                            }
                        }
                )
                
                
                // MARK: missing
                
                test(
                    "missing",
                    setup:
                        {
                            testbox, subject, sub in

                            // .unlimited demand is requested during setup, but not reported!
                        },
                    expectations:
                        {
                            strict(.requestDemand)
                            {
                                "sub" > requestDemand(.unlimited)     !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.requestDemand)
                            {
                                "sub" > requestDemand(.unlimited)
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

                            // .unlimited demand is requested during setup
                        },
                    expectations:
                        {
                            strict(.requestDemand)
                            {
                                "sub" > requestDemand()
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.requestDemand)
                            {
                                "sub" > requestDemand()
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

                            // .unlimited demand is requested during setup, but not reported!
                        },
                    expectations:
                        {
                            strict(.requestDemand)
                            {
                                "sub" > requestDemand()     !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.requestDemand)
                            {
                                "sub" > requestDemand()
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

                        // .unlimited demand is requested during setup
                    },
                expectations:
                    {
                        strict(.requestDemand)
                        {
                            "sub" > receiveValue(1)     !! unexpected .. "sub" > requestDemand(.unlimited)
                        }
                    },
                expectationsInverse:
                    {
                        strict(.requestDemand)
                        {
                            "sub" > receiveValue(1)     !! unexpected .. "sub" > requestDemand(.unlimited)
                        }
                    }
            )
        }
    }
}
