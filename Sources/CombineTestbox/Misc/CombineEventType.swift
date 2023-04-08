//
//  CombineEventType.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation
import Combine


public
enum CombineEventType: CustomStringConvertible
{
    case receiveSubscriber(String)
    
    case receiveSubscription(String)
    
    case receiveValue(Any)
    
    case receiveCompletion(Subscribers.Completion<Swift.Error>)
    
    case requestDemand(Subscribers.Demand)
    
    case requestSyncDemand(Subscribers.Demand)
    
    case cancel
}


extension CombineEventType
{
    // MARK: equals
    
    public
    func equals
    (
        _ other: CombineEventType
    )
    -> Bool
    {
        switch (self, other)
        {
            case (.receiveSubscriber(let name1), .receiveSubscriber(let name2)):
                
                return name1 == name2
                
                
            case (.receiveSubscription(let name1), .receiveSubscription(let name2)):
                
                return name1 == name2
                
                
            case (.receiveValue(let value1), .receiveValue(let value2)):
                
                return equateAny(value1, value2)
                
                
            case (.receiveCompletion(let completion1), .receiveCompletion(let completion2)):
                
                return equateCompletions(completion1, completion2)
                
                
            case (.requestDemand(let demand1), .requestDemand(let demand2)):
                
                return demand1 == demand2


            case (.requestSyncDemand(let demand1), .requestSyncDemand(let demand2)):
                
                return demand1 == demand2

                
            case (.cancel, .cancel):
                
                return true
                
                
            default:
                
                return false
        }
    }
    
    
    // MARK: isAffectedBy
    
    public
    func isAffectedBy
    (
        _ types: EventTypeOptions
    )
    -> Bool
    {
        switch self
        {
            case .receiveSubscriber:
                
                return types.contains(.receiveSubscriber)
                
                
            case .receiveSubscription:
                
                return types.contains(.receiveSubscription)
                
                
            case .receiveValue:
                
                return types.contains(.receiveValue)
                
                
            case .receiveCompletion:
                
                return types.contains(.receiveCompletion)
                
                
            case .requestDemand:
                
                return types.contains(.requestDemand)


            case .requestSyncDemand:
                
                return types.contains(.requestSyncDemand)
                
                
            case .cancel:
                
                return types.contains(.cancel)
        }
    }

    
    // MARK: description
    
    public
    var description: String
    {
        switch self
        {
            case .receiveSubscriber(let name):
                
                return "receiveSubscriber(\(name))"


            case .receiveSubscription(let name):
                
                return "receiveSubscription(\(name))"


            case .receiveValue(let value):
                
                return "receiveValue(\(value))"


            case .receiveCompletion(let completion):
                
                let completionString: String
                
                switch completion
                {
                    case .finished:
                        
                        completionString = ".finished"
                        
                        
                    case .failure(let error):
                        
                        let errorString = String(describing: type(of: error))
                        completionString = ".failure(\(errorString))"
                }
                
                return "receiveCompletion(\(completionString))"


            case .requestDemand(let demand):
                
                return "requestDemand(\(demand))"


            case .requestSyncDemand(let demand):
                
                return "requestSynchronousDemand(\(demand))"


            case .cancel:
                
                return "cancel"
        }
    }
}
