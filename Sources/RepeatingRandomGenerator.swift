//
//  RepeatingRandomGenerator.swift
//  Erratic
//
//  Created by Jaden Geller on 1/11/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Darwin

public struct RepeatingRandomGenerator<Source: CollectionType where Source.Index.Distance == Int>: SequenceType, GeneratorType {
    private let source: Source
    
    public init(fromSource source: Source) {
        precondition(source.count <= Int(UInt32.max), "Source is too large.")
        self.source = source
    }
    
    public func next() -> Source.Generator.Element? {
        let distance = Int(arc4random_uniform(UInt32(source.count)))
        return source[source.startIndex.advancedBy(distance)]
    }
}
