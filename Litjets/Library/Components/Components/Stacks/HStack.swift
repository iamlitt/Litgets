//
//  HStack.swift
//  Litjets
//
//  Created by Roman Aleksandrov on 18.12.2022.
//

import UIKit

// TODO: Implement priorities mechanism
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
        var iterativeRenderContext = RenderContext(size: size, constraints: context.constraints, renderType: .sizeToFit)
        var xCoordinate: CGFloat = 0
        var childNodes: [Node] = []
        var maxHeight: CGFloat = 0
        childNodes.reserveCapacity(components.count)
        let count = components.count
        
        components.enumerated().forEach { (offset, component) in
            let childNode = component.prerender(in: iterativeRenderContext).node
            
            childNode.frame = .init(origin: .init(x: xCoordinate,
                                                  y: calculateYOffset(for: childNode,
                                                                      maxHeight: context.size.height,
                                                                      baseOffset: childNode.frame.origin.y
)),
                                    size: childNode.frame.size)
            childNodes.append(childNode)
            xCoordinate = childNode.frame.maxX + (offset == count - 1 ? 0 : state.spacing)
            maxHeight = max(maxHeight, childNode.frame.size.height)
            node.addSubnode(childNode)
            // TO THINK: is need to stop rendering when max height is reached in previous iteration?
            iterativeRenderContext = .init(size: .init(width: max(0, size.width - xCoordinate),
                                                       height: size.height),
                                           constraints: nil,
                                           renderType: iterativeRenderContext.renderType)
        }
        
        if state.alignment != .top {
            node.subnodes.forEach {
                let newY = calculateYOffset(for: $0,
                                            maxHeight: min(size.height,
                                                           maxHeight),
                                            baseOffset: 0)
                print(newY)
                $0.frame = .init(origin: .init(x: $0.frame.origin.x,
                                               y: newY),
                                 size: $0.frame.size)
            }
        }
        switch context.renderType {
        case .sizeToFill:
            node.frame = .init(origin: .zero,
                               size: size)
        case .sizeToFit:
            node.frame = .init(origin: .zero,
                               size: .init(width: xCoordinate, height: min(size.height, maxHeight)))
        }
                
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
 
    private func calculateYOffset(for childNode: Node, maxHeight: CGFloat, baseOffset: CGFloat) -> CGFloat {
        switch state.alignment {
        case .top:
            return 0 + baseOffset
        case .center:
            return (maxHeight - childNode.frame.height) / 2 + baseOffset
        case .bottom:
            return maxHeight - childNode.frame.height + baseOffset
        }
    }
}

// MARK: - State
extension HStack {
    public struct HStackState: Hashable {
        public enum VerticalAlignment {
            case top
            case center
            case bottom
        }
        let spacing: CGFloat
        let alignment: VerticalAlignment
        
        public init(spacing: CGFloat, alignment: VerticalAlignment) {
            self.spacing = spacing
            self.alignment = alignment
        }
    }
}
