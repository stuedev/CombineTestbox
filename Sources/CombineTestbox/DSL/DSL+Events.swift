//
//  DSL+Events.swift
//  
//
//  Created by Stefan Ueter on 27.03.23.
//

import Foundation


// MARK: combine

public
func >
(
    probe: String,
    typeWrapper: CombineEventTypeWrapper
)
-> Event
{
    .init(type: .combine(probe: probe,
                         type: typeWrapper.type))
}



// MARK: custom

public
func custom
(
    _ string: String
)
-> Event
{
    .customEvent(string: string)
}



// MARK: section

public
func sectionOpen
(
    _ title: String
)
-> Event
{
    .sectionOpenEvent(title: title)
}
