//
//  Combine_ReceiveCompletion_Tests.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation
import CombineTestbox
import Combine
import XCTest
import GeneratedTestCase


class Combine_ReceiveCompletion_Tests: FeatureTestCase
{
    override
    static
    func setUp()
    {
        Testbox.config.debug.state = false
        Testbox.config.debug.test = false
        Testbox.config.reportedEvents = .receiveCompletion
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
                // MARK: matching finished
                
                test(
                    "matching finished",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(completion: .finished)
                        },
                    expectations:
                        {
                            "sub" > receiveCompletion(.finished)
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveCompletion(.finished)     !! fulfilledInverse
                        }
                )

                
                // MARK: matching failure
                
                test(
                    "matching failure",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(completion: .failure(DummyError()))
                        },
                    expectations:
                        {
                            "sub" > receiveCompletion(.failure(DummyError()))
                        },
                    expectationsInverse:
                        {
                                "sub" > receiveCompletion(.failure(DummyError()))   !! fulfilledInverse
                        }
                )

                
                // MARK: mismatching completion
                
                test(
                    "mismatching completion",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(completion: .finished)
                        },
                    expectations:
                        {
                            "sub" > receiveCompletion(.failure(DummyError()))   !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveCompletion(.failure(DummyError()))
                        }
                )

                
                // MARK: mismatching failure
                
                test(
                    "mismatching failure",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(completion: .failure(DummyError()))
                        },
                    expectations:
                        {
                            "sub" > receiveCompletion(.failure(DummyError2()))  !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveCompletion(.failure(DummyError2()))
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
                            "sub" > receiveCompletion(.finished)    !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveCompletion(.finished)
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
                            
                            subject.send(completion: .finished)
                        },
                    expectations:
                        {
                            "sub" > receiveCompletion()
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveCompletion()     !! fulfilledInverse
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
                            "sub" > receiveCompletion()     !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveCompletion()
                        }
                )
            }
            
            
            // MARK: testError
            
            category("testError")
            {
                // MARK: matching failure
                
                test(
                    "matching failure",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(completion: .failure(DummyError()))
                        },
                    expectations:
                        {
                            "sub" > receiveCompletion { $0 is DummyError }
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveCompletion { $0 is DummyError }   !! fulfilledInverse
                        },
                    GUARANTEE_EQUAL_STRUCTURE: true
                )

                
                // MARK: mismatching failure
                
                test(
                    "mismatching failure",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(completion: .failure(DummyError()))
                        },
                    expectations:
                        {
                            "sub" > receiveCompletion { $0 is DummyError2}  !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveCompletion { $0 is DummyError2}
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
                            "sub" > receiveCompletion { $0 is DummyError }    !! unfulfilled
                        },
                    expectationsInverse:
                        {
                            "sub" > receiveCompletion { $0 is DummyError }
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
                // MARK: matching finished
                
                test(
                    "matching finished",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(completion: .finished)
                        },
                    expectations:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion(.finished)
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion(.finished)
                            }
                            !! fulfilledInverse
                        }
                )

                
                // MARK: matching failure
                
                test(
                    "matching failure",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(completion: .failure(DummyError()))
                        },
                    expectations:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion(.failure(DummyError()))
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion(.failure(DummyError()))
                            }
                            !! fulfilledInverse
                        }
                )

                
                // MARK: mismatching completion
                
                test(
                    "mismatching completion",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(completion: .finished)
                        },
                    expectations:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion(.failure(DummyError()))   !! mismatching .. "sub" > receiveCompletion(.finished)
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion(.failure(DummyError()))   !! mismatching .. "sub" > receiveCompletion(.finished)
                            }
                        }
                )

                
                // MARK: mismatching failure
                
                test(
                    "mismatching failure",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(completion: .failure(DummyError()))
                        },
                    expectations:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion(.failure(DummyError2()))  !! mismatching .. "sub" > receiveCompletion(.failure(DummyError()))
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion(.failure(DummyError2()))  !! mismatching .. "sub" > receiveCompletion(.failure(DummyError()))
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
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion(.finished)    !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion(.finished)
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
                            
                            subject.send(completion: .finished)
                        },
                    expectations:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion()
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion()
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
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion()     !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion()
                            }
                        }
                )
            }
            
            
            // MARK: testError
            
            category("testError")
            {
                // MARK: matching failure
                
                test(
                    "matching failure",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(completion: .failure(DummyError()))
                        },
                    expectations:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion { $0 is DummyError }
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion { $0 is DummyError }
                            }
                            !! fulfilledInverse
                        },
                    GUARANTEE_EQUAL_STRUCTURE: true
                )

                
                // MARK: mismatching failure
                
                test(
                    "mismatching failure",
                    setup:
                        {
                            testbox, subject, sub in
                            
                            subject.send(completion: .failure(DummyError()))
                        },
                    expectations:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion { $0 is DummyError2 }     !! mismatching .. "sub" > receiveCompletion(.failure(DummyError()))
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion { $0 is DummyError2 }     !! mismatching .. "sub" > receiveCompletion(.failure(DummyError()))
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
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion { $0 is DummyError }      !! unfulfilled
                            }
                        },
                    expectationsInverse:
                        {
                            strict(.receiveCompletion)
                            {
                                "sub" > receiveCompletion { $0 is DummyError }
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
                        
                        subject.send(completion: .finished)
                    },
                expectations:
                    {
                        strict(.receiveCompletion)
                        {
                            "sub" > receiveValue(1)     !! unexpected .. "sub" > receiveCompletion(.finished)
                        }
                    },
                expectationsInverse:
                    {
                        strict(.receiveCompletion)
                        {
                            "sub" > receiveValue(1)     !! unexpected .. "sub" > receiveCompletion(.finished)
                        }
                    }
            )
        }
    }
}
