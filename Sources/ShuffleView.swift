//
//  ShuffleView.swift
//  Erratic
//
//  Created by Jaden Geller on 1/11/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Darwin

public struct ShuffleView<Collection: CollectionType where Collection.Index.Distance == Int, Collection.Index: Hashable> {
    private var collection: Collection
    
    /// The current shuffling for the collection. This value is only valid for this particular `ShuffleView`.
    public var permutation: ShuffleViewPermutation<Collection>
    
    public init(_ collection: Collection, mapping: ShuffleViewPermutation<Collection>) {
        precondition(collection.count <= Int(UInt32.max), "Collection is too large.")
        self.collection = collection
        self.permutation = mapping
    }
}

extension ShuffleView {
    /// Constructs an unshuffled view of `collection`.
    public init(unshuffled collection: Collection) {
        self.init(collection, mapping: ShuffleViewPermutation(unshuffled: collection))
    }
    
    /// Constructs a randomly shuffled view of `collection`.
    public init(_ collection: Collection) {
        self.collection = collection
        self.permutation = ShuffleViewPermutation(collection)
    }
    
    /// Reshuffles the view in O(1) time complexity, resetting all indexed access operations to first
    /// access time complexity.
    public mutating func shuffle() {
        self.permutation = ShuffleViewPermutation(collection)
    }
}

extension ShuffleView: CollectionType {
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

extension ShuffleView: CustomStringConvertible {
    public var description: String {
        return String(Array(self))
    }
}

public func ==<Collection: CollectionType where Collection.Index.Distance == Int, Collection.Index: Hashable, Collection.Generator.Element: Equatable>(lhs: ShuffleView<Collection>, rhs: ShuffleView<Collection>) -> Bool {
    return lhs.count == rhs.count && zip(lhs, rhs).reduce(true) { $0 && $1.0 == $1.1 }
}

public struct MutableShuffleView<Collection: MutableCollectionType where Collection.Index.Distance == Int, Collection.Index: Hashable> {
    private var collection: Collection
    
    /// The current shuffling for the collection. This value is only valid for this particular `ShuffleView`.
    public var permutation: ShuffleViewPermutation<Collection>
    
    public init(_ collection: Collection, mapping: ShuffleViewPermutation<Collection>) {
        precondition(collection.count <= Int(UInt32.max), "Collection is too large.")
        self.collection = collection
        self.permutation = mapping
    }
}

// Must be a seperate type until both are supported:
//  a) Unambiguously adding a setter in an extension to a type that already has a getter.
//  b) Conformance to protocol in conditional extension.
extension MutableShuffleView {
    /// Constructs an unshuffled view of `collection`.
    public init(unshuffled collection: Collection) {
        self.init(collection, mapping: ShuffleViewPermutation(unshuffled: collection))
    }
    
    /// Constructs a randomly shuffled view of `collection`.
    public init(_ collection: Collection) {
        self.collection = collection
        self.permutation = ShuffleViewPermutation(collection)
    }
    
    /// Reshuffles the view in O(1) time complexity, resetting all indexed access operations to first
    /// access time complexity.
    public mutating func shuffle() {
        self.permutation = ShuffleViewPermutation(collection)
    }
}

extension MutableShuffleView: MutableCollectionType {
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
        set {
            collection[permutation[index]] = newValue
        }
    }
}

public func ==<Collection: CollectionType where Collection.Index.Distance == Int, Collection.Index: Hashable, Collection.Generator.Element: Equatable>(lhs: MutableShuffleView<Collection>, rhs: MutableShuffleView<Collection>) -> Bool {
    return lhs.count == rhs.count && zip(lhs, rhs).reduce(true) { $0 && $1.0 == $1.1 }
}

public struct ShuffleViewPermutation<Collection: CollectionType where Collection.Index.Distance == Int, Collection.Index: Hashable> {
    private var transform: Collection.Index -> Collection.Index
    
    private init(unshuffled collection: Collection) {
        self.transform = { index in index }
    }
    
    private init(_ collection: Collection) {
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
    private subscript(index: Collection.Index) -> Collection.Index {
        return transform(index)
    }
}

