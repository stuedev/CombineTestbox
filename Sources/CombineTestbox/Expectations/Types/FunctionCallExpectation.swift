//
//  FunctionCallExpectation.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation


public
class FunctionCallExpectation: NestingExpectationBase
{
    public
    static
    override
    var inversionBehaviour: InversionBehaviour { .inherit }

    public
    static
    override
    var finalTreeStructure: FinalTreeConfig.Structures? { .functionCall }
    
    
    
    let function: Function
    
    let context: String
    
    
    init
    (
        function: Function,
        context: String,
        sourceInfo: SourceInfo
    )
    {
        self.function = function
        self.context = context
        
        let expectations = function.buildExpectations()
        
        super.init(expectations: expectations,
                   sourceInfo: sourceInfo)
    }
    
    
    public
    override
    func postInit()
    {
        let stackEntry = StackEntry.functionCall(name: self.function.name,
                                                 context: self.context)
        
        self.stack.append(stackEntry)
        
        super.postInit()
    }

    
    public
    override
    var shortDescription: String
    {
        "functionCall(\"\(function.name)\", context: \"\(context)\")"
    }
}
