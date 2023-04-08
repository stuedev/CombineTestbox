//
//  DSL+CombineEventTypes.swift
//  
//
//  Created by Stefan Ueter on 03.04.23.
//

import Foundation
import Combine


public
func receiveSubscriber
(
    _ name: String
)
-> CombineEventTypeWrapper
{
    .init(type: .receiveSubscriber(name))
}


public
func receiveSubscription
(
    _ name: String
)
-> CombineEventTypeWrapper
{
    .init(type: .receiveSubscription(name))
}


public
func receiveValue
(
    _ value: Any
)
-> CombineEventTypeWrapper
{
    .init(type: .receiveValue(value))
}


public
func receiveCompletion
(
    _ completion: Subscribers.Completion<Swift.Error>
)
-> CombineEventTypeWrapper
{
    .init(type: .receiveCompletion(completion))
}


public
func requestDemand
(
    _ demand: Subscribers.Demand
)
-> CombineEventTypeWrapper
{
    .init(type: .requestDemand(demand))
}


public
func requestSyncDemand
(
    _ demand: Subscribers.Demand
)
-> CombineEventTypeWrapper
{
    .init(type: .requestSyncDemand(demand))
}


public
func cancel()
-> CombineEventTypeWrapper
{
    .init(type: .cancel)
}



// MARK: - CombineEventTypeWrapper

public
struct CombineEventTypeWrapper
{
    let type: CombineEventType
    
    
    public
    init
    (
        type: CombineEventType
    )
    {
        self.type = type
    }
}
