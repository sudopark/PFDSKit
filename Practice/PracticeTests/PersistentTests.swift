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
