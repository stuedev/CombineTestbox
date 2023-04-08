//
//  ConsoleLogger.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


public
class ConsoleLogger: PrintLogger
{
    public
    static
    override
    func printString
    (
        _ string: String
    )
    {
        // print to console
        
        Swift.print(string)
    }
}
