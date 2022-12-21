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
    public let renderType: RenderType
    
    public init(size: CGSize, constraints: RenderConstraint? = nil, renderType: RenderType) {
        self.size = size
        self.constraints = constraints
        self.renderType = renderType
    }
}

public enum RenderType {
    case sizeToFill
    case sizeToFit
}
