//
//  PrintLogger+Debug+Test.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


extension PrintLogger.Debug
{
    enum Test
    {
        static
        func test
        (
            event: Event,
            context: TestContext,
            expectation: Expectation
        )
        -> String
        {
            PrintLogger.debugStringForComponents(
                [
                    "test:", event.description,
                    "in:", PrintLogger.stringForExpectation(expectation)
                ]
            )
        }


        static
        func testSuccessor
        (
            event: Event,
            context: TestContext,
            expectation: Expectation,
            successor: Expectation
        )
        -> String
        {
            let successorString =
                Constants.Icons.successor
                + " "
                + PrintLogger.stringForExpectation(successor)
            
            let string = PrintLogger.debugStringForComponents(
                [
                    "testSuccessor:", successorString,
                    event.description,
                    "in:", PrintLogger.stringForExpectation(expectation)
                ]
            )

            return string
        }
    }
}
