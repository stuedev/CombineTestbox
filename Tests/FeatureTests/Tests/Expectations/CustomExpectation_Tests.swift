//
//  File.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation
import CombineTestbox
import Combine
import XCTest
import GeneratedTestCase


class CustomExpectation_Tests: FeatureTestCase
{
    override
    static
    func setUp()
    {
        Testbox.config.debug.state = false
        Testbox.config.reportedEvents = .custom
    }
    
    
    @TestBuilder
    override
    static
    func buildTests() -> [Test]
    {
        // MARK: - SIMPLE
        
        category("simple")
        {
            // MARK: matching
            
            test(
                "matching",
                setup:
                    {
                        testbox, subject, sub in
                        
                        testbox.reportCustomEvent("aaa")
                    },
                expectations:
                    {
                        custom("aaa")
                    },
                expectationsInverse:
                    {
                        custom("aaa")   !! fulfilledInverse
                    }
            )

            
            // MARK: mismatching
            
            test(
                "mismatching",
                setup:
                    {
                        testbox, subject, sub in
                        
                        testbox.reportCustomEvent("bbb")
                    },
                expectations:
                    {
                        custom("aaa")   !! unfulfilled
                    },
                expectationsInverse:
                    {
                        custom("aaa")
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
                        custom("aaa")   !! unfulfilled
                    },
                expectationsInverse:
                    {
                        custom("aaa")
                    }
            )
        }
        
        
        // MARK: - INSIDE STRICT
        
        category("inside strict")
        {
            // MARK: matching
            
            test(
                "matching",
                setup:
                    {
                        testbox, subject, sub in
                        
                        testbox.reportCustomEvent("aaa")
                    },
                expectations:
                    {
                        strict(.custom)
                        {
                            custom("aaa")
                        }
                    },
                expectationsInverse:
                    {
                        strict(.custom)
                        {
                            custom("aaa")
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
                        
                        testbox.reportCustomEvent("bbb")
                    },
                expectations:
                    {
                        strict(.custom)
                        {
                            custom("aaa")   !! mismatching .. custom("bbb")
                        }
                    },
                expectationsInverse:
                    {
                        strict(.custom)
                        {
                            custom("aaa")   !! mismatching .. custom("bbb")
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
                        strict(.custom)
                        {
                            custom("aaa")   !! unfulfilled
                        }
                    },
                expectationsInverse:
                    {
                        strict(.custom)
                        {
                            custom("aaa")
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
                        testbox.reportCustomEvent("aaa")    // unexpected
                    },
                expectations:
                    {
                        strict(.custom)
                        {
                            "sub" > receiveValue(1)
                        }
                        !! unexpected .. custom("aaa")
                    },
                expectationsInverse:
                    {
                        strict(.custom)
                        {
                            "sub" > receiveValue(1)
                        }
                        !! unexpected .. custom("aaa")
                    },
                reportedEvents: [.custom, .receiveValue]
            )
        }
    }
}
