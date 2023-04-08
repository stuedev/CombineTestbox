//
//  Combine_Cancel_Tests.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation
import CombineTestbox
import Combine
import XCTest
import GeneratedTestCase


class Combine_Cancel_Tests: FeatureTestCase
{
    override
    static
    func setUp()
    {
        Testbox.config.debug.state = false
        Testbox.config.debug.test = false
        Testbox.config.reportedEvents = .cancel
    }


    @TestBuilder
    override
    static
    func buildTests() -> [Test]
    {
        // MARK: - NOT STRICT

        category("not strict")
        {
            // MARK: present
            
            test(
                "present",
                setup:
                    {
                        testbox, subject, sub in
                        
                        sub.cancel()
                    },
                expectations:
                    {
                        "sub" > cancel()
                    },
                expectationsInverse:
                    {
                        "sub" > cancel()     !! fulfilledInverse
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
                        "sub" > cancel()     !! unfulfilled
                    },
                expectationsInverse:
                    {
                        "sub" > cancel()
                    }
            )
        }


        // MARK: - STRICT

        category("strict")
        {
           
            // MARK: present
            
            test(
                "present",
                setup:
                    {
                        testbox, subject, sub in
                        
                        sub.cancel()
                    },
                expectations:
                    {
                        strict(.cancel)
                        {
                            "sub" > cancel()
                        }
                    },
                expectationsInverse:
                    {
                        strict(.cancel)
                        {
                            "sub" > cancel()
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
                        strict(.cancel)
                        {
                            "sub" > cancel()    !! unfulfilled
                        }
                    },
                expectationsInverse:
                    {
                        strict(.cancel)
                        {
                            "sub" > cancel()
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
                    
                    sub.cancel()
                },
            expectations:
                {
                    strict(.cancel)
                    {
                        "sub" > receiveValue(1)     !! unexpected .. "sub" > cancel()
                    }
                },
            expectationsInverse:
                {
                    strict(.cancel)
                    {
                        "sub" > receiveValue(1)     !! unexpected .. "sub" > cancel()
                    }
                }
        )
    }
}

