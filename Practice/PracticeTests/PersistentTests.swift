//
//  PersistentTests.swift
//  PracticeTests
//
//  Created by Sudo.park on 2021/01/20.
//

import XCTest
@testable import Practice


class PersistentTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

}


// MARK: - Test List

extension PersistentTests {
    
    func testList_concat() {
        // given
        let list1 = [1, 2, 3]
        let list2 = [4, 5, 6]
        
        // when
        let concatList = list1 ++ list2
        
        // then
        XCTAssertEqual(concatList, [1, 2, 3, 4, 5, 6])
    }
    
    func testList_update() {
        // given
        let originalList = [0, 1, 2, 3, 4]
        
        // when
        let newList = originalList.update(index: 2, newValue: 7)
        
        // then
        XCTAssertEqual(newList, [0, 1, 7, 3, 4])
    }
    
    func testList_suffixes() {
        // given
        let list = [1, 2, 3, 4]
        
        // when
        let suffixes = list.suffixes()
        
        // then
        XCTAssertEqual(suffixes, [
            [1, 2, 3, 4],
            [2, 3, 4],
            [3, 4],
            [4],
            []
        ])
    }
}


// MARK: - Test Tree Set

extension PersistentTests {
    
    private var baseSet: Tree<Float> {
        let left: Tree<Float> = .node(left: .node(left: .empty, value: 1, right: .empty),
                                    value: 2,
                                    right: .node(left: .empty, value: 3, right: .empty))
        let right: Tree<Float> = .node(left: .node(left: .empty, value: 5, right: .empty),
                                     value: 6,
                                     right: .node(left: .empty, value: 7, right: .empty))
        return .node(left: left, value: 4, right: right)
    }
    
    func testSet_isMember() {
        // given
        let set = self.baseSet
        
        // when
        let isMembers = (0..<9).map{ set.isMember(Float($0)) }
        
        // then
        let trues = (1...7).map{ _ in true }
        XCTAssertEqual(isMembers, [false] + trues + [false])
    }
}


// MARK: - Test functional min heap

extension PersistentTests {
    
    func testHeap_whenEmpty_sizeIs0() {
        // given
        let heap: MinHeap<Int> = .empty
        
        // when
        // then
        XCTAssertEqual(heap.size, 0)
    }
    
    func testHeap_whenEmpty_isEmpty() {
        // given
        let heap: MinHeap<Int> = .empty
        
        // when
        // then
        XCTAssertEqual(heap.isEmpty, true)
    }
    
    func testHeap_whenEmpety_topIsEmpty() {
        // given
        let heap: MinHeap<Int> = .empty
        
        // when
        // then
        XCTAssertEqual(heap.top, nil)
    }
    
    func testHeap_insertAndCount() {
        // given
        var heap: MinHeap<Int> = .empty
        
        // when
        (0..<10).shuffled().forEach {
            heap = heap.inserted($0)
        }
        
        // then
        XCTAssertEqual(heap.size, 10)
    }
    
    func testHeap_whenAfterIntert_topIsMin() {
        // given
        var heap: MinHeap<Int> = .empty
        
        // when
        (0..<10).reversed().forEach {
            heap = heap.inserted($0)
        }
        
        // then
        XCTAssertEqual(heap.top, 0)
    }
    
    private func popAllValues(_ heap: MinHeap<Int>) -> [Int] {
        var heap = heap
        return (0..<heap.size).reduce([Int]()) { acc, _ in
            let (v, h) = heap.deleteTop()
            heap = h
            return acc + [v]
        }
    }
    
    func testHeap_whenDeleteTop_keepOrder() {
        // given
        var heap: MinHeap<Int> = .empty
        (0..<10).reversed().forEach {
            heap = heap.inserted($0)
        }
        var mins = [Int]()
        
        // when
        (0..<10).forEach { _ in
            let (min, newHeap) = heap.deleteTop()
            mins.append(min)
            heap = newHeap
        }
        
        // then
        XCTAssertEqual(mins, Array(0..<10))
    }
    
    func testHeap_insertAfterDelete() {
        // given
        var heap: MinHeap<Int> = .empty
        
        (0..<10).reversed().forEach {
            heap = heap.inserted($0)
        }
        (0..<5).forEach { _ in
            heap = heap.deleteTop().1
        }
        
        // when
        (10..<15).shuffled().forEach {
            heap = heap.inserted($0)
        }
        
        // then
        let actual = self.popAllValues(heap)
        XCTAssertEqual(actual, Array(5..<10) + Array(10..<15))
    }
    
    func testHeap_insertDuplicateValues() {
        // given
        var heap: MinHeap<Int> = .empty
        let source = [1, 2, 3 ,1, 3, 3, 2]
        
        // when
        source.shuffled().forEach {
            heap = heap.inserted($0)
        }
        
        // then
        XCTAssertEqual(self.popAllValues(heap), source.sorted())
    }
    
    func testHeap_merge() {
        // given
        let left: MinHeap<Int> = .node(.empty, element: 2, size: 1, .empty)
        let right: MinHeap<Int> = .node(.empty, element: 3, size: 1, .empty)
        
        // when
        let merged = MinHeap<Int>.merge(left, right, with: 2)
        
        // then
        let values = self.popAllValues(merged)
        XCTAssertEqual(values, [2, 2, 3])
    }
}
