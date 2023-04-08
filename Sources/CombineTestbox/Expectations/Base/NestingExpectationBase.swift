//
//  NestingExpectationBase.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


public
class NestingExpectationBase: ExpectationBase, NestingExpectation
{
    public
    var expectations: [Expectation]
    
    
    // MARK: init
    
    init
    (
        expectations: [Expectation],
        sourceInfo: SourceInfo
    )
    {
        self.expectations = expectations
        
        super.init(sourceInfo: sourceInfo)
    }
    
    
    
    // MARK: methods
    
    public
    override
    func postInit()
    {
        super.postInit()
        
        self.buildInverse()
        
        self.expectations.forEach
        {
            $0.parent = self
            $0.stack = self.stack
            $0.config = self.config
            
            $0.postInit()
        }
    }
    
    
    public
    override
    func performTest
    (
        with event: Event,
        context: TestContext
    )
    throws
    {
        guard let currentExpectation
        else
        {
            return
        }
        
        
        try currentExpectation.test(with: event,
                                    context: context)
        
        try checkIfFulfilled()
    }
    
    
    func checkIfFulfilled() throws
    {
        if allExpectationsFulfilled
        {
            try self.fulfill()
        }
    }
    
    
    var currentExpectation: Expectation?
    {
        self.expectations.first { $0.isIdle }
    }
    
    
    var allExpectationsFulfilled: Bool
    {
        self.expectations.allSatisfy { $0.isFulfilled }
    }
    
    
    public
    override
    func performFinalize() throws
    {
        try performFinalizeChildren()
        
        try performFinalizeSelf()
    }
    
    
    public
    override
    func performFinalizeSelf() throws
    {
        let state: ExpectationState
        
        if allExpectationsFulfilled
        {
            state = self.desiredFinalState()
        }
        else
        {
            /*
             if we're not done, behaves like parent class
             */
            
            state = super.desiredFinalState()
        }
        
        try wantToSetState(state)
    }
    
    
    func performFinalizeChildren() throws
    {
        try self.expectations.forEach
        {
            try $0.finalize()
        }
    }
    
    
    public
    override
    func desiredFinalState() -> ExpectationState
    {
        switch self.isInverse
        {
            case false:
                
                return .fulfilled
                
                
            case true:
                
                let failure = Failure.fulfilledInverse
                
                return .failed(failure)
        }
    }
    
    
    public
    func buildInverse()
    {
        guard case .inherit = Self.inversionBehaviour
        else
        {
            return
        }
        
        
        self.expectations.forEach
        {
            $0.isInverse = self.isInverse
        }
    }
    
    
    public
    override
    func finalTreeString
    (
        level: Int,
        config: FinalTreeConfig
    )
    -> String
    {
        let line_self = super.finalTreeString(level: level,
                                              config: config)

        var level = level
        
        if line_self != nil
        {
            level += 1
        }
        
        let lines =
            [ line_self ]
            + self.expectations
                .map
                {
                    $0.finalTreeString(level: level,
                                       config: config)
                }
            
        let string =
            lines
                .compactMap { $0 }
                .joined(separator: "\n")

        return string
    }
    
    
    public
    override
    func successorTreeString
    (
        level: Int
    )
    -> String
    {
        let lines =
            [super.successorTreeString(level: level)]
            + self.expectations.map { $0.successorTreeString(level: level + 1) }
            
        return lines.joined(separator: "\n")
    }
}
