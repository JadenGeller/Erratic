//
//  MutableLazyShuffleCollection.swift
//  Erratic
//
//  Created by Jaden Geller on 2/19/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Permute

public struct MutableLazyShuffleCollection<Base: MutableCollectionType where Base.Index.Distance == Int, Base.Index: Hashable> {
    internal var permuted: MutablePermuteCollection<Base>
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
        self.permuted = MutablePermuteCollection(collection, withPermutation: IdentityPermutation())
    }
    
    /// Shuffles the view in O(1) time complexity, resetting all indexed access operations to first
    /// access time complexity.
    public mutating func shuffle() {
        self.permutation = ShufflePermutation(indices: base.indices)
    }
}

extension MutableLazyShuffleCollection: LazyCollectionType, PermuteCollectionType, MutableCollectionType {
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
        set {
            permuted[index] = newValue
        }
    }
}

extension MutableLazyShuffleCollection: CustomStringConvertible {
    public var description: String {
        return String(Array(self))
    }
}

public func ==<Collection: CollectionType where Collection.Index.Distance == Int, Collection.Index: Hashable, Collection.Generator.Element: Equatable>(lhs: MutableLazyShuffleCollection<Collection>, rhs: MutableLazyShuffleCollection<Collection>) -> Bool {
    return lhs.count == rhs.count && zip(lhs, rhs).reduce(true) { $0 && $1.0 == $1.1 }
}

extension LazyShuffleCollection where Base: MutableCollectionType  {
    init(_ collection: MutableLazyShuffleCollection<Base>) {
        self.permuted = PermuteCollection(collection.permuted)
    }
}

