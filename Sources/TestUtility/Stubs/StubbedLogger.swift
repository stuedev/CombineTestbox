//
//  StubbedLogger.swift
//  
//
//  Created by Stefan Ueter on 30.03.23.
//

import Foundation
import CombineTestbox


public
class StubbedLogger: Logger
{
    public
    override
    init()
    {
        super.init()
    }
    
    
    public
    override
    func didLog(_ event: LoggerEvent)
    {
    }
}
