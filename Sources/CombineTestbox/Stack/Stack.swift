//
//  Stack.swift
//  
//
//  Created by Stefan Ueter on 27.03.23.
//

import Foundation


public
struct Stack
{
    var entries: [StackEntry] = []
    
    var hasEntries: Bool
    {
        entries.count > 0
    }
    
    
    mutating
    func append
    (
        _ entry: StackEntry
    )
    {
        self.entries.append(entry)
    }

    
    func test
    (
        with stackDescription: StackDescription
    )
    -> Bool
    {
        let parentList =
            recursiveObjects(on: stackDescription,
                             keyPath: \.parent)
                .reversed()
        
        guard parentList.count == self.entries.count
        else
        {
            return false
        }
        
        let result =
            zip(parentList, self.entries)
                .allSatisfy
                {
                    stackDescription, stackEntry in
                    
                    equateAny(stackDescription.context, stackEntry.context)
                }
        
        return result
    }

    
    func toString() -> String
    {
        (
            [ "root" ]
            + self.entries
                .map { $0.message }
        )
            .map { Constants.Icons.stackEntryPrefix + " " + $0 }
            .joined(separator: "\n")
    }
    
    
    var shortDescription: String
    {
        guard self.hasEntries
        else
        {
            return "<no entries>"
        }
        
        return
            self.entries
                .map { String(describing: $0.context) }
                .joined(separator: "/")
    }
}
