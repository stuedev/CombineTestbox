//
//  DSL+StackDescription.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation


/*
 Example:
 
 forEach([1,2,3])
 {
     forEach(["a","b","c"])
     {
        "sub" > receiveValue(1)    !! unfulfilled ~~ /1/"a"
     }
 }
 
 The failure *unfulfilled* is expected for the stack 1/"a", means the iteration 1 in the outer loop and "a" in the inner loop.
 */


precedencegroup StackDescriptionPrecedenceGroup
{
    lowerThan: MultiplicationPrecedence
    higherThan: TernaryPrecedence
    associativity: left
}

infix operator ~~: StackDescriptionPrecedenceGroup


public
func ~~
(
    _ failure: Failure,
    _ stackDescription: StackDescription
)
-> Failure
{
    .withStack(failure,
               stackDescription)
}


prefix operator /


public
prefix func /
(
    _ context: Any
)
-> StackDescription
{
    return .init(parent: nil,
                 context: context)
}


public
func /
(
    _ parent: StackDescription,
    _ context: Any
)
-> StackDescription
{
    .init(parent: parent,
          context: context)
}


public
func context
(
    _ context: Any
)
-> StackDescription
{
    .init(parent: nil,
          context: context)
}
