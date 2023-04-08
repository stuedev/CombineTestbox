//
//  IgnoreExpectation.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation


public
class IgnoreExpectation: ExpectationBase
{
    public
    override
    func performTest
    (
        with event: Event,
        context: TestContext
    )
    throws
    {
        /*
         certain events should not be handled by Ignore
         */
        
        guard shouldHandle(eventType: event.type)
        else
        {
            return
        }
        
        /*
         successor must be tested without failing, because otherwise value meant to be ignored could fail in a strict successor.
         */
        
        try context.withoutFailing
        {
            context in
            
            try self.testSuccessor(with: event,
                                   context: context)
        }

        /*
         if the event did not match or fail inside the successor, we discard it.
         */
        
        if event.isIdle
        {
            event.discard(in: self)
        }
    }
    
    
    func shouldHandle
    (
        eventType: EventType
    )
    -> Bool
    {
        switch eventType
        {
            /*
             section events are not handled in *Ignore*
             */
                
            case
                    .sectionOpen,
                    .sectionClose:
                
                return false
                
                
            default:
                
                return true
        }
    }

    
    public
    override
    func desiredFinalState() -> ExpectationState
    {
        switch self.isInverse
        {
            case false:
                
                return .fulfilled
                
                
            case true:
                
                return .idle
        }
    }

    
    public
    override
    var shortDescription: String
    {
        "ignore"
    }
}
