//
//  Testbox_Mock.swift
//  
//
//  Created by Stefan Ueter on 02.04.23.
//

import Foundation
import CombineTestbox


class Testbox_Mock: TestboxProtocol
{
    var events: [Event] = []
    
    
    func reportEvent
    (
        _ event: Event
    )
    {
        self.events.append(event)
    }
}
