//
//  List.swift
//  Practice
//
//  Created by Sudo.park on 2021/01/19.
//

import Foundation


protocol List {
    
    associatedtype Value
    
    static var empty: Self { get }
    
    var isEmpty: Bool { get }
    
    init(_ value: Value, list: Self)
    
    var head: Value? {  get }
    
    var tail: Self { get }
}


extension Array: List {
    
    typealias Value = Element
    
    static var empty: Array<Element> {
        return []
    }
    
    
    static func cons(_ value: Element, _ list: Array<Element>) -> Array<Element> {
        return [value] + list
    }
    
    init(_ value: Element, list: Array) {
        self = [value] + list
    }
    
    var head: Element? {
        return self.first
    }
    
    var tail: Array<Element> {
        guard self.isEmpty == false else {
            return .empty
        }
        return Array(self[1...])
    }
}

extension List {
    
    func listExamples() {
        let emptyList = Array<Int>.empty
        let oneList = Array<Int>(1, list: emptyList)
        let remains = oneList.tail
    }
}



// concat list
infix operator ++

func ++<L: List>(_ lhs: L, _ rhs: L) -> L {
    guard let left_head = lhs.head else {
        return rhs
    }
    return L.init(left_head, list: lhs.tail ++ rhs)
}


extension List {

    // update list
    func update(index: Int, newValue: Value) -> Self {
        guard let head = self.head else { return self }
        if index == 0 {
            return Self.init(newValue, list: self.tail)
        } else {
            return Self.init(head, list: self.tail.update(index: index-1, newValue: newValue))
        }
    }
    
    // suffixes list
    func suffixes() -> [Self] {
        return self.isEmpty
            ? [Self].init(self, list: .empty)
            : [Self].init(self, list: self.tail.suffixes())
    }
}

