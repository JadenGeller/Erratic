//
//  LazyShuffleCollection.swift
//  Erratic
//
//  Created by Jaden Geller on 1/11/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Permute

extension LazyCollectionType where Index: Hashable, Index.Distance == Int {
    /// Return a shuffled view of `self`.
    @warn_unused_result
    public func shuffle() -> LazyShuffleCollection<Self> {
        var collection = LazyShuffleCollection(unshuffled: self)
        collection.shuffle()
        return collection
    }
}

public struct LazyShuffleCollection<Base: CollectionType where Base.Index.Distance == Int, Base.Index: Hashable> {
    internal var permuted: PermuteCollection<Base>
    public var base: Base {
        get {
            return permuted.base
        } set {
            permuted.base = newValue
        }
    }
    public var permutation: ShufflePermutation<Base.Index> {
        get {
            return ShufflePermutation(permuted.permutation)
        } set {
            permuted.permutation = AnyPermutation(newValue)
        }
    }
    
    /// Constructs an unshuffled view of `collection`.
    public init(unshuffled collection: Base) {
        precondition(collection.count <= Int(UInt32.max), "Collection is too large.")
        self.permuted = PermuteCollection(collection, withPermutation: IdentityPermutation())
    }
    
    /// Shuffles the view in O(1) time complexity, resetting all indexed access operations to first
    /// access time complexity.
    public mutating func shuffle() {
        self.permutation = ShufflePermutation(indices: base.indices)
    }
}

extension LazyShuffleCollection: LazyCollectionType, PermuteCollectionType {
    public var startIndex: Base.Index {
        return base.startIndex
    }
    
    public var endIndex: Base.Index {
        return base.endIndex
    }
    
    /// Average case O(n) and worst case O(infinity) first access; worst case O(1) repeat access.
    public subscript(index: Base.Index) -> Base.Generator.Element {
    	get {
    		return permuted[index]
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

