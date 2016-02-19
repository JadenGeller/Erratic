//
//  LazyShuffleCollectionPermutation.swift
//  Erratic
//
//  Created by Jaden Geller on 2/19/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public struct LazyShuffleCollectionPermutation<Collection: CollectionType where Collection.Index.Distance == Int, Collection.Index: Hashable> {
    private var transform: Collection.Index -> Collection.Index
    
    internal init(unshuffled collection: Collection) {
        self.transform = { index in index }
    }
    
    internal init(_ collection: Collection) {
        var mapping: [Collection.Index : Collection.Index] = [:]
        var unusedIndices = UniqueRandomGenerator(fromSource: collection.indices)
        self.transform = { index in
            if let value = mapping[index] { return value }
            else {
                guard let value = unusedIndices.next() else { fatalError("Unexpected error: out of indices") }
                mapping[index] = value
                return value
            }
        }
    }
    
    // Assumption: index is within bounds of collection
    internal subscript(index: Collection.Index) -> Collection.Index {
        return transform(index)
    }
}

