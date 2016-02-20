//
//  ErraticTests.swift
//  ErraticTests
//
//  Created by Jaden Geller on 1/11/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import XCTest
@testable import Erratic
import Permute

class ErraticTests: XCTestCase {
    func testUniqueRandomGenerator() {
        var set: Set = [1, 2, 3, 4]
        for x in UniqueRandomGenerator(fromSource: Array(set)) {
            set.remove(x)
        }
        XCTAssertTrue(set.isEmpty)
    }
    
    func testRepeatingRandomGenerator() {
        let set: Set = [1, 2, 3, 4]
        var count: [Int : Int] = [1 : 10, 2 : 10, 3 : 10, 4 : 10]
        for x in RepeatingRandomGenerator(fromSource: Array(set)) {
            count[x]! -= 1
            if count.values.maxElement() <= 0 { break }
        }
    }
    
    func testShuffleViewCoversAllPossibilities() {
        var shuffleView = [1, 2, 3, 4].lazy.shuffle()
        var seen = Set<String>()
        
        while seen.count < 24 {
            shuffleView.shuffle()
            seen.insert(String(shuffleView))
        }
    }
    
    func testShuffleViewMutation() {
        var shuffleView = MutableLazyShuffleCollection(unshuffled: [1, 2, 3, 4])
        shuffleView.shuffle()
        for i in shuffleView.indices {
            shuffleView[i] *= shuffleView[i]
        }
        shuffleView.shuffle()
        XCTAssertEqual(30, shuffleView.reduce(0, combine: +))
    }
    
    func testShuffleViewSaving() {
        var shuffleView = [1, 2, 3, 4].lazy.shuffle()
        let saved = Array(shuffleView)
        let permutation = shuffleView.permutation
        shuffleView.shuffle()
        shuffleView.permutation = permutation
        XCTAssertEqual(saved, Array(shuffleView))
    }
    
    func testShuffleViewPermutationCompleteness() {
        let a = [1, 2, 3, 4, 5].lazy.shuffle()
        let b = a
        XCTAssertEqual(Array(a), Array(b))
    }
    
    func testShuffleViewRangeReplacementSameSize() {
        var shuffleView = RangeReplaceableLazyShuffleCollection(unshuffled: [1, 1, 1, 1])
        shuffleView.shuffle()
        shuffleView.replaceRange(1...3, with: [2, 3, 4])
        XCTAssertEqual([1, 2, 3, 4], Array(shuffleView))
    }
    
    func testShuffleViewRangeReplacementShorter() {
        let collection = [5, 10, 15, 20]
        var shuffleView = RangeReplaceableLazyShuffleCollection(unshuffled: collection)
        shuffleView.permutation = ShufflePermutation(AnyPermutation(SequencedPermuation(indices: [3, 1, 0, 2])))
        XCTAssertEqual([20, 10, 5, 15], Array(shuffleView))
        shuffleView.replaceRange(1...3, with: [0, 1])
        XCTAssertEqual([1, 0, 20], shuffleView.base)
        XCTAssertEqual([20, 0, 1], Array(shuffleView))
    }
    
    func testShuffleViewRangeReplacementLonger() {
        let collection = [5, 10, 15, 20]
        var shuffleView = RangeReplaceableLazyShuffleCollection(unshuffled: collection)
        shuffleView.permutation = ShufflePermutation(AnyPermutation(SequencedPermuation(indices: [3, 1, 0, 2])))
        XCTAssertEqual([20, 10, 5, 15], Array(shuffleView))
        shuffleView.replaceRange(1...2, with: [0, 1, 2, 3])
        XCTAssertEqual([1, 0, 15, 20, 2, 3], shuffleView.base)
        XCTAssertEqual([20, 0, 1, 2, 3, 15], Array(shuffleView))
    }
}
