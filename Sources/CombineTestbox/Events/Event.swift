//
//  Event.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation
import StateMachine


public
class Event
{
    let type: EventType
    
    @StateMachine
    var state: EventState = .idle

    var logger: Logger!
    
    
    public
    init
    (
        type: EventType
    )
    {
        self.type = type
    }
}


extension Event
{
    func match
    (
        with expectation: Expectation
    )
    {
        self.state = .matched(expectation)
        
        self.logger.log(.event(.matched(event: self,
                                        inExpectation: expectation)))
    }
    
    
    func discard
    (
        in expectation: Expectation
    )
    {
        self.state = .discarded(expectation)
        
        self.logger.log(.event(.discarded(event: self,
                                          inExpectation: expectation)))
    }

    
    var isIdle: Bool
    {
        if case .idle = self.state
        {
            return true
        }
        else
        {
            return false
        }
    }

    
    var isMatched: Bool
    {
        if case .matched = self.state
        {
            return true
        }
        else
        {
            return false
        }
    }
}


extension Event: CustomStringConvertible
{
    public
    var description: String
    {
        self.state.icon + " " + self.shortDescription
    }
}


extension Event
{
    public
    var shortDescription: String
    {
        self.type.description
    }
}


extension Event
{
    static
    func combineEvent
    (
        probe: String,
        type: CombineEventType
    )
    -> Event
    {
        .init(type: .combine(probe: probe,
                             type: type))
    }
    
    
    static
    func customEvent
    (
        string: String
    )
    -> Event
    {
        .init(type: .custom(string: string))
    }
    
    
    static
    func sectionOpenEvent
    (
        title: String
    )
    -> Event
    {
        .init(type: .sectionOpen(title: title))
    }
    
    
    static
    func sectionCloseEvent
    (
        title: String
    )
    -> Event
    {
        .init(type: .sectionClose(title: title))
    }
}
