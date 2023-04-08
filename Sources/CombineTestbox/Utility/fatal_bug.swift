//
//  fatal_bug.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


public
func fatal_bug
(
    _ info: String
)
-> Never
{
    let message =
        """
        This is a bug and is not supposed to happen. If you see this, please report your Stack Trace. Thank you!
        
        Info: \(info)
        """
    
    fatalError(message)
}
