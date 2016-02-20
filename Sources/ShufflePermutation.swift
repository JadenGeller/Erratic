//
//  ShufflePermutation.swift
//  Erratic
//
//  Created by Jaden Geller on 2/19/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Permute

public struct ShufflePermutation<Index: ForwardIndexType where Index.Distance == Int, Index: Hashable>: PermutationType {
    private var transform: Index -> Index
    
    internal init(transform: Index -> Index) {
        self.transform = transform
    }
    
    public static func unshuffled() -> ShufflePermutation {
        return ShufflePermutation { $0 }
    }
    
    public init<C: CollectionType where C.Generator.Element == Index, C.Index.Distance == Int, C.Index: Hashable>(indices: C) {
        var mapping: [Index : Index] = [:]
        var unusedIndices = UniqueRandomGenerator(fromSource: indices)
        self.init { index in
            if let value = mapping[index] { return value }
            else {
                guard let value = unusedIndices.next() else { fatalError("Unexpected error: out of indices") }
                mapping[index] = value
                return value
            }
        }
    }
    
    // Assumption: index is within bounds of collection
    public subscript(index: Index) -> Index {
        return transform(index)
    }
}

