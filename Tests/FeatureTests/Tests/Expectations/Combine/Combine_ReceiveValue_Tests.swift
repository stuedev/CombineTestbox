//
//  Combine_ReceiveValue_Tests.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation
import CombineTestbox
import Combine
import XCTest
import GeneratedTestCase


class Combine_ReceiveValue_Tests: FeatureTestCase
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
        // MARK: - NOT STRICT
        
        category("not strict")
        {
            // MARK: specific
            
            category("specific")
            {
                // MARK: matching value
                
                test(
                    "matching value",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                        },
                    expectations:
                        {
                            "sub" > receiveValue(1)
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveValue(1)     !! fulfilledInverse
                        }
                )
                
                
                // MARK: mismatching value
                
                test(
                    "mismatching value",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                        },
                    expectations:
                        {
                            "sub" > receiveValue(2)     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveValue(2)
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
                            "sub" > receiveValue(1)     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveValue(1)
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
                        },
                    expectations:
                        {
                            "sub" > receiveValue()
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveValue()      !! fulfilledInverse
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
                            "sub" > receiveValue()  !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveValue()
                        }
                )
            }
            
            
            // MARK: test
            
            category("test")
            {
                // MARK: matching value
                
                test(
                    "matching value",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                        },
                    expectations:
                        {
                            "sub" > receiveValue { $0 as? Int == 1 }
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveValue { $0 as? Int == 1 }     !! fulfilledInverse
                        },
                    GUARANTEE_EQUAL_STRUCTURE: true
                )
                
                
                // MARK: mismatching value
                
                test(
                    "mismatching value",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                        },
                    expectations:
                        {
                            "sub" > receiveValue { $0 as? Int == 2 }     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveValue { $0 as? Int == 2 }
                        },
                    GUARANTEE_EQUAL_STRUCTURE: true
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
                            "sub" > receiveValue { $0 as? Int == 1 }     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveValue { $0 as? Int == 1 }
                        },
                    GUARANTEE_EQUAL_STRUCTURE: true
                )
            }

        }
        
        
        // MARK: - STRICT
        
        category("strict")
        {
            // MARK: specific
            
            category("specific")
            {
                // MARK: matching value
                
                test(
                    "matching value",
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
                
                
                // MARK: mismatching value
                
                test(
                    "mismatching value",
                    setup:
                        {
                            testbox, subject, sub in

                            subject.send(1)
                        },
                    expectations:
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(2)  !! mismatching .. "sub" > receiveValue(1)
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(2)     !! mismatching .. "sub" > receiveValue(1)
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
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)     !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(1)
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
                        },
                    expectations:
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue()
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue()
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
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue()     !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue()
                            }
                        }
                )
            }
            
            
            // MARK: test
            
            category("test")
            {
                // MARK: matching value
                
                test(
                    "matching value",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(1)
                        },
                    expectations:
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue { $0 as? Int == 1 }
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue { $0 as? Int == 1 }
                            }
                            !! fulfilledInverse
                        },
                    GUARANTEE_EQUAL_STRUCTURE: true
                )
                
                
                // MARK: mismatching value
                
                test(
                    "mismatching value",
                    setup:
                        {
                            testbox, subject, sub in

                            subject.send(1)
                        },
                    expectations:
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue { $0 as? Int == 2 }     !! mismatching .. "sub" > receiveValue(1)
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue { $0 as? Int == 2 }     !! mismatching .. "sub" > receiveValue(1)
                            }
                        },
                    GUARANTEE_EQUAL_STRUCTURE: true
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
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue { $0 as? Int == 1 }     !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue { $0 as? Int == 1 }
                            }
                        },
                    GUARANTEE_EQUAL_STRUCTURE: true
                )
            }

            
            // MARK: unexpected
            
            test(
                "unexpected",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                    },
                expectations:
                    {
                        strict(.receiveValue)
                        {
                            "sub" > receiveCompletion(.finished)     !! unexpected .. "sub" > receiveValue(1)
                        }
                    },
                expectationsInverse:
                    {
                        strict(.receiveValue)
                        {
                            "sub" > receiveCompletion(.finished)     !! unexpected .. "sub" > receiveValue(1)
                        }
                    }
            )
        }
    }
}
