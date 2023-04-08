//
//  equateAny.swift
//  
//
//  Created by Stefan Ueter on 27.03.23.
//

import Foundation


public
func equateAny
(
    _ lhs: Any,
    _ rhs: Any
)
-> Bool
{
    if let lhs = lhs as? any Equatable
    {
        return innerEquateAny(lhs, rhs)
    }
    else
    {
        return false
    }
}


fileprivate
func innerEquateAny<T: Equatable>
(
    _ lhs: T,
    _ rhs: Any
)
-> Bool
{
    if let rhs = rhs as? T
    {
        return lhs == rhs
    }
    else
    {
        return false
    }
}
