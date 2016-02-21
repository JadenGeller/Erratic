//
//  UniqueRandomGenerator.swift
//  Erratic
//
//  Created by Jaden Geller on 1/11/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

public struct UniqueRandomGenerator<Source: CollectionType where Source.Index.Distance == Int, Source.Index: Hashable>: SequenceType, GeneratorType {
    private let source: Source
    private var usedIndices: Set<Source.Index>
    
    public init(fromSource source: Source) {
        precondition(source.count <= Int(UInt32.max), "Source is too large.")
        self.source = source
        self.usedIndices = []
    }
    
    public mutating func next() -> Source.Generator.Element? {
        guard usedIndices.count < source.count else { return nil }
        
        var index: Source.Index
        repeat {
            #if os(Linux)
                let distance = Int(random() % source.count)
            #else
                let distance = Int(arc4random_uniform(UInt32(source.count)))
            #endif
            index = source.startIndex.advancedBy(distance)
        } while usedIndices.contains(index)
        
        usedIndices.insert(index)
        return source[index]
    }
}