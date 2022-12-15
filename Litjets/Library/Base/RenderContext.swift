//
//  RenderContext.swift
//  
//
//  Created by Roman Aleksandrov on 29.11.2022.
//

import Foundation

public struct RenderContext {
    public let size: CGSize
    public let constraints: RenderConstraint?
    
    public init(size: CGSize, constraints: RenderConstraint? = nil) {
        self.size = size
        self.constraints = constraints
    }
}
