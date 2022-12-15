//
//  SizeModificator.swift
//  Components
//
//  Created by Roman Aleksandrov on 13.12.2022.
//

import UIKit

extension Component {
    func concreteSize(_ size: CGSize) -> any Component {
        ConcreteSizeComponent(size, component: self)
    }
}

public final class ConcreteSizeComponent: Component {
    public var state: CGSize
    
    private let component: any Component
    
    init(_ size: CGSize, component: any Component) {
        self.state = size
        self.component = component
    }
    
    @discardableResult
    public func prerender(in context: RenderContext) -> ResultLayout {
        let minSize = CGSize(width: min(context.size.width, state.width),
                             height: min(context.size.height, state.height))
        let result = component.prerender(in: .init(size: minSize,
                                                   constraints: context.constraints))
        result.node.frame = .init(origin: result.node.frame.origin, size: minSize)
        return result
    }
    
    public func applyLayout() -> UIView {
        component.applyLayout()
    }
}

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}
