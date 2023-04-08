//
//  StackDescription.swift
//  
//
//  Created by Stefan Ueter on 27.03.23.
//

import Foundation


public
class StackDescription
{
    public
    let parent: StackDescription?
    
    public
    let context: Any
    
    
    init
    (
        parent: StackDescription?,
        context: Any
    )
    {
        self.parent = parent
        self.context = context
    }
}


extension StackDescription: CustomStringConvertible
{
    public
    var description: String
    {
        if let parent
        {
            return parent.description + "/" + String(describing: context)
        }
        else
        {
            return String(describing: context)
        }
    }
}
