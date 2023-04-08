//
//  Testbox.swift
//  
//
//  Created by Stefan Ueter on 23.03.23.
//

import Foundation
import StateMachine
import XCTest


public
class Testbox: TestboxProtocol
{
    // MARK: static config
    
    public
    static
    let config: TestboxConfiguration = .init()
    
    
    
    // MARK: config

    public
    let config: TestboxConfiguration = Testbox.config.copy() as! TestboxConfiguration
    
    
    
    // MARK: members
    
    let rootExpectation: TestboxRootExpectation
    
    
    
    // MARK: state
    
    let doneExpectation: XCTestExpectation = .init(description: "done")
    
    @StateMachine
    public
    var state: TestboxState = .idle
    
    var isFirstEvent: Bool = true

    
    
    // MARK: init
    
    public
    init
    (
        expectations: [Expectation],
        file: StaticString = #file,
        line: UInt = #line
    )
    {
        let sourceInfo = SourceInfo(file: file,
                                    line: line)
        
        /*
         setup root expectation
         */
        
        self.rootExpectation = TestboxRootExpectation(expectations: expectations,
                                                      sourceInfo: sourceInfo)
        
        self.rootExpectation.config = self.config
        self.rootExpectation.postInit()

        
        if self.config.debug.successorTree
        {
            let successorTreeString = self.rootExpectation.successorTree()
            
            Swift.print(successorTreeString)
        }
    }
    
    
    
    public
    convenience
    init
    (
        @ExpectationBuilder buildExpectations: () -> [Expectation],
        file: StaticString = #file,
        line: UInt = #line
    )
    {
        let expectations = buildExpectations()
        
        self.init(expectations: expectations,
                  file: file,
                  line: line)
    }
    
    
    
    // MARK: report event
    
    public
    func reportEvent
    (
        _ event: Event
    )
    {
        /*
         do not handle any events after we've completed
         */
        
        guard case .idle = self.state
        else
        {
            return
        }
        
        /*
         if this is the first event, show the message
         */
        
        if self.isFirstEvent
        {
            self.showFirstEventMessage()

            self.isFirstEvent = false
        }
        
        /*
         do not handle events that are blocked by config
         */
        
        guard event.type.isAffectedBy(self.config.reportedEvents)
        else
        {
            return
        }

        
        do
        {
            let context = TestContext()
            
            event.logger = self.config.logger
            
            try self.rootExpectation.test(with: event,
                                          context: context)
            
            /*
             if root expectation is fulfilled after testing this event, we finish
             */
            
            if self.rootExpectation.isFulfilled
            {
                self.finish(with: .succeeded)
            }
        }
        catch let failureError as FailureError
        {
            self.config.logger.log(.event(.failed(event: event,
                                                  inExpectation: failureError.inExpectation,
                                                  failure: failureError.failure,
                                                  isRedeemed: failureError.isRedeemed)))
            
            self.handleFailureError(failureError)
        }
        catch
        {
            fatal_bug("unexpected")
        }
    }
    
    
    func showFirstEventMessage()
    {
        if self.config.reportedEvents != .all
        {
            let blockedEventTypes = EventTypeOptions.all.subtracting(self.config.reportedEvents)
            
            let string =
                """
                \(Constants.Icons.warning) The following event types are blocked: \(blockedEventTypes)
                
                """
            
            Swift.print(string)
        }
    }
    
    
    
    // MARK: reportCustomEvent
    
    public
    func reportCustomEvent
    (
        _ string: String
    )
    {
        let event = Event.customEvent(string: string)
        
        self.reportEvent(event)
    }
    
    
    
    // MARK: section
    
    @discardableResult
    public
    func section
    (
        _ title: String,
        body: () -> Void
    )
    -> Self
    {
        let openEvent = Event.sectionOpenEvent(title: title)
        let closeEvent = Event.sectionCloseEvent(title: title)
        
        self.reportEvent(openEvent)
        
        body()
        
        self.reportEvent(closeEvent)
        
        return self
    }
    
    
    
    // MARK: handleError
    
    func handleFailureError
    (
        _ error: FailureError
    )
    {
        self.config.logger.log(.failure(inExpectation: error.inExpectation,
                                        failure: error.failure,
                                        isRedeemed: error.isRedeemed))
        
        /*
         if failure is .unmetExpectedFailure and we expected this failure, finish with success.
         */
        
        if case .unmetExpectedFailure = error.failure,
           self.config.expectUnmetFailure
        {
            self.finish(with: .succeeded)
        }
        else
        {
            let state = TestboxState.failed(inExpectation: error.inExpectation,
                                            failure: error.failure,
                                            isRedeemed: error.isRedeemed)
            
            self.finish(with: state)
        }
    }
    
    
    
    // MARK: wait
    
    public
    func wait
    (
        timeout: TimeInterval
    )
    {
        let result = XCTWaiter.wait(for: [self.doneExpectation],
                                    timeout: timeout)
        
        switch result
        {
            case .timedOut:
                
                do
                {
                    try self.rootExpectation.finalize()
                    
                    /*
                     if the *finalize* pass didn't produce any failure, we finish with success
                     */
                    
                    self.finish(with: .succeeded)
                }
                catch let failureError as FailureError
                {
                    self.handleFailureError(failureError)
                }
                catch
                {
                    fatal_bug("unexpected")
                }
                
                
            case .completed:
                
                break
                
                
            default:
                
                fatal_bug("not implemented")
        }
        
        
        if self.config.debug.finalTree
        {
            self.printFinalTree()
        }

        
        if case .idle = self.state
        {
            fatal_bug("unexpected")
        }
    }
    
    
    
    func printFinalTree()
    {
        Swift.print("-" * 100)
        
        let finalTreeString = self.rootExpectation.finalTree(config: self.config.finalTreeConfig)
        
        Swift.print(finalTreeString)
    }
    
    
    
    // MARK: finish
    
    func finish
    (
        with state: TestboxState
    )
    {
        self.state = state
        
        /*
         this will complete the XCTWaiter
         */
        
        self.doneExpectation.fulfill()

        /*
         if we had a (non-redeemed) failure, record it
         */
        
        if case .failed(let inExpectation,
                        let failure,
                        let isRedeemed) = state,
           isRedeemed == false
        {
            self.recordFailure(inExpectation: inExpectation,
                               failure: failure)
        }
    }
    
    
    
    // MARK: record failure
    
    func recordFailure
    (
        inExpectation expectation: Expectation,
        failure: Failure
    )
    {
        let stack = expectation.stack
        let sourceInfo = expectation.sourceInfo
        let message = failure.description

        var string =
            """
            
            
            \(message)
            """
        
        if stack.hasEntries
        {
            string +=
                """
                
                
                ===== Stack =====
                \(stack.toString())
                """
        }
        
        /*
         if configured, use the recorder closure that works with XCTIssue.
         
         otherwise, use XCTFail
         */
        
        if let recorder = self.config.recorder
        {
            let location = XCTSourceCodeLocation(filePath: sourceInfo.file,
                                                 lineNumber: sourceInfo.line)
            
            let context = XCTSourceCodeContext(location: location)
            
            let issue = XCTIssue(type: .assertionFailure,
                                 compactDescription: string,
                                 sourceCodeContext: context)
            
            recorder(issue)
        }
        else
        {
            XCTFail(string,
                    file: sourceInfo.file,
                    line: sourceInfo.line)
        }
    }
}
