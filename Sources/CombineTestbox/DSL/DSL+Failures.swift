//
//  DSL+Failures.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation


// MARK: - keywords

public
enum Keyword
{
    case mismatching
    
    case unexpected
}


public
let mismatching = Keyword.mismatching


public
let unexpected = Keyword.unexpected



// MARK: - operator

precedencegroup EventPrecedenceGroup
{
    lowerThan: ComparisonPrecedence
    higherThan: StackDescriptionPrecedenceGroup
    associativity: left
}

infix operator ..: EventPrecedenceGroup


public
func ..
(
    keyword: Keyword,
    event: Event
)
-> Failure
{
    switch keyword
    {
        case .mismatching:
            
            return mismatching(event)

            
        case .unexpected:
            
            return unexpected(event)
    }
}



// MARK: mismatching

public
func mismatching
(
    _ event: Event
)
-> Failure
{
    return .mismatchingEvent(event)
}


public
func mismatching
(
    _ buildEvent: () -> Event
)
-> Failure
{
    let event = buildEvent()
    
    return mismatching(event)
}


// MARK: unexpected

public
func unexpected
(
    _ event: Event
)
-> Failure
{
    return .unexpectedEvent(event)
}


public
func unexpected
(
    _ buildEvent: () -> Event
)
-> Failure
{
    let event = buildEvent()
    
    return unexpected(event)
}



// MARK: unfulfilled

public
let unfulfilled = Failure.unfulfilled



// MARK: fulfilledInverse

public
let fulfilledInverse = Failure.fulfilledInverse
