//
//  Tree.swift
//  Practice
//
//  Created by Sudo.park on 2021/01/20.
//

import Foundation


indirect enum Tree<Value: Comparable> {
    case empty
    case node(left: Self, value: Value, right: Self)
}


protocol Set {
    
    associatedtype Element: Comparable
    
    var isEmpty: Bool { get }
    
//    func insert(_ element: Element) -> Self
    
    func isMember(_ element: Element) -> Bool
}


extension Tree: Set {
    
    typealias Element = Value
    
    var isEmpty: Bool {
        guard case .empty = self else { return false }
        return true
    }
    
    func isMember(_ element: Value) -> Bool {
        guard case let .node(left, value, right) = self else { return false }
        return value == element ? true
            : element < value ? left.isMember(element)
            : right.isMember(element)
    }
}
