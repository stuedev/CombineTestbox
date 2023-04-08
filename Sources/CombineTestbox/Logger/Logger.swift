//
//  Logger.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


/**
 abstract class
 */
open
class Logger
{
    var config: LoggerConfig = .init(test: false,
                                     wantsToSetState: false,
                                     finalize: false)
    
    var events: [LoggerEvent] = []
    
    
    
    public
    init() {}
    
    
    
    func log
    (
        _ event: LoggerEvent
    )
    {
        if self.shouldLog(event)
        {
            self.events.append(event)

            self.didLog(event)
        }
    }

    
    func shouldLog
    (
        _ event: LoggerEvent
    )
    -> Bool
    {
        switch event
        {
            /*
             "event" and "failure" log events are always logged
             */
                
            case .event, .failure:
                
                return true
                

            /*
             "debug" log events are logged depending on the LoggerConfig
             */
                
            case .debug(let event):
                
                switch event
                {
                    case .test, .testSuccessor:
                        
                        return self.config.test == true
                        
                        
                    case .expectationWantsToSetState:
                        
                        return self.config.wantsToSetState == true
                        
                        
                    case .finalize:
                        
                        return self.config.finalize == true
                }
        }
    }
    
    
    open
    func didLog
    (
        _ event: LoggerEvent
    )
    {
        fatal_bug("abstract")
    }
}
