//
//  DummyError.swift
//  
//
//  Created by Stefan Ueter on 02.04.23.
//

import Foundation


struct DummyError: LocalizedError, Equatable
{
    let message: String
    
    
    init
    (
        _ message: String
    )
    {
        self.message = message
    }
    
    
    var errorDescription: String?
    {
        self.message
    }
}


struct DummyError2: LocalizedError, Equatable
{
    let message: String
    
    
    init
    (
        _ message: String
    )
    {
        self.message = message
    }
    
    
    var errorDescription: String?
    {
        self.message
    }
}
