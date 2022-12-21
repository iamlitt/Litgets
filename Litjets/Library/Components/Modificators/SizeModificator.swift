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
        let result = component.prerender(in: .init(size: state,
                                                   constraints: context.constraints,
                                                   renderType: .sizeToFill))
        result.node.frame = .init(origin: result.node.frame.origin, size: state)
        return result
    }
    
    public func applyLayout() -> UIView? {
        component.applyLayout()
    }
}

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}
