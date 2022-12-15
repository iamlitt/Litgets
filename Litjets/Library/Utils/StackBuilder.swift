//
//  StackBuilder.swift
//  Components
//
//  Created by Roman Aleksandrov on 13.12.2022.
//

import Foundation

@resultBuilder
public struct StackBuilder {
    
//    static func buildBlock(_ components: any Component...) -> [any Component] {
//        return components.flatMap { $0 }
//    }
//
//    static func buildOptional(_ component: [any Component]?) -> [any Component] {
//        return component?.flatMap { $0 } ?? []
//    }
//
//    static func buildEither(first component: [any Component]) -> [any Component] {
//        return component.flatMap { $0 }
//    }
//
//    static func buildEither(second component: [any Component]) -> [any Component] {
//        return component.flatMap { $0 }
//    }
//
//    static func buildExpression(_ component: any Component) -> [any Component] {
//        return [component]
//    }
    
    static func buildBlock(_ components: [any Component]...) -> [any Component] {
        components.flatMap { $0 }
    }
    
    /// Add support for both single and collections of constraints.
    static func buildExpression(_ expression: any Component) -> [any Component] {
        [expression]
    }
    
    static func buildExpression(_ expression: [any Component]) -> [any Component] {
        expression
    }
    
    /// Add support for optionals.
    static func buildOptional(_ components: [any Component]?) -> [any Component] {
        components ?? []
    }
    
    /// Add support for if statements.
    static func buildEither(first components: [any Component]) -> [any Component] {
        components
    }
    
    static func buildEither(second components: [any Component]) -> [any Component] {
        components
    }
}
