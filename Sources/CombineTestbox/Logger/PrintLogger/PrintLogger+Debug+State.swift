//
//  PrintLogger+Debug+State.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


extension PrintLogger.Debug
{
    enum State
    {
        static
        func expectationWantsToSetState
        (
            expectation: Expectation,
            state: ExpectationState,
            inExpectation: Expectation
        )
        -> String
        {
            let inExpectationString: String =
            {
                if inExpectation === expectation
                {
                    return "<self>"
                }
                else
                {
                    return PrintLogger.stringForExpectation(inExpectation)
                }
            }()
            
            let string = PrintLogger.debugStringForComponents(
                [
                    "expectation:", PrintLogger.stringForExpectation(expectation),
                    "wantsToSetState:", String(describing: state),
                    "in:", inExpectationString
                ]
            )

            return string
        }
    }
}
