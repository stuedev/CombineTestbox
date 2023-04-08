//
//  String+multiply.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


public
func *
(
    string: String,
    count: Int
)
-> String
{
    Array(repeating: 0, count: count)
        .reduce("")
        {
            accumulated, _ in
            
            accumulated + string
        }
}
