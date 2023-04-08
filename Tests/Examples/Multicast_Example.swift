//
//  Multicast_Example.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation
import CombineTestbox
import XCTest
import Combine


class Multicast_Example: XCTestCase
{
    func test()
    {
        let testbox =
            Testbox
            {
                // MARK: functions
                
                let subscribe =
                {
                    (probe: String) in
                    
                    Function("subscribe")
                    {
                        probe > receiveSubscriber()
                        probe > receiveSubscription()
                        probe > requestDemand(.unlimited)
                    }
                }
                
                
                let sendValue =
                {
                    (upstream: String, subs: [String], value: Int) in
                    
                    Function("sendValue")
                    {
                        upstream > receiveValue(value)
                        
                        unordered
                        {
                            for sub in subs
                            {
                                group
                                {
                                    sub > receiveValue(value)
                                    sub > requestSyncDemand(.none)
                                }
                            }
                        }
                        
                        upstream > requestSyncDemand(.none)
                    }
                }
                
                
                let sendCompletion =
                {
                    (upstream: String, subs: [String], completion: Subscribers.Completion) in
                    
                    Function("sendCompletion")
                    {
                        upstream > receiveCompletion(completion)
                        
                        unordered
                        {
                            for sub in subs
                            {
                                sub > receiveCompletion(completion)
                            }
                        }
                    }
                }
                
                
                
                // MARK: expectations
                
                strict(.all)
                {
                    call(subscribe("sub1"), "sub1")

                    call(subscribe("upstream"), "upstream")

                    section("first part")
                    {
                        call(sendValue("upstream", ["sub1"], 1), "sub1")
                    }
                    
                    call(subscribe("sub2"), "sub2")

                    section("second part")
                    {
                        forEach([2,3])
                        {
                            value in
                            
                            call(sendValue("upstream", ["sub1", "sub2"], value), "both subs")
                        }
                        
                        call(sendCompletion("upstream", ["sub1", "sub2"], .finished), "both subs")
                    }
                }
            }
        
        testbox.config.finalTreeConfig.visibleStructures = .all
        
        let subject = PassthroughSubject<Int, Never>()
        
        let op =
            subject
                .test(testbox, probe: "upstream")
                .multicast(subject: PassthroughSubject<Int, Never>())
                .autoconnect()
                .eraseToAnyPublisher()
    
        let sub1 =
            op
                .testSink(testbox, probe: "sub1")
        
        testbox.section("first part")
        {
            subject.send(1)
        }
        
        let sub2 =
            op
                .testSink(testbox, probe: "sub2")

        testbox.section("second part")
        {
            subject.send(2)
            subject.send(3)
            subject.send(completion: .finished)
        }
        
        testbox.wait(timeout: 0.01)
    }
}
