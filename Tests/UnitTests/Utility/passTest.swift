//
//  passTest.swift
//  
//
//  Created by Stefan Ueter on 02.04.23.
//

import Foundation
import Nimble


func passTest<T>
(
    _ test: @escaping (T) -> Bool
)
-> Predicate<T>
{
    .define("pass test")
    {
        expression, message in
        
        if let actual = try expression.evaluate(),
           test(actual) == true
        {
            return .init(status: .matches, message: message)
        }
        else
        {
            return .init(status: .doesNotMatch, message: .fail("did not pass"))
        }
    }
}
