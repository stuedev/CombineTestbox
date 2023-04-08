//
//  StrictExpectation.swift
//  
//
//  Created by Stefan Ueter on 27.03.23.
//

import Foundation


public
class StrictExpectation: NestingExpectationBase
{
    public
    static
    override
    var inversionBehaviour: InversionBehaviour { .resetUnfulfilledChildren }

    public
    static
    override
    var finalTreeStructure: FinalTreeConfig.Structures? { .strict }

    
    
    let strictEventTypes: EventTypeOptions
    
    
    init
    (
        expectations: [Expectation],
        strictEventTypes: EventTypeOptions,
        sourceInfo: SourceInfo
    )
    {
        self.strictEventTypes = strictEventTypes
        
        super.init(expectations: expectations,
                   sourceInfo: sourceInfo)
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
        var strictContext = context
        strictContext.strictEventTypes.formUnion(self.strictEventTypes)

        if let currentExpectation
        {
            try currentExpectation.test(with: event,
                                        context: strictContext)
        }
        else
        {
            /*
             we use the original context here, because the strictness of this expectation doesn't apply to the successor.
             */
            
            try self.testSuccessor(with: event,
                                   context: context)
        }
        
        
        /*
         if the event wasn't matched in either one of our nested expectations or the successor, check if we need to fail.
         */
        
        if event.isIdle,
           event.type.isAffectedBy(strictContext.strictEventTypes)
        {
            let failureType = Failure.unexpectedEvent(event)
            
            /*
             if an unexpected event arrives, and there is still an expectation in line, the failure is applied to that expectation. otherwise on self (strict).
             */
            
            let failedExpectation = currentExpectation ?? self
            
            try failedExpectation.fail(with: failureType,
                                       context: strictContext)
        }
    }
    
    
    public
    override
    var shortDescription: String
    {
        "strict(\(self.strictEventTypes.description))"
    }
}
