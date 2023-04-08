//
//  Stubs.swift
//  
//
//  Created by Stefan Ueter on 02.04.23.
//

import Foundation
import Combine


class Publisher_Stub: Publisher, CustomStringConvertible
{
    typealias Output = Int
    
    typealias Failure = Error

    
    func receive<S>
    (
        subscriber: S
    )
    where
        S : Subscriber,
        Failure == S.Failure,
        Int == S.Input
    {
    }

    
    var description: String
    {
        "Publisher_Stub"
    }
}


class Subscriber_Stub: Subscriber, CustomStringConvertible
{
    typealias Input = Int
    
    typealias Failure = Error

    
    static let syncDemand: Subscribers.Demand = .max(3)

    
    func receive
    (
        subscription: Subscription
    )
    {
    }

    
    func receive
    (
        _ input: Input
    )
    -> Subscribers.Demand
    {
        Self.syncDemand
    }
    
    
    func receive
    (
        completion: Subscribers.Completion<Failure>
    )
    {
    }
    
    
    var description: String
    {
        "Subscriber_Stub"
    }
}


class Subscription_Stub: Subscription, CustomStringConvertible
{
    func request
    (
        _ demand: Subscribers.Demand
    )
    {
    }

    
    func cancel() {}
    
    
    var description: String
    {
        "Subscription_Stub"
    }
}
