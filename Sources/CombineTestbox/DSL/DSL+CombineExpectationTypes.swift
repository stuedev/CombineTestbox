//
//  DSL+CombineExpectationTypes.swift
//  
//
//  Created by Stefan Ueter on 27.03.23.
//

import Foundation
import Combine


// MARK: receiveSubscriber

public
func receiveSubscriber
(
    _ name: String,
    file: StaticString = #file,
    line: UInt = #line
)
-> CombineExpectationTypeWrapper
{
    .init(type: .receiveSubscriberSpecific(name),
          file: file,
          line: line)
}


public
func receiveSubscriber
(
    file: StaticString = #file,
    line: UInt = #line
)
-> CombineExpectationTypeWrapper
{
    .init(type: .receiveSubscriberUnspecific,
          file: file,
          line: line)
}


// MARK: receiveSubscription

public
func receiveSubscription
(
    _ name: String,
    file: StaticString = #file,
    line: UInt = #line
)
-> CombineExpectationTypeWrapper
{
    .init(type: .receiveSubscriptionSpecific(name),
          file: file,
          line: line)
}


public
func receiveSubscription
(
    file: StaticString = #file,
    line: UInt = #line
)
-> CombineExpectationTypeWrapper
{
    .init(type: .receiveSubscriptionUnspecific,
          file: file,
          line: line)
}


// MARK: receiveValue

public
func receiveValue
(
    _ value: Any,
    file: StaticString = #file,
    line: UInt = #line
)
-> CombineExpectationTypeWrapper
{
    .init(type: .receiveValueSpecific(value),
          file: file,
          line: line)
}


public
func receiveValue
(
    file: StaticString = #file,
    line: UInt = #line
)
-> CombineExpectationTypeWrapper
{
    .init(type: .receiveValueUnspecific,
          file: file,
          line: line)
}


public
func receiveValue
(
    _ test: @escaping (Any) -> Bool,
    file: StaticString = #file,
    line: UInt = #line
)
-> CombineExpectationTypeWrapper
{
    .init(type: .receiveValueTest(test),
          file: file,
          line: line)
}


// MARK: receiveCompletion

public
func receiveCompletion
(
    _ completion: Subscribers.Completion<Swift.Error>,
    file: StaticString = #file,
    line: UInt = #line
)
-> CombineExpectationTypeWrapper
{
    .init(type: .receiveCompletionSpecific(completion),
          file: file,
          line: line)
}


public
func receiveCompletion
(
    file: StaticString = #file,
    line: UInt = #line
)
-> CombineExpectationTypeWrapper
{
    .init(type: .receiveCompletionUnspecific,
          file: file,
          line: line)
}


public
func receiveCompletion
(
    _ test: @escaping (Swift.Error) -> Bool,
    file: StaticString = #file,
    line: UInt = #line
)
-> CombineExpectationTypeWrapper
{
    .init(type: .receiveCompletionTestError(test),
          file: file,
          line: line)
}


// MARK: requestDemand

public
func requestDemand
(
    _ demand: Subscribers.Demand,
    file: StaticString = #file,
    line: UInt = #line
)
-> CombineExpectationTypeWrapper
{
    .init(type: .requestDemandSpecific(demand),
          file: file,
          line: line)
}


public
func requestDemand
(
    file: StaticString = #file,
    line: UInt = #line
)
-> CombineExpectationTypeWrapper
{
    .init(type: .requestDemandUnspecific,
          file: file,
          line: line)
}


// MARK: requestSyncDemand

public
func requestSyncDemand
(
    _ demand: Subscribers.Demand,
    file: StaticString = #file,
    line: UInt = #line
)
-> CombineExpectationTypeWrapper
{
    .init(type: .requestSyncDemandSpecific(demand),
          file: file,
          line: line)
}


public
func requestSyncDemand
(
    file: StaticString = #file,
    line: UInt = #line
)
-> CombineExpectationTypeWrapper
{
    .init(type: .requestSyncDemandUnspecific,
          file: file,
          line: line)
}


// MARK: cancel

public
func cancel
(
    file: StaticString = #file,
    line: UInt = #line
)
-> CombineExpectationTypeWrapper
{
    .init(type: .cancel,
          file: file,
          line: line)
}



// MARK: - CombineExpectationTypeWrapper

public
struct CombineExpectationTypeWrapper
{
    let type: CombineExpectationType

    let file: StaticString

    let line: UInt


    public
    init
    (
        type: CombineExpectationType,
        file: StaticString,
        line: UInt
    )
    {
        self.type = type
        self.file = file
        self.line = line
    }


    var sourceInfo: SourceInfo
    {
        .init(file: file, line: line)
    }
}
