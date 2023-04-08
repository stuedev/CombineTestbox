//
//  NotExpectation.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation


public
class NotExpectation: NestingExpectationBase
{
    public
    static
    override
    var finalTreeStructure: FinalTreeConfig.Structures? { .not }

    
    
    override
    init
    (
        expectations: [Expectation],
        sourceInfo: SourceInfo
    )
    {
        super.init(expectations: expectations,
                   sourceInfo: sourceInfo)
    }

    
    public
    override
    func buildInverse()
    {
        /*
         direct children of *NotExpectation* inherit the *inverted inversion*.
         */
        
        var isInverse = self.isInverse
        isInverse.toggle()

        self.expectations.forEach
        {
            $0.isInverse = isInverse
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
        /*
         reset a potential *canFail = false*, because *NotExpectation* always needs to be able to fail, even as a successor.
         */
        
        var context = context
        context.canFail = true
        
        
        for expectation in self.idleExpectations
        {
            try expectation.test(with: event,
                                 context: context)

            /*
             if the event was matched or failed, exit the iteration.
             */
            
            guard event.isIdle
            else
            {
                break
            }
            
            /*
             special case:
             
             if we just tested the event inside a section, and it returns idle, we stop here.
             */
            
            if expectation is SectionExpectation
            {
                break
            }
        }
        
        /*
         if the event wasnt matched or failed, we test with the successor.
         */
        
        if event.isIdle
        {
            try self.testSuccessor(with: event,
                                   context: context)
        }
    }
    
    
    var idleExpectations: [Expectation]
    {
        self.expectations.filter { $0.isIdle }
    }
    
    
    public
    override
    func performFinalize() throws
    {
        try self.performFinalizeChildren()
        
        try wantToSetState(.fulfilled)
    }

    
    public
    override
    var shortDescription: String
    {
        "not"
    }
}
