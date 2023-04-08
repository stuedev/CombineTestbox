//
//  ForEachExpectation.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation


// MARK: - Protocol

public
protocol ForEachExpectationProtocol<T>
{
    associatedtype T
}


// MARK: - ForEachExpectation

public
class ForEachExpectation<T>: NestingExpectationBase, ForEachExpectationProtocol
{
    public
    static
    override
    var finalTreeStructure: FinalTreeConfig.Structures? { .forEach }

    
    
    let title: String?
    
    let values: [T]
    
    let body: (T) -> [Expectation]
    
    var iterator: any IteratorProtocol<T>
    
    var currentElement: T?
    
    
    init
    (
        title: String?,
        values: [T],
        body: @escaping (T) -> [Expectation],
        sourceInfo: SourceInfo
    )
    {
        self.title = title
        self.values = values
        self.body = body
        self.iterator = values.makeIterator()
        
        super.init(expectations: [],
                   sourceInfo: sourceInfo)
    }

    
    public
    override
    func postInit()
    {
        super.postInit()

        /*
         create first iteration after init
         */
        
        self.advance()
    }
    
    
    func advance()
    {
        if let currentElement = self.iterator.next()
        {
            let iteration = ForEachIterationExpectation(title: self.title,
                                                        value: currentElement,
                                                        body: self.body,
                                                        sourceInfo: self.sourceInfo)
            
            iteration.isInverse = self.isInverse
            iteration.stack = self.stack
            iteration.parent = self
            iteration.config = self.config

            iteration.postInit()
            
            self.expectations.append(iteration)
        }
    }

    
    public
    override
    func performExpectationWantsToSetState
    (
        expectation: Expectation,
        desiredState: DesiredExpectationState
    )
    -> FinalExpectationState
    {
        let finalState = super.performExpectationWantsToSetState(expectation: expectation,
                                                                 desiredState: desiredState)
        
        /*
         if a direct child expectation is about to be fulfilled, advance to next iteration.
         */
        
        if self.expectations.contains(where: { $0 === expectation }),
           case .fulfilled = finalState.state
        {
            self.advance()
        }
        
        return finalState
    }

    
    public
    override
    var shortDescription: String
    {
        var string = "forEach("
        
        if let title
        {
            string += "\"\(title)\", "
        }
        
        string += String(describing: self.values).truncate(maxLength: 20) + ")"
        
        return string
    }
}



// MARK: - Iteration

internal
class ForEachIterationExpectation<T>: NestingExpectationBase
{
    public
    static
    override
    var inversionBehaviour: InversionBehaviour { .inherit }

    public
    static
    override
    var finalTreeStructure: FinalTreeConfig.Structures? { .forEach }

    
    
    let title: String?
    
    let value: T
    
    let body: (T) -> [Expectation]
    
    
    init
    (
        title: String?,
        value: T,
        body: @escaping (T) -> [Expectation],
        sourceInfo: SourceInfo
    )
    {
        self.title = title
        self.value = value
        self.body = body
        
        let expectations = body(value)
        
        super.init(expectations: expectations,
                   sourceInfo: sourceInfo)
    }
    
    
    public
    override
    func postInit()
    {
        let stackEntry = StackEntry.forEachIteration(title: self.title,
                                                     value: self.value)
        
        self.stack.append(stackEntry)
        
        super.postInit()
    }

    
    public
    override
    var shortDescription: String
    {
        "_iteration(\"\(self.value)\")"
    }
}
