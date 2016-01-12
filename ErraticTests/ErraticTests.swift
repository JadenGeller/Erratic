//
//  ErraticTests.swift
//  ErraticTests
//
//  Created by Jaden Geller on 1/11/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import XCTest
@testable import Erratic

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
        let collection = [1, 2, 3, 4]
        var shuffleView = ShuffleView(collection)
        var seen = Set<String>()
        
        while seen.count < 24 {
            shuffleView.shuffle()
            seen.insert(String(shuffleView))
        }
    }
    
    func testShuffleViewMutation() {
        let collection = [1, 2, 3, 4]
        var shuffleView = MutableShuffleView(collection)
        for i in shuffleView.indices {
            shuffleView[i] *= shuffleView[i]
        }
        shuffleView.shuffle()
        XCTAssertEqual(30, shuffleView.reduce(0, combine: +))
    }
    
    func testShuffleViewSaving() {
        var shuffleView = ShuffleView([1, 2, 3, 4])
        let saved = Array(shuffleView)
        let permutation = shuffleView.permutation
        shuffleView.shuffle()
        shuffleView.permutation = permutation
        XCTAssertEqual(saved, Array(shuffleView))
    }
    
    func testShuffleViewPermutationCompleteness() {
        let a = ShuffleView([1, 2, 3, 4, 5])
        let b = a
        XCTAssertEqual(Array(a), Array(b))
    }
}
