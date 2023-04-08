//
//  PrintLogger+Events.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


extension PrintLogger
{
    enum Events
    {
        static
        func eventMatched
        (
            event: Event,
            expectation: Expectation
        )
        -> String
        {
            stringFor(event: event,
                      expectation: expectation,
                      symbol: Constants.Icons.matched)
        }
        
        
        static
        func eventDiscarded
        (
            event: Event,
            expectation: Expectation
        )
        -> String
        {
            stringFor(event: event,
                      expectation: expectation,
                      symbol: Constants.Icons.discarded)
        }

        
        static
        func eventFailed
        (
            event: Event,
            expectation: Expectation,
            failure: Failure,
            isRedeemed: Bool
        )
        -> String
        {
            var string = stringFor(event: event,
                                   expectation: expectation,
                                   symbol: Constants.Icons.failed)
            
            let symbol: String
            
            switch isRedeemed
            {
                case false:     symbol = Constants.Icons.failed
                case true:      symbol = Constants.Icons.redeemed
            }
            
            string += ("\t" * 2) + " " + symbol + " " + failure.description
            
            return string
        }


        static
        fileprivate
        func stringFor
        (
            event: Event,
            expectation: Expectation,
            symbol: String
        )
        -> String
        {
            let eventPrefix =
                symbol
                + " "
                + "event:"
            
            let string = PrintLogger.stringForComponents(
                [
                    eventPrefix, event.shortDescription,
                    "in:", PrintLogger.stringForExpectation(expectation)
                ]
            )

            return string
        }
    }
}
