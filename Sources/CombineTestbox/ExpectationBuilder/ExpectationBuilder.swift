//
//  ExpectationBuilder.swift
//  
//
//  Created by Stefan Ueter on 27.03.23.
//

import Foundation


@resultBuilder
public
struct ExpectationBuilder
{
    // MARK: final result
    
    public
    static
    func buildFinalResult
    (
        _ expectations: [Expectation]
    )
    -> [Expectation]
    {
        var expectations = expectations
        
        connectSuccessors(in: &expectations)
        
        return expectations
    }
    
    
    
    // MARK: partial block
    
    public
    static
    func buildPartialBlock
    (
        first: [Expectation]
    )
    -> [Expectation]
    {
        first
    }
    
    
    
    public
    static
    func buildPartialBlock
    (
        accumulated: [Expectation],
        next: [Expectation]
    )
    -> [Expectation]
    {
        accumulated + next
    }
    
    
    
    // MARK: expression
    
    public
    static
    func buildExpression
    (
        _ expectation: Expectation
    )
    -> [Expectation]
    {
        [expectation]
    }
    
    
    
    public
    static
    func buildExpression
    (
        void: Void
    )
    -> [Expectation]
    {
        []
    }
    
    
    
    // MARK: array
    
    public
    static
    func buildArray
    (
        _ array: [[Expectation]]
    )
    -> [Expectation]
    {
        array.flatMap { $0 }
    }
    
    

    // MARK: either
    
    public
    static
    func buildEither
    (
        first expectations: [Expectation]
    )
    -> [Expectation]
    {
        expectations
    }
    
    
    
    public
    static
    func buildEither
    (
        second expectations: [Expectation]
    )
    -> [Expectation]
    {
        expectations
    }
    
    
    
    // MARK: optional
    
    public
    static
    func buildOptional
    (
        _ expectations: [Expectation]?
    )
    -> [Expectation]
    {
        expectations ?? []
    }
}


extension ExpectationBuilder
{
    // MARK: connectSuccessors
    
    static
    func connectSuccessors
    (
        in expectations: inout [Expectation]
    )
    {
        zip(expectations, expectations.dropFirst(1))
            .forEach
            {
                current, next in
                
                current.successor = next

                if let nested = current as? NestingExpectation
                {
                    if nested is SectionExpectation
                    {
                        /*
                         do not set successor from expectation inside of a section to an exectation outside of a section. sections need to be closed properly (with a close-event) before the event can be matched with the successor.
                         */
                        
                        return
                    }
                    
                    if let lastNested = nested.expectations.last
                    {
                        lastNested.successor = next
                    }
                }
            }
    }
}
