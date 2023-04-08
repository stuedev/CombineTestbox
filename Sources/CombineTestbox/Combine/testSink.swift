//
//  testSink.swift
//  
//
//  Created by Stefan Ueter on 28.03.23.
//

import Foundation
import Combine


extension Publisher
{
    public
    func testSink
    (
        _ testbox: any TestboxProtocol,
        probe: String
    )
    -> Cancellable
    {
        self
            .test(testbox, probe: probe)
            .sink { _ in } receiveValue: { _ in }
    }


    public
    func testSink
    (
        _ testbox: any TestboxProtocol,
        probe: String
    )
    -> Cancellable
    where Failure == Never
    {
        self
            .test(testbox, probe: probe)
            .sink { _ in }
    }
}
