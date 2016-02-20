//
//  RangeReplaceableMutableLazyShuffleCollection.swift
//  Erratic
//
//  Created by Jaden Geller on 2/19/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//
//

import Permute

public struct RangeReplaceableLazyShuffleCollection<Base: RangeReplaceableCollectionType where Base.Index.Distance == Int, Base.Index: Hashable, Base.Index: BidirectionalIndexType, Base.Index: Comparable> {
    internal var permuted: RangeReplaceablePermuteCollection<Base>
    public var base: Base {
        get {
            return permuted.base
        } set {
            permuted.base = newValue
        }
    }
    public var permutation: LazyShufflePermutation<Base.Index> {
        get {
            return LazyShufflePermutation(permuted.permutation)
        } set {
            permuted.permutation = AnyPermutation(newValue)
        }
    }
    
    /// Constructs an unshuffled view of `collection`.
    public init(unshuffled collection: Base) {
        precondition(collection.count <= Int(UInt32.max), "Collection is too large.")
        self.permuted = RangeReplaceablePermuteCollection(collection, withPermutation: IdentityPermutation())
    }
    
    /// Shuffles the view in O(1) time complexity, resetting all indexed access operations to first
    /// access time complexity.
    public mutating func shuffle() {
        self.permutation = LazyShufflePermutation(indices: base.indices)
    }
}

extension RangeReplaceableLazyShuffleCollection: LazyCollectionType, PermuteCollectionType, MutableCollectionType {
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

extension RangeReplaceableLazyShuffleCollection: RangeReplaceableCollectionType {
    public init() {
        self.permuted = RangeReplaceablePermuteCollection()
    }
    
    public mutating func replaceRange<C : CollectionType where C.Generator.Element == Base.Generator.Element>(subRange: Range<Base.Index>, with newElements: C) {
        permuted.replaceRange(subRange, with: newElements)
    }
}

extension RangeReplaceableLazyShuffleCollection: CustomStringConvertible {
    public var description: String {
        return String(Array(self))
    }
}

public func ==<Collection: CollectionType where Collection.Index.Distance == Int, Collection.Index: Hashable, Collection.Generator.Element: Equatable>(lhs: RangeReplaceableLazyShuffleCollection<Collection>, rhs: RangeReplaceableLazyShuffleCollection<Collection>) -> Bool {
    return lhs.count == rhs.count && zip(lhs, rhs).reduce(true) { $0 && $1.0 == $1.1 }
}

extension LazyShuffleCollection where Base: RangeReplaceableCollectionType, Base.Index: BidirectionalIndexType, Base.Index: Comparable, Base.Index.Distance == Int {
    public init(_ collection: RangeReplaceableLazyShuffleCollection<Base>) {
        self.permuted = PermuteCollection(collection.permuted)
    }
}

extension MutableLazyShuffleCollection where Base: RangeReplaceableCollectionType, Base.Index: BidirectionalIndexType, Base.Index: Comparable, Base.Index.Distance == Int {
    public init(_ collection: RangeReplaceableLazyShuffleCollection<Base>) {
        self.permuted = MutablePermuteCollection(collection.permuted)
    }
}
