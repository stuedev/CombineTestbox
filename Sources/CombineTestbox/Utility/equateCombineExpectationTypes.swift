//
//  equateCombineExpectationTypes.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation


public
func equateCombineExpectationTypes
(
    _ type1: CombineExpectationType,
    _ type2: CombineExpectationType
)
-> Bool
{
    switch (type1, type2)
    {
        // receiveSubscriber
            
        case (.receiveSubscriberSpecific(let name1), .receiveSubscriberSpecific(let name2)):
            
            return name1 == name2
            
            
        case (.receiveSubscriberUnspecific, .receiveSubscriberUnspecific):
            
            return true
            
            
        // receiveSubscription
            
        case (.receiveSubscriptionSpecific(let name1), .receiveSubscriptionSpecific(let name2)):
            
            return name1 == name2
            
            
        case (.receiveSubscriptionUnspecific, .receiveSubscriptionUnspecific):
            
            return true
            
            
        // receiveValue
            
        case (.receiveValueSpecific(let lhs), .receiveValueSpecific(let rhs)):
            
            return equateAny(lhs, rhs)
            
            
        case (.receiveValueUnspecific, .receiveValueUnspecific):
            
            return true
            
            
        // receiveCompletion
            
        case (.receiveCompletionSpecific(let lhs), .receiveCompletionSpecific(let rhs)):
            
            return equateCompletions(lhs, rhs)
            
            
        case (.receiveCompletionUnspecific, .receiveCompletionUnspecific):
            
            return true
            
            
        // requestDemand
            
        case (.requestDemandSpecific(let demand1), .requestDemandSpecific(let demand2)):
            
            return demand1 == demand2
            
            
        case (.requestDemandUnspecific, .requestDemandUnspecific):
            
            return true
            
            
        // requestSyncDemand
            
        case (.requestSyncDemandSpecific(let demand1), .requestSyncDemandSpecific(let demand2)):
            
            return demand1 == demand2
            
            
        case (.requestSyncDemandUnspecific, .requestSyncDemandUnspecific):
            
            return true
        
            
        // cancel
            
        case (.cancel, .cancel):
            
            return true
            
            
        default:
            
            return false
    }
}
