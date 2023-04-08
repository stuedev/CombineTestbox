//
//  EventTypeOptions.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


public
struct EventTypeOptions: OptionSet, Hashable
{
    public
    var rawValue: Int
    
    
    public
    init(rawValue: Int)
    {
        self.rawValue = rawValue
    }
    
    
    public
    static
    let receiveSubscriber = EventTypeOptions(rawValue: 1 << 0)

    public
    static
    let receiveSubscription = EventTypeOptions(rawValue: 1 << 1)
    
    public
    static
    let receiveValue = EventTypeOptions(rawValue: 1 << 2)
    
    public
    static
    let receiveCompletion = EventTypeOptions(rawValue: 1 << 3)
    
    public
    static
    let requestDemand = EventTypeOptions(rawValue: 1 << 4)

    public
    static
    let requestSyncDemand = EventTypeOptions(rawValue: 1 << 5)

    public
    static
    let cancel = EventTypeOptions(rawValue: 1 << 6)
    
    public
    static
    let custom = EventTypeOptions(rawValue: 1 << 7)
    
    public
    static
    let section = EventTypeOptions(rawValue: 1 << 8)
    
    
    public
    static
    let all: EventTypeOptions =
        [
            .receiveSubscriber,
            .receiveSubscription,
            .receiveValue,
            .receiveCompletion,
            .requestDemand,
            .requestSyncDemand,
            .cancel,
            .custom,
            .section
        ]

    public
    static
    let none: EventTypeOptions = []
}


extension EventTypeOptions: CustomStringConvertible
{
    public
    var description: String
    {
        let string: String
        
        if case .all = self
        {
            string = "all"
        }
        else
        {
            let components =
                stringMapping
                    .filter { self.contains($0.0) }
                    .map { $0.1 }
            
            string = components.joined(separator: ", ")
        }
        
        return string
    }
}


fileprivate
let stringMapping: [(EventTypeOptions, String)] =
    [
        (.receiveSubscriber,     "receiveSubscriber"),
        (.receiveSubscription,   "receiveSubscription"),
        (.receiveValue,          "receiveValue"),
        (.receiveCompletion,     "receiveCompletion"),
        (.requestDemand,         "requestDemand"),
        (.requestSyncDemand,     "requestSyncDemand"),
        (.cancel,                "cancel"),
        (.custom,                "custom"),
        (.section,               "section")
    ]
