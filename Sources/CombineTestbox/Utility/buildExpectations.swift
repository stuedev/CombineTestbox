//
//  buildExpectations.swift
//  
//
//  Created by Stefan Ueter on 27.03.23.
//

import Foundation


public
func buildExpectations
(
    @ExpectationBuilder _ buildExpectations: () -> [Expectation]
)
-> [Expectation]
{
    let expectations = buildExpectations()
    
    return expectations
}
