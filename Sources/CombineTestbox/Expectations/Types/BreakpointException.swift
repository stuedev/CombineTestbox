//
//  BreakpointExpectation.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation


public
class BreakpointExpectation: ExpectationBase
{
    let expectation: Expectation
    
    
    init
    (
        expectation: Expectation,
        sourceInfo: SourceInfo
    )
    {
        self.expectation = expectation
        
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
        /*
         interupt code execution before testing the event.
         */
        
        raise(SIGINT)
        
        try self.expectation.test(with: event,
                                  context: context)
        
        /*
         if inner expectation was fulfilled, fulfill us as well.
         */
        
        if self.expectation.isFulfilled
        {
            try self.fulfill()
        }
    }
    
    
    public
    override
    var shortDescription: String
    {
        "breakpoint"
    }
}
