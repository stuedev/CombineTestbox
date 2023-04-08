//
//  TestContext.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


public
struct TestContext
{
    var strictEventTypes: EventTypeOptions = .none
    
    var canFail: Bool = true
}


extension TestContext
{
    @discardableResult
    func withoutFailing<T>
    (
        body: (Self) throws -> T
    )
    rethrows
    -> T
    {
        var context = self
        context.canFail = false
        
        return try body(context)
    }
}
