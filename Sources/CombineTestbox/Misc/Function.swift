//
//  Function.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation


public
struct Function
{
    let name: String
    
    let buildExpectations: () -> [Expectation]
    
    
    public
    init
    (
        _ name: String,
        @ExpectationBuilder buildExpectations: @escaping () -> [Expectation]
    )
    {
        self.name = name
        self.buildExpectations = buildExpectations
    }
}
