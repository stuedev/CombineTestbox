//
//  PrintLogger+Debug+Finalize.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


extension PrintLogger.Debug
{
    enum Finalize
    {
        static
        func finalize
        (
            expectation: Expectation
        )
        -> String
        {
            PrintLogger.debugStringForComponents(
                [
                    "finalize:",
                    PrintLogger.stringForExpectation(expectation)
                ]
            )
        }
    }
}
