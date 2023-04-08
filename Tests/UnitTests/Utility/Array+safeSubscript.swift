//
//  Array+safeSubscript.swift
//  
//
//  Created by Stefan Ueter on 02.04.23.
//

import Foundation


extension Array
{
    subscript
    (
        safe index: Int
    )
    -> Element?
    {
        guard index < self.count
        else
        {
            return nil
        }
        
        return self[index]
    }
}
