//
//  Heap.swift
//  Practice
//
//  Created by Sudo.park on 2021/03/20.
//

import Foundation


//protocol HeapProperty {
//
//    associatedtype Element: Comparable
//
//    var size: Int { get }
//
//    var isEmpty: Bool { get }
//
//    var top: Element? { get }
//}
//
//
//public enum Heaps<Element: Comparable> {
//
//    public enum Heap {
//
//        public typealias Compare = (Element, Element) -> Bool
//
//        case empty
//        indirect case node(_ left: Self, element: Element, size: Int, _ right: Self)
//    }
//
//    case minHeap(Heap)
//    case maxHeap(Heap)
//}
//
//
//extension Heaps.Heap: HeapProperty {
//
//    public var size: Int {
//        switch self {
//        case .empty: return 0
//        case let .node(_, _, size, _): return size
//        }
//    }
//
//    public var isEmpty: Bool {
//        guard case .empty = self else { return false }
//        return true
//    }
//
//    public var top: Element? {
//        guard case let .node(_, element, _, _) = self else { return nil }
//        return element
//    }
//}
//
//
//// MARK: - insert value
//
//extension Heaps.Heap {
//
//    private static func singleTon(_ element: Element) -> Self {
//        return .node(.empty, element: element, size: 1, .empty)
//    }
//
//    public func inserted(_ new: Element, compare: Compare) -> Self {
//        switch self {
//        case .empty:
//            return Self.singleTon(new)
//
//        case let .node(left, element, size, right) where compare(new, element):
//            return left.size > right.size && left.size % 2 != 0
//                ?  .node(left, element: new, size: size+1, right.inserted(element, compare: compare))
//                : .node(left.inserted(element, compare: compare), element: new, size: size+1, right)
//
//        case let .node(left, element, size, right):
//            return left.size > right.size && left.size % 2 != 0
//                ? .node(left, element: element, size: size+1, right.inserted(new, compare: compare))
//                : .node(left.inserted(new, compare: compare), element: element, size: size+1, right)
//        }
//    }
//}
//
//// MARK: - removeTop
//
//extension Heaps.Heap {
//
//    public func removeTop(_ compare: Compare) -> (Element, Self) {
//        switch self {
//        case .empty:
//            fatalError()
//
//        case let .node(.empty, element, _, .empty):
//            return (element, .empty)
//
//        case let .node(left, element, _, right) where left.size > right.size:
//            let (lb, newleft) = left.removeBottom(compare)
//            return (element, Self.merge(lb, newleft, right, compare))
//
//        case let .node(left, element, _, right):
//            let (rb, newRight) = right.removeBottom(compare)
//            return (element, Self.merge(rb, left, newRight, compare))
//        }
//    }
//
//    private func removeBottom(_ compare: Compare) -> (Element, Self) {
//        switch self {
//        case .empty:
//            fatalError()
//
//        case let .node(.empty, element, _, .empty):
//            return (element, .empty)
//
//        case let .node(left, element, size, right) where left.size < right.size:
//            let (b, newRight) = right.removeBottom(compare)
//            return (b, .node(left, element: element, size: size-1, newRight))
//
//        case let .node(left, element, size, right):
//            let (b, newLeft) = left.removeBottom(compare)
//            return (b, .node(newLeft, element: element, size: size-1, right))
//        }
//    }
//
//    private static func merge(_ element: Element, _ lhs: Self, _ rhs: Self, _ compare: Compare) -> Self {
//        switch (lhs, rhs) {
//        case (.empty, .empty):
//            return singleTon(element)
//
//        case (.empty, _):
//            return rhs.inserted(element, compare: compare)
//
//        case (_, .empty):
//            return lhs.inserted(element, compare: compare)
//
//        case (let .node(ll, le, ls, lr), let .node(rl, re, rs, rr)):
//            let newSize = ls + rs + 1
//            return compare(element, le) && compare(element, re) ? .node(lhs, element: element, size: newSize, rhs)
//                :  compare(le, element) && compare(le, re) ? .node(merge(ll, lr, with: element), element: le, size: newSize, rhs)
//                : .node(lhs, element: re, size: newSize, merge(rl, rr, with: element))
//        }
//    }
//}


public enum MinHeap<Element: Comparable> {
    
    case empty
    indirect case node(_ left: Self, element: Element, size: Int, _ right: Self)
}


extension MinHeap {
    
    public var size: Int {
        switch self {
        case .empty: return 0
        case let .node(_, _, size, _): return size
        }
    }
    
    public var isEmpty: Bool {
        guard case .empty = self else { return false }
        return true
    }
    
    public var top: Element? {
        guard case let .node(_, element, _, _) = self else { return nil }
        return element
    }
    
    private static func singleTon(_ element: Element) -> Self {
        return .node(.empty, element: element, size: 1, .empty)
    }
}


// MARK: - insert value

extension MinHeap {
    
    public func inserted(_ new: Element) -> Self {
        switch self {
        case .empty:
            return Self.singleTon(new)
            
        case let .node(left, element, size, right) where new < element:
            return left.size > right.size && left.size % 2 != 0
                ?  .node(left, element: new, size: size+1, right.inserted(element))
                : .node(left.inserted(element), element: new, size: size+1, right)
            
        case let .node(left, element, size, right):
            return left.size > right.size && left.size % 2 != 0
                ? .node(left, element: element, size: size+1, right.inserted(new))
                : .node(left.inserted(new), element: element, size: size+1, right)
        }
    }
}


// MARK: - merge heap

extension MinHeap {
    
    static func merge(_ lhs: Self, _ rhs: Self, with element: Element) -> Self {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return singleTon(element)
            
        case (.empty, _):
            return rhs.inserted(element)
            
        case (_, .empty):
            return lhs.inserted(element)
            
        case (let .node(ll, le, ls, lr), let .node(rl, re, rs, rr)):
            let newSize = ls + rs + 1
            return element <= le && element <= re ? .node(lhs, element: element, size: newSize, rhs)
                :  le <= element && le <= re ? .node(merge(ll, lr, with: element), element: le, size: newSize, rhs)
                : .node(lhs, element: re, size: newSize, merge(rl, rr, with: element))
        }
    }
}


// MARK: - delete first

extension MinHeap {
    
    private func deleteBottom() -> (Element, Self) {
        switch self {
        case .empty:
            fatalError()
            
        case let .node(.empty, element, _, .empty):
            return (element, .empty)
            
        case let .node(left, element, size, right) where left.size < right.size:
            let (b, newRight) = right.deleteBottom()
            return (b, .node(left, element: element, size: size-1, newRight))
            
        case let .node(leaf, element, size, right):
            let (b, newLeft) = leaf.deleteBottom()
            return (b, .node(newLeft, element: element, size: size-1, right))
        }
    }
    
    public func deleteTop() -> (Element, Self) {
        switch self {
        case .empty:
            fatalError()
            
        case let .node(.empty, element, _, .empty):
            return (element, .empty)
            
        case let .node(left, element, _, right) where left.size > right.size:
            let (lb, newleft) = left.deleteBottom()
            return (element, Self.merge(newleft, right, with: lb))
            
        case let .node(left, element, _, right):
            let (rb, newRight) = right.deleteBottom()
            return (element, Self.merge(left, newRight, with: rb))
        }
    }
}
