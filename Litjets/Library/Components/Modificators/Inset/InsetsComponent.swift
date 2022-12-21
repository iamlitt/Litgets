//
//  InsetModificator.swift
//  Litjets
//
//  Created by Roman Aleksandrov on 17.12.2022.
//

import UIKit

public final class InsetsComponent: Component {
    public var state: Insets
    
    private let component: any Component
    
    init(_ state: Insets,
         component: any Component) {
        self.state = state
        self.component = component
    }
    
    @discardableResult
    public func prerender(in context: RenderContext) -> ResultLayout {
        let newContextSize: CGSize = .init(width: context.size.width - (state.left ?? 0) - (state.right ?? 0),
                                           height: context.size.height - (state.top ?? 0) - (state.bottom ?? 0))
        let newContext = RenderContext(size: newContextSize, constraints: context.constraints, renderType: context.renderType)
        let result = component.prerender(in: newContext)
        result.node.frame = modificateFrame(result.node.frame,
                                            insets: state,
                                            context: newContext)
        return result
    }
    
    public func applyLayout() -> UIView? {
        component.applyLayout()
    }
    
    private func modificateFrame(_ frame: CGRect, insets: Insets, context: RenderContext) -> CGRect {
        var origin = frame.origin
        var size = frame.size
        
        // yeah, here some things to optimize. make it in one operation
        // apply top
        if let top = insets.top {
            origin = .init(x: origin.x, y: origin.y + top)
        }
        
        // apply left
        if let left = insets.left {
            origin = .init(x: origin.x + left, y: origin.y)
        }
        
        // apply bottom
        if let bottom = insets.bottom {
            let isTopInsetSetted = insets.top != nil
            origin = isTopInsetSetted ? origin : .init(x: origin.x, y: context.size.height - size.height - bottom)
        }
        
        // apply right
        if let right = insets.right {
            let isLeftInsetSetted = insets.left != nil
            origin = isLeftInsetSetted ? origin : .init(x: context.size.width - size.width - right, y: origin.y)
        }
        
        
        return .init(origin: origin, size: size)
    }
}

extension InsetsComponent  {
    func insetTop(_ value: CGFloat) -> InsetsComponent {
        self.state.top = value
        return self
    }
    
    func insetLeft(_ value: CGFloat) -> InsetsComponent {
        self.state.left = value
        return self
    }
    
    func insetBottom(_ value: CGFloat) -> InsetsComponent {
        self.state.bottom = value
        return self
    }
    
    func insetRight(_ value: CGFloat) -> InsetsComponent {
        self.state.right = value
        return self
    }
    
    func insetHorizontal(_ value: CGFloat) -> InsetsComponent {
        self.state.right = value
        self.state.left = value
        return self
    }
    
    func insetVertical(_ value: CGFloat) -> InsetsComponent {
        self.state.top = value
        self.state.bottom = value
        return self
    }
}
