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
        let result = component.prerender(in: context)
        result.node.frame = modificateFrame(result.node.frame, insets: state, context: context)
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
            let addTopNewHeight = origin.y + size.height
            if addTopNewHeight > context.size.height {
                size = .init(width: size.width, height: context.size.height - top)
            }
        }
        
        // apply left
        if let left = insets.left {
            origin = .init(x: origin.x + left, y: origin.y)
            let addLeftNewWidth = origin.x + size.width
            if addLeftNewWidth > context.size.width {
                size = .init(width: context.size.width - left, height: size.height)
            }
        }
        
        // apply bottom
        if let bottom = insets.bottom {
            let isTopInsetSetted = insets.top != nil
            origin = isTopInsetSetted ? origin : .init(x: origin.x, y: context.size.height - size.height - bottom)
            if isTopInsetSetted {
                size = .init(width: size.width, height: context.size.height - bottom - (insets.top ?? 0))
            } else {
                let addBottomHeight = origin.y + size.height
                if addBottomHeight > context.size.height {
                    size = .init(width: size.width, height: context.size.height - bottom)
                }
            }
        }
        
        // apply right
        if let right = insets.right {
            let isLeftInsetSetted = insets.left != nil
            origin = isLeftInsetSetted ? origin : .init(x: context.size.width - size.width - right, y: origin.y)
            if isLeftInsetSetted {
                size = .init(width: context.size.width - right - (insets.left ?? 0), height: size.height)
            } else {
                let addRightWidth = origin.x + size.width
                if addRightWidth > context.size.width {
                    size = .init(width: context.size.width - right, height: size.height)
                }
            }
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
