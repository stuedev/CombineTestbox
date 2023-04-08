//
//  SectionExpectation.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation
import StateMachine


public
class SectionExpectation: NestingExpectationBase
{
    public
    static
    override
    var inversionBehaviour: InversionBehaviour { .resetUnfulfilledChildren }

    public
    static
    override
    var finalTreeStructure: FinalTreeConfig.Structures? { .section }
    
    
    
    let title: String
    
    @StateMachine
    var sectionState: SectionState = .idle

    
    init
    (
        title: String,
        expectations: [Expectation],
        sourceInfo: SourceInfo
    )
    {
        self.title = title
        
        super.init(expectations: expectations,
                   sourceInfo: sourceInfo)
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
        switch self.sectionState
        {
            case .idle:
                
                if case .sectionOpen(let title) = event.type
                {
                    try self.tryOpenSection(title: title,
                                            event: event,
                                            context: context)
                }
                
                
            case .open:

                if case .sectionClose(let title) = event.type
                {
                    try self.tryCloseSection(title: title,
                                             event: event,
                                             context: context)
                }
                else
                {
                    try super.performTest(with: event,
                                          context: context)
                }
                
                
            case .closed:
                
                /*
                 if the section was closed (and fulfilled), we don't expect any more events to be tested here.
                 */
                
                fatal_bug("unexpected")
        }
    }
    
    
    func tryOpenSection
    (
        title: String,
        event: Event,
        context: TestContext
    )
    throws
    {
        if title == self.title
        {
            event.match(with: self)

            self.sectionState = .open
        }
        else if context.strictEventTypes.contains(.section)
        {
            /*
             if the title didn't match, but we need to be strict about section events, we fail.
             */
            
            let failure = Failure.mismatchingEvent(event)
            
            try self.fail(with: failure,
                          context: context)
        }
    }

    
    func tryCloseSection
    (
        title: String,
        event: Event,
        context: TestContext
    )
    throws
    {
        /*
         first we need to check if the event is matched somewhere in our children, i.e. another section with same title.
         */
        
        try super.performTest(with: event,
                              context: context)
        
        
        /*
         if the event wasn't matched in our children, we check if it matches with our section.
         
         if it still didn't match, it might match with a section in our parent structure, so we dont fail.
         */
        
        if event.isIdle
        {
            if title == self.title
            {
                event.match(with: self)
                
                self.sectionState = .closed
              
                /*
                 if our section was closed, we try to *finalize*.
                 */
                
                try self.finalize()
            }
        }
    }
    
    
    override
    func checkIfFulfilled() throws
    {
        /*
         we block this method, because we need to manually finalize. This only happens after section was closed.
         */
    }

    
    public
    override
    func performFinalize() throws
    {
        /*
         consistency check
         
         make sure we never try to finalize when our section is not closed.
         */
        
        if case .open = self.sectionState
        {
            fatal_bug("unexpected")
        }
        
        
        /*
         we only finalize our children if our section was opened before (closed now), i.e. never when its *idle*.
         */
        
        if case .closed = self.sectionState
        {
            try self.performFinalizeChildren()
        }
        
        try self.performFinalizeSelf()
    }

    
    public
    override
    var shortDescription: String
    {
        "Section(\"\(self.title)\")"
    }
}


// MARK: - SectionState

extension SectionExpectation
{
    enum SectionState: ImplementsStateMachine
    {
        case idle

        case open

        case closed


        
        public
        static
        func canTransition
        (
            from fromValue: SectionState,
            to toValue: SectionState
        )
        -> Bool
        {
            switch (fromValue, toValue)
            {
                case
                    (.idle, .open),
                    (.open, .closed):
                    
                    return true
                    
                    
                default:
                    
                    return false
            }
        }
    }
}
