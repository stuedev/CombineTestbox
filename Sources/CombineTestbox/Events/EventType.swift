//
//  EventType.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


public
enum EventType
{
    case combine(probe: String, type: CombineEventType)
    
    case custom(string: String)
    
    case sectionOpen(title: String)
    
    case sectionClose(title: String)
}


extension EventType
{
    func equals
    (
        _ otherType: EventType
    )
    -> Bool
    {
        switch (self, otherType)
        {
            case (.combine(let probe1, let type1), .combine(let probe2, let type2)):
                
                return
                    probe1 == probe2
                    && type1.equals(type2)
                
                
            case (.custom(let string1), .custom(let string2)):
                
                return string1 == string2
                
                
            case (.sectionOpen(let title1), .sectionOpen(let title2)):
                
                return title1 == title2
                
                
            case (.sectionClose(let title1), .sectionClose(let title2)):
                
                return title1 == title2
                
                
            default:
                
                return false
        }
    }
    
    
    func isAffectedBy
    (
        _ types: EventTypeOptions
    )
    -> Bool
    {
        switch self
        {
            case .combine(_, let type):
                
                return type.isAffectedBy(types)
                
                
            case .custom:
                
                return types.contains(.custom)
                
                
            case .sectionOpen, .sectionClose:
                
                return types.contains(.section)
        }
    }
}


extension EventType: CustomStringConvertible
{
    public
    var description: String
    {
        switch self
        {
            case .combine(let probe, let type):
                
                return "\""  + probe + "\" > " +  type.description
                
                
            case .custom(let string):
                
                return "custom: " + string
                
                
            case .sectionOpen(let title):
                
                return "sectionOpen: " + title
                
                
            case .sectionClose(let title):
                
                return "sectionClose: " + title
        }
    }
}
