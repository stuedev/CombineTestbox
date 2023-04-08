//
//  NestingExpectation.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


public
protocol NestingExpectation: Expectation
{
    var expectations: [Expectation] { get }
    
    
    func buildInverse()
}
