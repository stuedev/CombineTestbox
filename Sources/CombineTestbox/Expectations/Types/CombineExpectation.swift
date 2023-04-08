//
//  CombineExpectation.swift
//  
//
//  Created by Stefan Ueter on 27.03.23.
//

import Foundation


public
class CombineExpectation: ExpectationBase
{
    let probe: String
    
    let type: CombineExpectationType

    
    init
    (
        probe: String,
        type: CombineExpectationType,
        sourceInfo: SourceInfo
    )
    {
        self.probe = probe
        self.type = type
        
        super.init(sourceInfo: sourceInfo)
    }
    
    
    public
    override
    func performTest
    (
        with event: Event,
        context: TestContext
    )
    throws
    {
        guard case .combine(let probe,
                            let eventType) = event.type
        else
        {
            return
        }
        
        /*
         ignore events for different probes
         */
        
        guard probe == self.probe
        else
        {
            return
        }
        
        
        let testResult = self.type.test(with: eventType)
        
        
        /*
         if the event type cannot be tested with our expectation type, ignore.
         */
        
        if case .incompatibleTypes = testResult
        {
            return
        }
        
        
        let isAffectedByStrictness = eventType.isAffectedBy(context.strictEventTypes)

        switch (testResult, isAffectedByStrictness)
        {
            case (.matched, _):
                
                event.match(with: self)
                
                try self.fulfill()
                
                
            case (.mismatched, true):
                
                /*
                 if the event mismatched, but was required to by strictness, we fail.
                 */
                
                let failure =  Failure.mismatchingEvent(event)
                
                try self.fail(with: failure,
                              context: context)
                
                
            default:
                
                break
        }
    }
    
    
    public
    override
    var shortDescription: String
    {
        self.probe + " > " + self.type.description
    }
}
