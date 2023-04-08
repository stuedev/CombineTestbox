//
//  Failure.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


public
indirect
enum Failure
{
    case unfulfilled
    
    case fulfilledInverse
    
    case mismatchingEvent(Event)
    
    case unexpectedEvent(Event)
    
    case unmetExpectedFailure(Failure)
    
    case mismatchingExpectedFailure(Failure)
    
    case withStack(Failure, StackDescription)
}


extension Failure
{
    public
    func equals
    (
        _ otherFailure: Failure
    )
    -> Bool
    {
        switch (self, otherFailure)
        {
            case (.unfulfilled, .unfulfilled):

                return true


            case (.fulfilledInverse, .fulfilledInverse):

                return true


            case (.mismatchingEvent(let event1), .mismatchingEvent(let event2)):

                return event1.type.equals(event2.type)


            case (.unexpectedEvent(let event1), .unexpectedEvent(let event2)):

                return event1.type.equals(event2.type)


            case (.unmetExpectedFailure(let failure1), .unmetExpectedFailure(let failure2)):

                return failure1.equals(failure2)


            case (.mismatchingExpectedFailure(let failure1), .mismatchingExpectedFailure(let failure2)):

                return failure1.equals(failure2)


            default:

                return false
        }
    }
}


extension Failure: CustomStringConvertible
{
    public
    var description: String
    {
        switch self
        {
            case .unfulfilled:
                
                return "unfulfilled"
                
                
            case .fulfilledInverse:
                
                return "fulfilled inverse"
                
                
            case .mismatchingEvent(let event):
                
                return "mismatching event: " + event.description
                
                
            case .unexpectedEvent(let event):
                
                return "unexpected event: " + event.description
                
                
            case .unmetExpectedFailure(let failure):
                
                return "unmet expected failure: " + failure.description
                
                
            case .mismatchingExpectedFailure(let failure):
                
                return "mismatching expected failure: " + failure.description
                
                
            case .withStack(let failure, let stackDescription):
                
                return "[" + stackDescription.description + "] " + failure.description
        }
    }
}
