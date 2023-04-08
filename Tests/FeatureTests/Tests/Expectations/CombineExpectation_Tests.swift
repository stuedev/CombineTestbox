//
//  CombineExpectation.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation
import CombineTestbox
import Combine
import XCTest
import GeneratedTestCase


class CombineExpectation_Tests: FeatureTestCase
{
    override
    static
    func setUp()
    {
        Testbox.config.debug.state = false
        Testbox.config.debug.test = false
        Testbox.config.reportedEvents = [.receiveValue]
    }

    
    @TestBuilder
    override
    static
    func buildTests() -> [Test]
    {
        // MARK: - multiple
        
        category("multiple")
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
                        "sub" > receiveValue(1)
                        "sub" > receiveValue(2)
                    },
                expectationsInverse:
                    {
                        "sub" > receiveValue(1)     !! fulfilledInverse
                        "sub" > receiveValue(2)
                    }
            )

            
            // MARK: missing first
            
            test(
                "missing first",
                setup:
                    {
                        testbox, subject, sub in
                        
                        // subject.send(1)  // missing
                        subject.send(2)
                    },
                expectations:
                    {
                        "sub" > receiveValue(1)     !! unfulfilled
                        "sub" > receiveValue(2)
                    },
                expectationsInverse:
                    {
                        "sub" > receiveValue(1)
                        "sub" > receiveValue(2)     !! fulfilledInverse
                    }
            )

            
            // MARK: missing second
            
            test(
                "missing second",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                        // subject.send(2)  // missing
                    },
                expectations:
                    {
                        "sub" > receiveValue(1)
                        "sub" > receiveValue(2)     !! unfulfilled
                    },
                expectationsInverse:
                    {
                        "sub" > receiveValue(1)     !! fulfilledInverse
                        "sub" > receiveValue(2)
                    }
            )

        }
    }
}
