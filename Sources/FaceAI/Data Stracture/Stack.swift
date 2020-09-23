//
//  Stack.swift
//  
//
//  Created by amir.lahav on 22/09/2020.
//

import Foundation

public struct Stack<Element> {
    
    private var array: [Element] = []
    
    mutating func push(_ element: Element) {
        array.append(element)
    }
    
    mutating func pop() -> Element? {
        return array.popLast()
    }
    
    func peek() -> Element? {
        return array.last
    }
    
    func isEmpty() -> Bool {
        return array.isEmpty
    }
}
