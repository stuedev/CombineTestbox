//
//  CustomExpectation.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation


public
class CustomExpectation: ExpectationBase
{
    let string: String
    
    
    init
    (
        string: String,
        sourceInfo: SourceInfo
    )
    {
        self.string = string
        
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
        guard case .custom(let string) = event.type
        else
        {
            return
        }
        
        
        if string == self.string
        {
            try self.fulfill()
         
            event.match(with: self)
        }
        else if context.strictEventTypes.contains(.custom)
        {
            /*
             if the string didn't match, but we're required to be strict about custom events, fail.
             */
            
            let failure = Failure.mismatchingEvent(event)
            
            try self.fail(with: failure,
                          context: context)
        }
    }
    
    
    public
    override
    var shortDescription: String
    {
        "custom(\"\(self.string)\")"
    }
}
