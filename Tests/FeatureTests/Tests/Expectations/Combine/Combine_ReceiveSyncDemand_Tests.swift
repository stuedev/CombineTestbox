//
//  Combine_ReceiveSyncDemand_Tests.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation
import CombineTestbox
import Combine
import XCTest
import GeneratedTestCase


class Combine_ReceiveSyncDemand_Tests: FeatureTestCase
{
    override
    static
    func setUp()
    {
        Testbox.config.debug.state = false
        Testbox.config.debug.test = false
        Testbox.config.reportedEvents = .requestSyncDemand
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
                            
                            subject.send(1)
                            
                            // sync demand of .none is requested after receiving value
                        },
                    expectations:
                        {
                            "sub" > requestSyncDemand(.none)
                        },
                    expectationsInverse:
                        {
                            "sub" > requestSyncDemand(.none)   !! fulfilledInverse
                        }
                )
                
                
                // MARK: mismatching demand
                
                test(
                    "mismatching demand",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)

                            // sync demand of .none is requested after receiving value
                        },
                    expectations:
                        {
                            "sub" > requestSyncDemand(.max(99))     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > requestSyncDemand(.max(99))
                        }
                )
                
                
                // MARK: missing
                
                test(
                    "missing",
                    setup:
                        {
                            testbox, subject, sub in
                        },
                    expectations:
                        {
                            "sub" > requestSyncDemand(.none)   !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > requestSyncDemand(.none)
                        }
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
                            
                            subject.send(1)

                            // sync demand of .none is requested after receiving value
                        },
                    expectations:
                        {
                            "sub" > requestSyncDemand()
                        },
                    expectationsInverse:
                        {
                            "sub" > requestSyncDemand()     !! fulfilledInverse
                        }
                )
                
                
                // MARK: missing
                
                test(
                    "missing",
                    setup:
                        {
                            testbox, subject, sub in
                        },
                    expectations:
                        {
                            "sub" > requestSyncDemand()     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > requestSyncDemand()
                        }
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
                            
                            subject.send(1)

                            // sync demand of .none is requested after receiving value
                        },
                    expectations:
                        {
                            strict(.requestSyncDemand)
                            {
                                "sub" > requestSyncDemand(.none)
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.requestSyncDemand)
                            {
                                "sub" > requestSyncDemand(.none)
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
                            
                            subject.send(1)

                            // sync demand of .none is requested after receiving value
                        },
                    expectations:
                        {
                            strict(.requestSyncDemand)
                            {
                                "sub" > requestSyncDemand(.max(99))     !! mismatching .. "sub" > requestSyncDemand(.none)
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.requestSyncDemand)
                            {
                                "sub" > requestSyncDemand(.max(99))     !! mismatching .. "sub" > requestSyncDemand(.none)
                            }
                        }
                )
                
                
                // MARK: missing
                
                test(
                    "missing",
                    setup:
                        {
                            testbox, subject, sub in
                        },
                    expectations:
                        {
                            strict(.requestSyncDemand)
                            {
                                "sub" > requestSyncDemand(.none)     !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.requestSyncDemand)
                            {
                                "sub" > requestSyncDemand(.none)
                            }
                        }
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
                            
                            subject.send(1)

                            // sync demand of .none is requested after receiving value
                        },
                    expectations:
                        {
                            strict(.requestSyncDemand)
                            {
                                "sub" > requestSyncDemand()
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.requestSyncDemand)
                            {
                                "sub" > requestSyncDemand()
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
                        },
                    expectations:
                        {
                            strict(.requestSyncDemand)
                            {
                                "sub" > requestSyncDemand()     !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.requestSyncDemand)
                            {
                                "sub" > requestSyncDemand()
                            }
                        }
                )
            }
            
            
            // MARK: unexpected
            
            test(
                "unexpected",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)

                        // sync demand of .none is requested after receiving value
                    },
                expectations:
                    {
                        strict(.requestSyncDemand)
                        {
                            "sub" > receiveValue(1)     !! unexpected .. "sub" > requestSyncDemand(.none)
                        }
                    },
                expectationsInverse:
                    {
                        strict(.requestSyncDemand)
                        {
                            "sub" > receiveValue(1)     !! unexpected .. "sub" > requestSyncDemand(.none)
                        }
                    }
            )
        }
    }
}
