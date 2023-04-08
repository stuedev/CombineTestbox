//
//  equateExpectationStructures.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation
@testable import CombineTestbox


public
func equateExpectationStructures
(
    _ expectations1: [Expectation],
    _ expectations2: [Expectation]
)
-> EquateExpectationStructureResult
{
    guard expectations1.count == expectations2.count
    else
    {
        return .notEqual
    }
    
    for (exp1, exp2) in zip(expectations1, expectations2)
    {
        let result = equateExpectations(exp1, exp2)

        switch result
        {
            case .notEqual, .unableToEquate:
                
                return result
                
                
            default:
                
                break
        }
    }
    
    return .equal
}


public
func equateExpectations
(
    _ exp1: Expectation,
    _ exp2: Expectation
)
-> EquateExpectationStructureResult
{
    // unwrap expectations (e.g. Breakpoint)
    let (exp1, exp2) =
    {
        (unwrapExpectation(exp1), unwrapExpectation(exp2))
    }()
    
    
    switch (exp1, exp2)
    {
        case (let exp1 as CombineExpectation, let exp2 as CombineExpectation):
            
            return equateCombineExpectations(exp1, exp2)
            
            
        case (let exp1 as CustomExpectation, let exp2 as CustomExpectation):
            
            return .fromBool(exp1.string == exp2.string)
            
            
        case (_ as IgnoreExpectation, _ as IgnoreExpectation):
            
            return .equal

            
        case (let exp1 as (any ForEachExpectationProtocol), let exp2 as (any ForEachExpectationProtocol)):
            
            return equateForEachs(exp1, exp2)

            
        case (let exp1 as FunctionCallExpectation, let exp2 as FunctionCallExpectation):
            
            return equateFunctionCalls(exp1, exp2)
            
            
        case (let exp1 as GroupExpectation, let exp2 as GroupExpectation):
            
            return equateGroups(exp1, exp2)
            
            
        case (let exp1 as NotExpectation, let exp2 as NotExpectation):
            
            return equateExpectationStructures(exp1.expectations, exp2.expectations)
            
            
        case (let exp1 as SectionExpectation, let exp2 as SectionExpectation):
            
            return equateSections(exp1, exp2)
            
            
        case (let exp1 as StrictExpectation, let exp2 as StrictExpectation):
            
            return equateStricts(exp1, exp2)
            
            
        case (let exp1 as UnorderedExpectation, let exp2 as UnorderedExpectation):
            
            return equateExpectationStructures(exp1.expectations, exp2.expectations)

            
        default:
            
            return .notEqual
    }
}





func equateCombineExpectations
(
    _ exp1: CombineExpectation,
    _ exp2: CombineExpectation
)
-> EquateExpectationStructureResult
{
    return
        .fromBool(exp1.probe == exp2.probe)
        && equateCombineEventTypes(exp1.type, exp2.type)
}


func equateCombineEventTypes
(
    _ type1: CombineExpectationType,
    _ type2: CombineExpectationType
)
-> EquateExpectationStructureResult
{
    switch (type1, type2)
    {
        case
            (.receiveValueTest, _),
            (_, .receiveValueTest):

            return .unableToEquate(reason: .combineTestVariant)

            
        case
            (.receiveCompletionTestError, _),
            (_, .receiveCompletionTestError):
            
            return .unableToEquate(reason: .combineTestVariant)

            
        default:
            
            return .fromBool(equateCombineExpectationTypes(type1, type2))
    }
}


func equateForEachs
(
    _ exp1: any ForEachExpectationProtocol,
    _ exp2: any ForEachExpectationProtocol
)
-> EquateExpectationStructureResult
{
    func equateInner<T: Equatable>
    (
        _ exp1: ForEachExpectation<T>,
        _ exp2: ForEachExpectation<T>
    )
    -> EquateExpectationStructureResult
    {
        let expectations1 = exp1.body(exp1.values.first!)
        let expectations2 = exp2.body(exp2.values.first!)
        
        return
            .fromBool(exp1.title == exp2.title)
            && .fromBool(exp1.values == exp2.values)
            && equateExpectationStructures(expectations1, expectations2)
    }
    
    
    switch (exp1, exp2)
    {
        case (let exp1 as ForEachExpectation<Int>, let exp2 as ForEachExpectation<Int>):
            
            return equateInner(exp1, exp2)
            
            
        case (let exp1 as ForEachExpectation<String>, let exp2 as ForEachExpectation<String>):

            return equateInner(exp1, exp2)

            
        default:
            
            return .unableToEquate(reason: .forEachWithUnsupportedGenericType)
    }
}


func equateFunctionCalls
(
    _ exp1: FunctionCallExpectation,
    _ exp2: FunctionCallExpectation
)
-> EquateExpectationStructureResult
{
    let expectations1 = exp1.function.buildExpectations()
    let expectations2 = exp2.function.buildExpectations()

    return
        .fromBool(exp1.context == exp2.context)
        && equateExpectationStructures(expectations1, expectations2)
}


func equateGroups
(
    _ exp1: GroupExpectation,
    _ exp2: GroupExpectation
)
-> EquateExpectationStructureResult
{
    return
        .fromBool(exp1.title == exp2.title)
        && equateExpectationStructures(exp1.expectations, exp2.expectations)
}


func equateSections
(
    _ exp1: SectionExpectation,
    _ exp2: SectionExpectation
)
-> EquateExpectationStructureResult
{
    return
        .fromBool(exp1.title == exp2.title)
        && equateExpectationStructures(exp1.expectations, exp2.expectations)
}


func equateStricts
(
    _ exp1: StrictExpectation,
    _ exp2: StrictExpectation
)
-> EquateExpectationStructureResult
{
    return
        .fromBool(exp1.strictEventTypes == exp2.strictEventTypes)
        && equateExpectationStructures(exp1.expectations, exp2.expectations)
}



// MARK: EquateExpectationStructureResult

public
enum EquateExpectationStructureResult
{
    public
    enum UnableToEquateReason: CustomStringConvertible
    {
        case combineTestVariant
        
        case forEachWithUnsupportedGenericType
        
        
        public
        var description: String
        {
            switch self
            {
                case .combineTestVariant:
                    
                    return "`test` variants of Combine expectations cannot be equated, because their closures cannot be equated."
                    
                    
                case .forEachWithUnsupportedGenericType:
                    
                    return "Unsupported generic type in ForEach."
            }
        }
    }
    
    
    
    case equal
    
    case notEqual
    
    case unableToEquate(reason: UnableToEquateReason)
    
    
    static
    func fromBool
    (
        _ bool: Bool
    )
    -> Self
    {
        switch bool
        {
            case true:      return .equal
            case false:     return .notEqual
        }
    }
}


func &&
(
    _ lhs: EquateExpectationStructureResult,
    _ rhs: EquateExpectationStructureResult
)
-> EquateExpectationStructureResult
{
    switch (lhs, rhs)
    {
        case (.equal, .equal):
            
            return .equal
            
            
        case
            (.unableToEquate(let reason), _),
            (_ , .unableToEquate(let reason)):
            
            return .unableToEquate(reason: reason)
            
            
        default:
            
            return .notEqual
    }
}
