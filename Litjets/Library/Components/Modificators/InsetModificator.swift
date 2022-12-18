//
//  InsetModificator.swift
//  Litjets
//
//  Created by Roman Aleksandrov on 17.12.2022.
//

import UIKit

extension Component {
    func insets(_ edgeInsets: UIEdgeInsets) -> any Component {
        InsetsComponent(edgeInsets, component: self)
    }
    
    func insetX(_ value: CGFloat) -> any Component {
        InsetsComponent(.init(top: 0, left: value, bottom: 0, right: 0), component: self)
    }
    
    func insetY(_ value: CGFloat) -> any Component {
        InsetsComponent(.init(top: value, left: 0, bottom: 0, right: 0), component: self)
    }
}

public final class InsetsComponent: Component {
    public var state: UIEdgeInsets
    
    private let component: any Component
    
    init(_ state: UIEdgeInsets,
         component: any Component) {
        self.state = state
        self.component = component
    }
    
    @discardableResult
    public func prerender(in context: RenderContext) -> ResultLayout {
        let result = component.prerender(in: context)
        result.node.frame = .init(origin: modificateOrigin(result.node.frame.origin, with: state),
                                  size: result.node.frame.size)
        return result
    }
    
    public func applyLayout() -> UIView? {
        component.applyLayout()
    }
    
    private func modificateOrigin(_ origin: CGPoint, with insets: UIEdgeInsets) -> CGPoint {
        .init(x: origin.x + insets.left - insets.right, y: origin.y + insets.top - insets.bottom)
    }
}

extension UIEdgeInsets: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(top)
        hasher.combine(left)
        hasher.combine(bottom)
        hasher.combine(right)
    }
}
