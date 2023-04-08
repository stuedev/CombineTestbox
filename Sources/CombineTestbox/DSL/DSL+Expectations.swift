//
//  DSL+Expectations.swift
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
    typeWrapper: CombineExpectationTypeWrapper
)
-> CombineExpectation
{
    return .init(probe: probe,
                 type: typeWrapper.type,
                 sourceInfo: typeWrapper.sourceInfo)
}



// MARK: strict

public
func strict
(
    _ strictEventTypes: EventTypeOptions,
    @ExpectationBuilder buildExpectations: () -> [Expectation],
    file: StaticString = #file,
    line: UInt = #line
)
-> StrictExpectation
{
    let expectations = buildExpectations()
    
    return .init(expectations: expectations,
                 strictEventTypes: strictEventTypes,
                 sourceInfo: .init(file: file,
                                   line: line))
}



// MARK: section

public
func section
(
    _ title: String,
    @ExpectationBuilder buildExpectations: () -> [Expectation],
    file: StaticString = #file,
    line: UInt = #line
)
-> SectionExpectation
{
    let expectations = buildExpectations()
    
    return .init(title: title,
                 expectations: expectations,
                 sourceInfo: .init(file: file,
                                   line: line))
}



// MARK: unordered

public
func unordered
(
    @ExpectationBuilder buildExpectations: () -> [Expectation],
    file: StaticString = #file,
    line: UInt = #line
)
-> UnorderedExpectation
{
    let expectations = buildExpectations()
    
    return .init(expectations: expectations,
                 sourceInfo: .init(file: file,
                                   line: line))
}



// MARK: not

public
func not
(
    _ expectation: Expectation,
    file: StaticString = #file,
    line: UInt = #line
)
-> NotExpectation
{
    .init(expectations: [expectation],
          sourceInfo: .init(file: file,
                            line: line))
}


public
func not
(
    @ExpectationBuilder buildExpectations: () -> [Expectation],
    file: StaticString = #file,
    line: UInt = #line
)
-> NotExpectation
{
    let expectations = buildExpectations()
    
    return .init(expectations: expectations,
                 sourceInfo: .init(file: file,
                                   line: line))
}



// MARK: group

public
func group
(
    _ title: String? = nil,
    @ExpectationBuilder buildExpectation: () -> [Expectation],
    file: StaticString = #file,
    line: UInt = #line
)
-> GroupExpectation
{
    let expectations = buildExpectation()
    
    return .init(title: title,
                 expectations: expectations,
                 sourceInfo: .init(file: file,
                                   line: line))
}



// MARK: forEach

public
func forEach<T>
(
    _ title: String? = nil,
    _ values: [T],
    @ExpectationBuilder body: @escaping (T) -> [Expectation],
    file: StaticString = #file,
    line: UInt = #line
)
-> ForEachExpectation<T>
{
    .init(title: title,
          values: values,
          body: body,
          sourceInfo: .init(file: file,
                            line: line))
}


public
func forEach<T>
(
    _ values: [T],
    @ExpectationBuilder body: @escaping (T) -> [Expectation],
    file: StaticString = #file,
    line: UInt = #line
)
-> ForEachExpectation<T>
{
    .init(title: nil,
          values: values,
          body: body,
          sourceInfo: .init(file: file,
                            line: line))
}



// MARK: function call

public
func call
(
    _ function: Function,
    _ context: String,
    file: StaticString = #file,
    line: UInt = #line
)
-> FunctionCallExpectation
{
    .init(function: function,
          context: context,
          sourceInfo: .init(file: file,
                            line: line))
}


public
func call
(
    _ context: String,
    _ buildFunction: () -> Function,
    file: StaticString = #file,
    line: UInt = #line
)
-> FunctionCallExpectation
{
    let function = buildFunction()
    
    return .init(function: function,
                 context: context,
                 sourceInfo: .init(file: file,
                                   line: line))
}



// MARK: ignore

public
func ignore
(
    file: StaticString = #file,
    line: UInt = #line
)
-> IgnoreExpectation
{
    .init(sourceInfo: .init(file: file,
                            line: line))
}



// MARK: custom

public
func custom
(
    _ string: String,
    file: StaticString = #file,
    line: UInt = #line
)
-> CustomExpectation
{
    .init(string: string,
          sourceInfo: .init(file: file,
                            line: line))
}



// MARK: break

public
enum Breakpoint
{}

public
let stop = Breakpoint.self

infix operator **: TernaryPrecedence


/**
 example: `stop ** "sub" > receiveValue(1)`
 */
public
func **
(
    _ keyword: Breakpoint.Type,
    _ expectation: Expectation
)
-> BreakpointExpectation
{
    .init(expectation: expectation,
          sourceInfo: expectation.sourceInfo)
}
