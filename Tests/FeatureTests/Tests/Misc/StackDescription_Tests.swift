//
//  StackDescription_Tests.swift
//  
//
//  Created by Stefan Ueter on 30.03.23.
//

import Foundation
import CombineTestbox
import Combine
import XCTest
import GeneratedTestCase


class StackDescription_Tests: FeatureTestCase
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
        category("3 levels")
        {
            test(
                "one missing",
                setup:
                    {
                        testbox, subject, sub in
                        
                        for a in 1...2
                        {
                            for b in 1...2
                            {
                                for c in 1...2
                                {
                                    let value = a * b * c
                                    
                                    // skip value 8
                                    if value == 8
                                    {
                                        return
                                    }
                                    
                                    subject.send(value)
                                }
                            }
                        }
                    },
                expectations:
                    {
                        strict(.receiveValue)
                        {
                            forEach([1,2])
                            {
                                a in
                                
                                forEach([1,2])
                                {
                                    b in
                                    
                                    forEach([1,2])
                                    {
                                        c in
                                        
                                        "sub" > receiveValue(a * b * c)     !! unfulfilled ~~ /2/2/2
                                    }
                                }
                            }
                        }
                    },
                expectationsInverse:
                    {
                        strict(.receiveValue)
                        {
                            forEach([1,2])
                            {
                                a in
                                
                                forEach([1,2])
                                {
                                    b in
                                    
                                    forEach([1,2])
                                    {
                                        c in
                                        
                                        "sub" > receiveValue(a * b * c)
                                    }
                                }
                            }
                        }
                    }
            )
        }
    }
}
