//
//  HStack.swift
//  Litjets
//
//  Created by Roman Aleksandrov on 18.12.2022.
//

import UIKit

public final class HStack: Component {
    public var state: HStackState
    
    var components: [any Component]
    
    init(state: HStackState, @StackBuilder components: () -> [any Component]) {
        self.state = state
        self.components = components()
    }
    
    private lazy var containerView = UIView()
    
    private lazy var node: Node = Node(frame: .zero)
    
    @discardableResult
    public func prerender(in context: RenderContext) -> ResultLayout {
        let size = applyConstraints(with: context)
        var iterativeRenderContext = RenderContext(size: size, constraints: context.constraints)
        var xCoordinate: CGFloat = 0
        var childNodes: [Node] = []
        var maxHeight: CGFloat = 0
        childNodes.reserveCapacity(components.count)
        let count = components.count
        
        components.enumerated().forEach { (offset, component) in
            let childNode = component.prerender(in: iterativeRenderContext).node
            
            childNode.frame = .init(origin: .init(x: xCoordinate,
                                                  y: calculateYOffset(for: childNode, maxHeight: context.size.height)),
                                    size: childNode.frame.size)
            childNodes.append(childNode)
            xCoordinate = childNode.frame.maxX + (offset == count - 1 ? 0 : state.spacing)
            maxHeight = max(maxHeight, childNode.frame.size.height)
            node.addSubnode(node)
            // TO THINK: is need to stop rendering when max height is reached in previous iteration?
            iterativeRenderContext = .init(size: .init(width: max(0, size.width - xCoordinate), height: size.height), constraints: nil)
        }
        
        // ПРОДУМАТЬ МЕХАНИЗМ ЕСЛИ У СТЕКА НЕТУ ОГРАНИЧЕНИЙ В ШИРИНУ
        
        node.frame = .init(origin: .zero,
                           size: .init(width: xCoordinate, height: min(size.height, maxHeight)))
        node.component = self
        return .init(node: node)
    }
    
    public func applyLayout() -> UIView? {
        components.forEach {
            if let view = $0.applyLayout() { containerView.addSubview(view) }
        }
        containerView.frame = node.frame
        return containerView
    }
    
    private func calculateYOffset(for childNode: Node, maxHeight: CGFloat) -> CGFloat {
        let baseNodeOffset = childNode.frame.origin.y
        switch state.alignment {
        case .leading:
            return 0 + baseNodeOffset
        case .center:
            return (maxHeight - childNode.frame.height) / 2 + baseNodeOffset
        case .trailing:
            return maxHeight - childNode.frame.height + baseNodeOffset
        }
    }
}

// MARK: - State
extension HStack {
    public struct HStackState: Hashable {
        public enum VerticalAlignment {
            case leading
            case trailing
            case center
        }
        let spacing: CGFloat
        let alignment: VerticalAlignment
        
        public init(spacing: CGFloat, alignment: VerticalAlignment) {
            self.spacing = spacing
            self.alignment = alignment
        }
    }
}
