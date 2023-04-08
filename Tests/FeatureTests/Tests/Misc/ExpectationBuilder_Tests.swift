//
//  File.swift
//  
//
//  Created by Stefan Ueter on 02.04.23.
//

import Foundation
import CombineTestbox
import Combine
import XCTest


class ExpectationBuilder_Tests: XCTestCase
{
    static
    override
    func setUp()
    {
        Testbox.config.reportedEvents = .receiveValue
    }
    
    
    
    // MARK: declarations
    
    func test__declarations__simple()
    {
        let testbox =
        Testbox
        {
            let value = 1
            
            "sub" > receiveValue(value)
        }
        
        let _ =
        [1].publisher
            .testSink(testbox, probe: "sub")
        
        testbox.wait(timeout: 0.01)
    }
    
    
    func test__declarations__closure()
    {
        let testbox =
        Testbox
        {
            let receive =
            {
                (value: Int) in
                
                Function("receive")
                {
                    "sub" > receiveValue(value)
                }
            }
            
            call(receive(1), "1")
        }
        
        let _ =
        [1].publisher
            .testSink(testbox, probe: "sub")
        
        testbox.wait(timeout: 0.01)
    }
    
    
    
    // MARK: if / else
    
    func test__if_else__first()
    {
        let value = 1
        
        let testbox =
        Testbox
        {
            if value == 1
            {
                "sub" > receiveValue(1)
            }
            else
            {
                "sub" > receiveValue(2)
            }
        }
        
        let _ =
        [1].publisher
            .testSink(testbox, probe: "sub")
        
        testbox.wait(timeout: 0.01)
    }
    
    
    func test__if_else__second_1()
    {
        let value = 2
        
        let testbox =
        Testbox
        {
            if value == 1
            {
                "sub" > receiveValue(1)
            }
            else
            {
                "sub" > receiveValue(2)
            }
        }
        
        let _ =
        [2].publisher
            .testSink(testbox, probe: "sub")
        
        testbox.wait(timeout: 0.01)
    }
    
    
    func test__if_else__second_2()
    {
        let value = 3
        
        let testbox =
        Testbox
        {
            if value == 1
            {
                "sub" > receiveValue(1)
            }
            else if value == 2
            {
                "sub" > receiveValue(2)
            }
            else
            {
                "sub" > receiveValue(3)
            }
        }
        
        let _ =
        [3].publisher
            .testSink(testbox, probe: "sub")
        
        testbox.wait(timeout: 0.01)
    }
    
    
    
    // MARK: optional
    
    func test__optional__true()
    {
        let second = true
        
        let testbox =
            Testbox
            {
                "sub" > receiveValue(1)
                
                if second
                {
                    "sub" > receiveValue(2)
                }
            }
        
        let _ =
            [1,2].publisher
                .testSink(testbox, probe: "sub")
            
        testbox.wait(timeout: 0.01)
    }
    
    
    func test__optional__false()
    {
        let second = false
        
        let testbox =
            Testbox
            {
                "sub" > receiveValue(1)
                
                if second
                {
                    "sub" > receiveValue(2)
                }
            }
        
        let _ =
            [1].publisher
                .testSink(testbox, probe: "sub")
        
        testbox.wait(timeout: 0.01)
    }
    
    
    
    // MARK: for loop
    
    func test__for_loop()
    {
        let testbox =
        Testbox
            {
                for value in [1,2]
                {
                    "sub" > receiveValue(value)
                }
            }
        
        let _ =
            [1,2].publisher
                .testSink(testbox, probe: "sub")
        
        testbox.wait(timeout: 0.01)
    }
}
