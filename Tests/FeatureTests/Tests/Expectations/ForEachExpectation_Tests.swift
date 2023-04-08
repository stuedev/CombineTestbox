//
//  ForEachExpectation_Tests.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation
import CombineTestbox
import Combine
import XCTest
import GeneratedTestCase


class ForEachExpectation_Tests: FeatureTestCase
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
            
            // MARK: all iterations fulfilled
            
            test(
                "all iterations fulfilled",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                        subject.send(2)
                    },
                expectations:
                    {
                        forEach([1,2])
                        {
                            "sub" > receiveValue($0)
                        }
                    },
                expectationsInverse:
                    {
                        forEach([1,2])
                        {
                            "sub" > receiveValue($0)    !! fulfilledInverse ~~ /1
                        }
                    }
            )

            
            // MARK: one iteration unfulfilled
            
            test(
                "one iteration unfulfilled",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                    },
                expectations:
                    {
                        forEach([1,2])
                        {
                            "sub" > receiveValue($0)    !! unfulfilled ~~ /2
                        }
                    },
                expectationsInverse:
                    {
                        forEach([1,2])
                        {
                            "sub" > receiveValue($0)    !! fulfilledInverse ~~ /1
                        }
                    }
            )

        }
        
        
        // MARK: - INSIDE STRICT
        
        category("inside strict")
        {
            
            // MARK: all iterations fulfilled
            
            test(
                "all iterations fulfilled",
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
                            forEach([1,2])
                            {
                                "sub" > receiveValue($0)
                            }
                        }
                    },
                expectationsInverse:
                    {
                        strict(.receiveValue)
                        {
                            forEach([1,2])
                            {
                                "sub" > receiveValue($0)
                            }
                        }
                        !! fulfilledInverse
                    }
            )

            
            // MARK: one iteration unfulfilled
            
            test(
                "one iteration unfulfilled",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                    },
                expectations:
                    {
                        strict(.receiveValue)
                        {
                            forEach([1,2])
                            {
                                "sub" > receiveValue($0)    !! unfulfilled ~~ /2
                            }
                        }
                    },
                expectationsInverse:
                    {
                        strict(.receiveValue)
                        {
                            forEach([1,2])
                            {
                                "sub" > receiveValue($0)
                            }
                        }
                    }
            )

            
            // MARK: one iteration mismatching
            
            test(
                "one iteration mismatching",
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
                            forEach([1,2])
                            {
                                "sub" > receiveValue($0)    !! mismatching .. "sub" > receiveValue(3) ~~ /2
                            }
                        }
                    },
                expectationsInverse:
                    {
                        strict(.receiveValue)
                        {
                            forEach([1,2])
                            {
                                "sub" > receiveValue($0)    !! mismatching .. "sub" > receiveValue(3) ~~ /2
                            }
                        }
                    }
            )

            
            // MARK: one iteration unexpected
            
            test(
                "one iteration unexpected",
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
                            forEach([1,2])
                            {
                                "sub" > receiveValue($0)
                            }
                        }
                        !! unexpected .. "sub" > receiveValue(3)
                    },
                expectationsInverse:
                    {
                        strict(.receiveValue)
                        {
                            forEach([1,2])
                            {
                                "sub" > receiveValue($0)
                            }
                        }
                        !! unexpected .. "sub" > receiveValue(3)
                    }
            )

        }

        
        // MARK: - NESTED FOREACH
        
        category("nested forEach")
        {
            // MARK: all matching
            
            test(
                "all matching",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                        subject.send(2)
                        
                        subject.send(1)
                        subject.send(2)
                    },
                expectations:
                    {
                        forEach([1,2])
                        {
                            _ in
                            
                            forEach([1,2])
                            {
                                "sub" > receiveValue($0)
                            }
                        }
                    },
                expectationsInverse:
                    {
                        forEach([1,2])
                        {
                            _ in
                            
                            forEach([1,2])
                            {
                                "sub" > receiveValue($0)    !! fulfilledInverse
                            }
                        }
                    }
            )

            
            // MARK: one unfulfilled
            
            test(
                "one unfulfilled",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                        subject.send(2)
                        
                        subject.send(1)
                    },
                fexpectations:
                    {
                        forEach(["1","2"])
                        {
                            _ in
                            
                            forEach([1,2])
                            {
                                "sub" > receiveValue($0)    !! unfulfilled ~~ /"2"/2
                            }
                        }
                    },
                expectationsInverse:
                    {
                        forEach(["1","2"])
                        {
                            _ in
                            
                            forEach([1,2])
                            {
                                "sub" > receiveValue($0)    !! fulfilledInverse
                            }
                        }
                    }
            )
        }
        
        
        // MARK: - WITH GROUP
        
        category("with group")
        {
            // MARK: all matching
            
            test(
                "all matching",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                        subject.send(2)
                        subject.send(1)
                        subject.send(2)
                    },
                expectations:
                    {
                        forEach([1,2])
                        {
                            _ in
                            
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)
                            }
                        }
                    },
                expectationsInverse:
                    {
                        forEach([1,2])
                        {
                            _ in
                            
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)
                            }
                            !! fulfilledInverse ~~ /1
                        }
                    }
            )

            
            // MARK: one missing
            
            test(
                "one missing",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                        subject.send(2)
                        subject.send(1)
                    },
                expectations:
                    {
                        forEach([1,2])
                        {
                            _ in
                            
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)     !! unfulfilled ~~ /2
                            }
                        }
                    },
                expectationsInverse:
                    {
                        forEach([1,2])
                        {
                            _ in
                            
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)
                            }
                            !! fulfilledInverse ~~ /1
                        }
                    }
            )

            
            // MARK: only one fulfilled
            
            /*
             (!) important test
             */
            
            test(
                "only one fulfilled",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                    },
                expectations:
                    {
                        forEach([1,2])
                        {
                            _ in
                            
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)     !! unfulfilled ~~ /1
                            }
                        }
                    },
                expectationsInverse:
                    {
                        forEach([1,2])
                        {
                            _ in
                            
                            group
                            {
                                "sub" > receiveValue(1)
                                "sub" > receiveValue(2)
                            }
                        }
                    }
            )
        }
        
        
        // MARK: - WITH STRICT
        
        category("with strict")
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
                         value (2) is handled in strict inside the first forEach iteration, because strict had not fulfilled yet.
                         the event is unexpected there and thus strict fails.
                         */
                        
                        forEach([1,2])
                        {
                            value in
                            
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(value)
                            }
                            !! unexpected .. "sub" > receiveValue(2)
                        }
                    },
                expectationsInverse:
                    {
                        forEach([1,2])
                        {
                            value in
                            
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(value)
                            }
                            !! unexpected .. "sub" > receiveValue(2)
                        }
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
                        /*
                         strict only fulfills late and "blocks" ForEach from producing the second iteration.
                         so ForEach remains unfulfilled.
                         */

                        forEach([1,2])
                        {
                            value in
                            
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(value)
                            }
                        }
                        !! unfulfilled
                    },
                expectationsInverse:
                    {
                        /*
                         strict inside second iteration remains unfulfilled. since it is inverse, it fails.
                         */
                        
                        forEach([1,2])
                        {
                            value in
                            
                            strict(.receiveValue)
                            {
                                "sub" > receiveValue(value)
                            }
                            !! fulfilledInverse
                        }
                    }
            )
        }
    }
}
