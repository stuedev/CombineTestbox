//
//  CombineExpectationType.swift
//  
//
//  Created by Stefan Ueter on 27.03.23.
//

import Foundation
import Combine


public
enum CombineExpectationType
{
    case receiveSubscriberSpecific(String)
    
    case receiveSubscriberUnspecific
    
    
    case receiveSubscriptionSpecific(String)
    
    case receiveSubscriptionUnspecific
    
    
    case receiveValueSpecific(Any)
    
    case receiveValueUnspecific
    
    case receiveValueTest((Any) -> Bool)
    
    
    case receiveCompletionSpecific(Subscribers.Completion<Swift.Error>)
    
    case receiveCompletionUnspecific
    
    case receiveCompletionTestError((Swift.Error) -> Bool)
    
    
    case requestDemandSpecific(Subscribers.Demand)
    
    case requestDemandUnspecific
    
    
    case requestSyncDemandSpecific(Subscribers.Demand)
    
    case requestSyncDemandUnspecific
    
    
    case cancel
}


extension CombineExpectationType
{
    // MARK: test
    
    func test
    (
        with type: CombineEventType
    )
    -> CombineTypeTestResult
    {
        let result: CombineTypeTestResult
        
        switch (self, type)
        {
            // receiveSubscriber
                
            case (.receiveSubscriberSpecific(let name1), .receiveSubscriber(let name2)):
                
                result = .fromBool(name1 == name2)
                
                
            case (.receiveSubscriberUnspecific, .receiveSubscriber):
                
                result = .matched

                
            // receiveSubscription
            
            case (.receiveSubscriptionSpecific(let name1), .receiveSubscription(let name2)):
                
                result = .fromBool(name1 == name2)
                
                
            case (.receiveSubscriptionUnspecific, .receiveSubscription):
                
                result = .matched
                
                
            // receiveValue
                
            case (.receiveValueSpecific(let value1), .receiveValue(let value2)):
                
                result = .fromBool(equateAny(value1, value2))
                
                
            case (.receiveValueUnspecific, .receiveValue):
                
                result = .matched

                
            case (.receiveValueTest(let test), .receiveValue(let value)):
                
                result = .fromBool(test(value))

                
            // receiveCompletion
                
            case (.receiveCompletionSpecific(let completion1), .receiveCompletion(let completion2)):
                
                result = .fromBool(equateCompletions(completion1, completion2))
                
                
            case (.receiveCompletionUnspecific, .receiveCompletion):
                
                result = .matched
                
                
            case (.receiveCompletionTestError(let test), .receiveCompletion(let failure)):
                
                switch failure
                {
                    case .finished:
                        
                        result = .mismatched
                        
                        
                    case .failure(let error):
                        
                        result = .fromBool(test(error))
                }
                
                
            // requestDemand
                
            case (.requestDemandSpecific(let demand1), .requestDemand(let demand2)):
                
                result = .fromBool(demand1 == demand2)
                
                
            case (.requestDemandUnspecific, .requestDemand):
                
                result = .matched

                
            // requestSyncDemand
                
            case (.requestSyncDemandSpecific(let demand1), .requestSyncDemand(let demand2)):
                
                result = .fromBool(demand1 == demand2)
                
                
            case (.requestSyncDemandUnspecific, .requestSyncDemand):
                
                result = .matched

            
            // cancel
                
            case (.cancel, .cancel):
                
                result = .matched
                
                
            default:
                
                result = .incompatibleTypes
        }
        
        return result
    }
}


extension CombineExpectationType: CustomStringConvertible
{
    // MARK: description
    
    public
    var description: String
    {
        switch self
        {
            // receiveSubscriber
                
            case .receiveSubscriberSpecific(let name):
                
                return "receiveSubscriber(\(name))"
                
                
            case .receiveSubscriberUnspecific:
                
                return "receiveSubscriber"
            
            
            // receiveSubscription
                
            case .receiveSubscriptionSpecific(let name):
                
                return "receiveSubscription(\(name))"
                
                
            case .receiveSubscriptionUnspecific:
                
                return "receiveSubscription"
                
                
            // receiveValue
                
            case .receiveValueSpecific(let value):
                
                return "receiveValue(\(value))"
                
                
            case .receiveValueUnspecific:
                
                return "receiveValue"
                
                
            case .receiveValueTest:
                
                return "receiveValue (test)"
                
            
            // receiveCompletion
                
            case .receiveCompletionSpecific(let completion):
                
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
                
                
            case .receiveCompletionUnspecific:
                
                return "receiveCompletion"
                
                
            case .receiveCompletionTestError:
                
                return "receiveCompletion (test)"
                
                
            // requestDemand
                
            case .requestDemandSpecific(let demand):
                
                return "requestDemand(\(demand))"
                
            
            case .requestDemandUnspecific:
                
                return "requestDemand"


            // requestSyncDemand
                
            case .requestSyncDemandSpecific(let demand):
                
                return "requestSyncDemand(\(demand))"
                
            
            case .requestSyncDemandUnspecific:
                
                return "requestSyncDemand"
                
                
            // cancel
                
            case .cancel:
                
                return "cancel"
        }
    }
}


// MARK: CombineTypeTestResult

enum CombineTypeTestResult
{
    case matched
    
    case mismatched

    case incompatibleTypes

    
    
    internal
    static
    func fromBool
    (
        _ bool: Bool
    )
    -> Self
    {
        switch bool
        {
            case true:       return .matched
            case false:      return .mismatched
        }
    }
}


