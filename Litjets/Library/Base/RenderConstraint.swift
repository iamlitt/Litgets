//
//  RenderConstraint.swift
//  
//
//  Created by Roman Aleksandrov on 30.11.2022.
//

import Foundation

public protocol RenderConstraint {
    func modifySize(_ size: CGSize) -> CGSize
}

public struct ConcreteSizeConstraint: RenderConstraint {
    let width: CGFloat
    let height: CGFloat
    
    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    public func modifySize(_ size: CGSize) -> CGSize {
        .init(width: width, height: height)
    }
}

public struct ConcreteWidthConstraint: RenderConstraint {
    let width: CGFloat
    
    public init(width: CGFloat) {
        self.width = width
    }
    
    public func modifySize(_ size: CGSize) -> CGSize {
        .init(width: width, height: size.height)
    }
}

public struct ConcreteHeightConstraint: RenderConstraint {
    let height: CGFloat
    
    public init(height: CGFloat) {
        self.height = height
    }
    
    public func modifySize(_ size: CGSize) -> CGSize {
        .init(width: size.width, height: height)
    }
}

public struct MinDimensionsConstraint: RenderConstraint {
    let minWidth: CGFloat?
    let minHeight: CGFloat?
    
    public init(minWidth: CGFloat?, minHeight: CGFloat?) {
        self.minWidth = minWidth
        self.minHeight = minHeight
    }
    
    public func modifySize(_ size: CGSize) -> CGSize {
        .init(width: min(size.width, minWidth ?? size.width), height: min(size.height, minHeight ?? size.height))
    }
}

public struct MaxDimensionsConstraint: RenderConstraint {
    let maxWidth: CGFloat?
    let maxHeight: CGFloat?
    
    public init(maxWidth: CGFloat?, maxHeight: CGFloat?) {
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }
    
    public func modifySize(_ size: CGSize) -> CGSize {
        .init(width: max(size.width, maxWidth ?? size.width), height: max(size.height, maxHeight ?? size.height))
    }
}
