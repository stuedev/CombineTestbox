//
//  UnorderedExpectation.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation


public
class UnorderedExpectation: NestingExpectationBase
{
    public
    static
    override
    var inversionBehaviour: InversionBehaviour { .resetUnfulfilledChildren }

    public
    static
    override
    var finalTreeStructure: FinalTreeConfig.Structures? { .unordered }
    
    
    
    public
    override
    func postInit()
    {
        super.postInit()
        
        /*
         expectations nested inside Unordered should not forward events to their successors. Instead, Unordered has the power to decide when events are tested in which expectation.
         */
        
        self.removeSuccessors()
    }


    func removeSuccessors()
    {
        self.expectations.forEach
        {
            $0.successor = nil
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
        for expectation in self.idleExpectations
        {
            /*
             we test without failing here, because an event would be matched in a later nested expectation, but might lead to a failure in an earlier expectation.
             */
            
            try context.withoutFailing
            {
                context in

                try expectation.test(with: event,
                                     context: context)
            }

            /*
             if the event was matched or failed, exit the iteration.
             */
            
            guard event.isIdle
            else
            {
                break
            }
        }
        
        try self.checkIfFulfilled()
    }
    
    
    var idleExpectations: [Expectation]
    {
        self.expectations.filter { $0.isIdle }
    }

    
    public
    override
    var shortDescription: String
    {
        "unordered"
    }
}
