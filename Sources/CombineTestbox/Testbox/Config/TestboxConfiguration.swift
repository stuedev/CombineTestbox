//
//  TestboxConfiguration.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation
import XCTest


public
class TestboxConfiguration
{
    public
    var reportedEvents: EventTypeOptions = .all
    
    public
    var debug: DebugConfig = .init()
    {
        didSet
        {
            /*
             config Logger depending on DebugConfig
             */
            
            self.logger.config = self.debug.loggerConfig
        }
    }
    
    public
    var finalTreeConfig: FinalTreeConfig = .init()
    
    public
    var logger: Logger = ConsoleLogger()
    
    public
    var recorder: ((XCTIssue) -> Void)? = nil
    
    public
    var expectUnmetFailure: Bool = false
}


extension TestboxConfiguration: NSCopying
{
    public
    func copy
    (
        with zone: NSZone? = nil
    )
    -> Any
    {
        let copy = TestboxConfiguration()
        copy.reportedEvents = self.reportedEvents
        copy.debug = self.debug
        copy.finalTreeConfig = self.finalTreeConfig
        copy.logger = self.logger
        copy.recorder = self.recorder
        copy.expectUnmetFailure = self.expectUnmetFailure
        
        return copy
    }
}
