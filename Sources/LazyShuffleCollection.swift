//
//  LazyShuffleCollection.swift
//  Erratic
//
//  Created by Jaden Geller on 1/11/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Darwin

extension LazyCollectionType where Index: Hashable, Index.Distance == Int {
    /// Return a shuffled view of `self`.
    @warn_unused_result
    public func shuffle() -> LazyShuffleCollection<Self> {
        return LazyShuffleCollection(self)
    }
}

public struct LazyShuffleCollection<Collection: CollectionType where Collection.Index.Distance == Int, Collection.Index: Hashable> {
    private var collection: Collection
    
    /// The current shuffling for the collection. This value is only valid for this particular `LazyShuffleCollection`.
    public var permutation: LazyShuffleCollectionPermutation<Collection>
    
    public init(_ collection: Collection, mapping: LazyShuffleCollectionPermutation<Collection>) {
        precondition(collection.count <= Int(UInt32.max), "Collection is too large.")
        self.collection = collection
        self.permutation = mapping
    }
}

extension LazyShuffleCollection {
    /// Constructs an unshuffled view of `collection`.
    public init(unshuffled collection: Collection) {
        self.init(collection, mapping: LazyShuffleCollectionPermutation(unshuffled: collection))
    }
    
    /// Constructs a randomly shuffled view of `collection`.
    public init(_ collection: Collection) {
        self.collection = collection
        self.permutation = LazyShuffleCollectionPermutation(collection)
    }
    
    /// Reshuffles the view in O(1) time complexity, resetting all indexed access operations to first
    /// access time complexity.
    public mutating func shuffle() {
        self.permutation = LazyShuffleCollectionPermutation(collection)
    }
}

extension LazyShuffleCollection: LazyCollectionType {
    public var startIndex: Collection.Index {
        return collection.startIndex
    }
    
    public var endIndex: Collection.Index {
        return collection.endIndex
    }
    
    /// Average case O(n) and worst case O(infinity) first access; worst case O(1) repeat access.
    public subscript(index: Collection.Index) -> Collection.Generator.Element {
    	get {
    		return collection[permutation[index]]
    	}
    }
}

extension LazyShuffleCollection: CustomStringConvertible {
    public var description: String {
        return String(Array(self))
    }
}

public func ==<Collection: CollectionType where Collection.Index.Distance == Int, Collection.Index: Hashable, Collection.Generator.Element: Equatable>(lhs: LazyShuffleCollection<Collection>, rhs: LazyShuffleCollection<Collection>) -> Bool {
    return lhs.count == rhs.count && zip(lhs, rhs).reduce(true) { $0 && $1.0 == $1.1 }
}

