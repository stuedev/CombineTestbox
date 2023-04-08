//
//  GroupExpectation.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation


public
class GroupExpectation: NestingExpectationBase
{
    public
    static
    override
    var inversionBehaviour: InversionBehaviour { .resetUnfulfilledChildren }
    
    public
    static
    override
    var finalTreeStructure: FinalTreeConfig.Structures? { .group }

    
    
    let title: String?
    
    
    init
    (
        title: String?,
        expectations: [Expectation],
        sourceInfo: SourceInfo
    )
    {
        self.title = title
        
        super.init(expectations: expectations,
                   sourceInfo: sourceInfo)
    }
    
    
    public
    override
    var shortDescription: String
    {
        "group" + (self.title.flatMap { "(\"\($0)\")" } ?? "")
    }
}
