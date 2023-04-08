//
//  PrintLogger+Failures.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


extension PrintLogger
{
    enum Failures
    {
        static
        func failure
        (
            expectation: Expectation,
            failure: Failure,
            isRedeemed: Bool
        )
        -> String
        {
            var string = "-" * 100 + "\n" * 2

            switch isRedeemed
            {
                case false:
                    
                    string += Constants.Icons.failed + " FAILURE:"
                    
                    
                case true:
                    
                    string += Constants.Icons.redeemed + " FAILURE (redeemed):"
            }
            
            string += "\n" * 2

            string += PrintLogger.stringForComponents(
                [
                    failure.description,
                    "in:", PrintLogger.stringForExpectation(expectation)
                ]
            )
            
            if expectation.stack.hasEntries
            {
                string += "\n" * 2
                string += "=" * 10 + " Stack " + "=" * 10 + "\n"
                string += expectation.stack.toString()
                string += "\n"
            }

            string += "\n"
            string += "-" * 100

            return string
        }
    }
}
