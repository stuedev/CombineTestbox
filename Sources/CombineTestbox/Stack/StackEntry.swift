//
//  StackEntry.swift
//  
//
//  Created by Stefan Ueter on 27.03.23.
//

import Foundation


public
enum StackEntry
{
    case forEachIteration(title: String?, value: Any)

    case functionCall(name: String, context: String)
}


extension StackEntry
{
    var context: Any
    {
        switch self
        {
            case .forEachIteration(_, let value):
                
                return value
                
                
            case .functionCall(_, let context):
                
                return context
        }
    }
}


extension StackEntry
{
    var message: String
    {
        switch self
        {
            // forEach iteration
                
            case .forEachIteration(let title, let value):
                
                var string = "forEach"
                
                if let title
                {
                    string += "(\"\(title)\")"
                }
                
                let valueString: String
                
                switch value
                {
                    case let value as String:
                        
                        valueString = "\"\(value)\""
                        
                        
                    default:
                        
                        valueString = String(describing: value).truncate(maxLength: 30)
                }
                
                string += ": iteration(\(valueString))"
                
                return string
                
                
            // function
                
            case .functionCall(let name, let context):
                
                return "function(\"\(name)\"): context(\"\(context)\")"
        }
    }
}
