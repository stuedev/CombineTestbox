//
//  TestOperator.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation
import Combine


public
struct TestOperator<Output, Failure: Swift.Error>: Publisher
{
    let upstream: any Publisher<Output, Failure>
    
    let testbox: any TestboxProtocol
    
    let probe: String
    
    
    
    init
    (
        upstream: any Publisher<Output, Failure>,
        testbox: any TestboxProtocol,
        probe: String
    )
    {
        self.upstream = upstream
        self.testbox = testbox
        self.probe = probe
    }
    
    
    
    // MARK: receive subscriber
    
    public
    func receive<S>
    (
        subscriber: S
    )
    where
        S : Subscriber,
        Failure == S.Failure,
        Output == S.Input
    {
        let event = Event.combineEvent(probe: self.probe,
                                       type: .receiveSubscriber(String(describing: subscriber)))
        
        testbox.reportEvent(event)
        
        _ = Inner(upstream: self.upstream,
                  subscriber: subscriber,
                  testbox: self.testbox,
                  probe: self.probe)
    }
}


extension TestOperator
{
    class Inner: Subscription, Subscriber
    {
        public
        typealias Input = Output
        
        
        let subscriber: any Subscriber<Output, Failure>

        let testbox: any TestboxProtocol

        let probe: String

        var upstreamSubscription: Subscription?
        
        
        
        init
        (
            upstream: any Publisher<Output, Failure>,
            subscriber: any Subscriber<Output, Failure>,
            testbox: any TestboxProtocol,
            probe: String
        )
        {
            self.subscriber = subscriber
            self.testbox = testbox
            self.probe = probe

            upstream.receive(subscriber: self)
        }
        
        
        
        // MARK: receive subscription
        
        public
        func receive
        (
            subscription: Subscription
        )
        {
            let event = Event.combineEvent(probe: self.probe,
                                           type: .receiveSubscription(String(describing: subscription)))
            
            testbox.reportEvent(event)

            self.upstreamSubscription = subscription
            
            self.subscriber.receive(subscription: self)
        }
        
        
        
        // MARK: request demand
        
        public
        func request
        (
            _ demand: Subscribers.Demand
        )
        {
            let event = Event.combineEvent(probe: self.probe,
                                           type: .requestDemand(demand))
            
            testbox.reportEvent(event)

            self.upstreamSubscription?.request(demand)
        }
        
        
        
        // MARK: receive value
        
        public
        func receive
        (
            _ input: Input
        )
        -> Subscribers.Demand
        {
            // value
            
            let valueEvent = Event.combineEvent(probe: self.probe,
                                                type: .receiveValue(input))
            
            testbox.reportEvent(valueEvent)
            
            
            // demand
            
            let syncDemand = self.subscriber.receive(input)
            
            let demandEvent = Event.combineEvent(probe: self.probe,
                                                 type: .requestSyncDemand(syncDemand))
            
            testbox.reportEvent(demandEvent)

            return syncDemand
        }
        
        
        
        // MARK: receive completion
        
        public
        func receive
        (
            completion: Subscribers.Completion<Failure>
        )
        {
            let downcastCompletion: Subscribers.Completion<Swift.Error>
            
            switch completion
            {
                case .finished:
                    
                    downcastCompletion = .finished
                    
                    
                case .failure(let error):
                    
                    downcastCompletion = .failure(error)
            }
            
            let event = Event.combineEvent(probe: self.probe,
                                           type: .receiveCompletion(downcastCompletion))
            
            testbox.reportEvent(event)

            return self.subscriber.receive(completion: completion)
        }
        
        
        
        // MARK: cancel
        
        public
        func cancel()
        {
            let event = Event.combineEvent(probe: self.probe,
                                           type: .cancel)
            
            testbox.reportEvent(event)

            self.upstreamSubscription?.cancel()
        }
    }
}



// MARK: - operator method

extension Publisher
{
    public
    func test
    (
        _ testbox: any TestboxProtocol,
        probe: String
    )
    -> TestOperator<Output, Failure>
    {
        .init(upstream: self,
              testbox: testbox,
              probe: probe)
    }
}
