//
//  FailureError.swift
//  
//
//  Created by Stefan Ueter on 27.03.23.
//

import Foundation


struct FailureError: Error
{
    let inExpectation: Expectation
    
    let failure: Failure
    
    let isRedeemed: Bool
}
