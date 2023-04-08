//
//  DebugConfig.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


public
struct DebugConfig
{
    public
    var test: Bool = false
    
    public
    var state: Bool = false
    
    public
    var successorTree: Bool = false
    
    public
    var finalTree: Bool = true
}


extension DebugConfig
{
    var loggerConfig: LoggerConfig
    {
        .init(
            test:
                self.test == true,
            wantsToSetState:
                self.state == true,
            finalize:
                self.test == true || self.state == true
        )
    }
}
