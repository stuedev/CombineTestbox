//
//  FeatureTestCase+Category.swift
//  
//
//  Created by Stefan Ueter on 29.03.23.
//

import Foundation
import GeneratedTestCase


extension FeatureTestCase
{
    static
    func category
    (
        _ name: String,
        @TestBuilder buildTests: () -> [Test]
    )
    -> [Test]
    {
        createTestsInCategory(named: name,
                              buildTests: buildTests,
                              focussed: false)
    }
    
    
    static
    func fcategory
    (
        _ name: String,
        @TestBuilder buildTests: () -> [Test]
    )
    -> [Test]
    {
        createTestsInCategory(named: name,
                              buildTests: buildTests,
                              focussed: true)
    }
}


fileprivate
func createTestsInCategory
(
    named categoryName: String,
    buildTests: () -> [GeneratedTestCase.Test],
    focussed: Bool
)
-> [GeneratedTestCase.Test]
{
    let tests = buildTests()
    
    return
        tests
            .map
            {
                var test = $0

                test.name = categoryName + "," + test.name

                /*
                 do not overwrite individually focussed tests with *false*
                 */
                if focussed == true
                {
                    test.isFocussed = focussed
                }
                
                return test
            }
}
