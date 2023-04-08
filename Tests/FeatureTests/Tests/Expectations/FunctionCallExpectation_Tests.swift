//
//  FunctionCallExpectation_Tests.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation
import CombineTestbox
import Combine
import XCTest
import GeneratedTestCase


class FunctionCallExpectation_Tests: FeatureTestCase
{
    override
    static
    func setUp()
    {
        Testbox.config.debug.state = false
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
            
            // MARK: matching

            test(
                "matching",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                    },
                expectations:
                    {
                        let function =
                        {
                            Function("func")
                            {
                                "sub" > receiveValue(1)
                            }
                        }

                        call(function(), "call")
                    },
                expectationsInverse:
                    {
                        let function =
                        {
                            Function("func")
                            {
                                "sub" > receiveValue(1)     !! fulfilledInverse
                            }
                        }

                        call(function(), "call")
                    }
            )
            
            
            // MARK: one unfulfilled

            test(
                "one unfulfilled",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                    },
                expectations:
                    {
                        let function =
                        {
                            (value: Int) in
                            
                            Function("func")
                            {
                                "sub" > receiveValue(value)     !! unfulfilled ~~ /"call 2"
                            }
                        }

                        call(function(1), "call 1")
                        call(function(2), "call 2")
                    },
                expectationsInverse:
                    {
                        let function =
                        {
                            (value: Int) in
                            
                            Function("func")
                            {
                                "sub" > receiveValue(value)     !! fulfilledInverse ~~ /"call 1"
                            }
                        }

                        call(function(1), "call 1")
                        call(function(2), "call 2")
                    }
            )
        }
        
        
        // MARK: - NESTED FUNCTIONS
        
        category("nested functions")
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
                        let function_inner =
                        {
                            (value: Int) in
                            
                            Function("inner")
                            {
                                "sub" > receiveValue(value)
                            }
                        }
                        
                        let function_outer =
                        {
                            (value: Int) in

                            Function("outer")
                            {
                                call(function_inner(value), "call inner")
                            }
                        }
                        
                        call(function_outer(1), "call outer 1")
                        call(function_outer(2), "call outer 2")
                    },
                expectationsInverse:
                    {
                        let function_inner =
                        {
                            (value: Int) in
                            
                            Function("inner")
                            {
                                "sub" > receiveValue(value)     !! fulfilledInverse ~~ /"call outer 1"/"call inner"
                            }
                        }
                        
                        let function_outer =
                        {
                            (value: Int) in

                            Function("outer")
                            {
                                call(function_inner(value), "call inner")
                            }
                        }
                        
                        call(function_outer(1), "call outer 1")
                        call(function_outer(2), "call outer 2")
                    }
            )

            
            // MARK: one unfulfilled
            
            test(
                "one unfulfilled",
                setup:
                    {
                        testbox, subject, sub in
                        
                        subject.send(1)
                    },
                expectations:
                    {
                        let function_inner =
                        {
                            (value: Int) in
                            
                            Function("inner")
                            {
                                "sub" > receiveValue(value)     !! unfulfilled ~~ /"call outer 2"/"call inner"
                            }
                        }
                        
                        let function_outer =
                        {
                            (value: Int) in

                            Function("outer")
                            {
                                call(function_inner(value), "call inner")
                            }
                        }
                        
                        call(function_outer(1), "call outer 1")
                        call(function_outer(2), "call outer 2")
                    },
                expectationsInverse:
                    {
                        let function_inner =
                        {
                            (value: Int) in
                            
                            Function("inner")
                            {
                                "sub" > receiveValue(value)     !! fulfilledInverse ~~ /"call outer 1"/"call inner"
                            }
                        }
                        
                        let function_outer =
                        {
                            (value: Int) in

                            Function("outer")
                            {
                                call(function_inner(value), "call inner")
                            }
                        }
                        
                        call(function_outer(1), "call outer 1")
                        call(function_outer(2), "call outer 2")
                    }
            )
        }
    }
}
