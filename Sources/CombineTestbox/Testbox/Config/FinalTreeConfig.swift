//
//  FinalTreeConfig.swift
//  
//
//  Created by Stefan Ueter on 24.03.23.
//

import Foundation


public
struct FinalTreeConfig
{
    public
    var visibleStructures: Structures = .all
}


extension FinalTreeConfig
{
    public
    struct Structures: OptionSet
    {
        public
        var rawValue: Int
        
        
        public
        init
        (
            rawValue: Int
        )
        {
            self.rawValue = rawValue
        }
        

        public
        static
        let group = Structures(rawValue: 1 << 0)

        public
        static
        let unordered = Structures(rawValue: 1 << 1)

        public
        static
        let strict = Structures(rawValue: 1 << 2)

        public
        static
        let section = Structures(rawValue: 1 << 3)

        public
        static
        let not = Structures(rawValue: 1 << 4)
        
        public
        static
        let forEach = Structures(rawValue: 1 << 5)

        public
        static
        let functionCall = Structures(rawValue: 1 << 6)
        
        
        public
        static
        let all: Structures =
            [
                .group,
                .unordered,
                .strict,
                .section,
                .not,
                .forEach,
                .functionCall
            ]
        
        public
        static
        let none: Structures = []
        
        public
        static
        let noFunctionCalls: Structures = .all.subtracting(.functionCall)
        
        public
        static
        let noForEachs: Structures = .all.subtracting(.forEach)
        
        public
        static
        let noForEachsOrFunctionCalls: Structures = .noForEachs.intersection(.noFunctionCalls)
    }
}
