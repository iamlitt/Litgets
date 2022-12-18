//
//  VStack.swift
//  Components
//
//  Created by Roman Aleksandrov on 13.12.2022.
//

import UIKit

public final class VStack: Component {
    public var state: VStackState
    
    var components: [any Component]
    
    init(state: VStackState, @StackBuilder components: () -> [any Component]) {
        self.state = state
        self.components = components()
    }
    
    private lazy var containerView = UIView()
    
    private lazy var node: Node = Node(frame: .zero)
    
    @discardableResult
    public func prerender(in context: RenderContext) -> ResultLayout {
        let size = applyConstraints(with: context)
        var iterativeRenderContext = RenderContext(size: size, constraints: context.constraints)
        var yCoordinate: CGFloat = 0
        var childNodes: [Node] = []
        childNodes.reserveCapacity(components.count)
        let count = components.count
        
        components.enumerated().forEach { (offset, component) in
            let childNode = component.prerender(in: iterativeRenderContext).node
            
            childNode.frame = .init(origin: .init(x: calculateXOffset(for: childNode, maxWidth: context.size.width),
                                                  y: yCoordinate),
                                    size: childNode.frame.size)
            childNodes.append(childNode)
            yCoordinate = childNode.frame.maxY + (offset == count - 1 ? 0 : state.spacing)
            node.addSubnode(node)
            // TO THINK: is need to stop rendering when max height is reached in previous iteration?
            iterativeRenderContext = .init(size: .init(width: size.width, height: max(0, size.height - yCoordinate)), constraints: nil)
        }
        
        node.frame = .init(origin: .zero,
                           size: .init(width: size.width, height: yCoordinate))
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
    
    private func calculateXOffset(for childNode: Node, maxWidth: CGFloat) -> CGFloat {
        let baseNodeOffset = childNode.frame.origin.x
        switch state.alignment {
        case .leading:
            return 0 + baseNodeOffset
        case .center:
            return (maxWidth - childNode.frame.width) / 2 + baseNodeOffset
        case .trailing:
            return maxWidth - childNode.frame.width + baseNodeOffset
        }
    }
}

// MARK: - State
extension VStack {
    public struct VStackState: Hashable {
        public enum HorizontalAlignment {
            case leading
            case trailing
            case center
        }
        let spacing: CGFloat
        let alignment: HorizontalAlignment
        
        public init(spacing: CGFloat, alignment: HorizontalAlignment) {
            self.spacing = spacing
            self.alignment = alignment
        }
    }
}
