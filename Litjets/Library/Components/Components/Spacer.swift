//
//  Spacer.swift
//  Litjets
//
//  Created by Roman Aleksandrov on 17.12.2022.
//

import UIKit

final class Spacer: Component {
    
    var state: State
    
    private lazy var node: Node = Node(frame: .zero)
    
    public init(state: State) {
        self.state = state
    }
    
    @discardableResult
    func prerender(in context: RenderContext) -> ResultLayout {
        node.frame = .init(origin: .zero, size: .init(width: state.space, height: state.space))
        node.component = self
        return .init(node: node)
    }
    
    func applyLayout() -> UIView? {
        nil
    }
}

extension Spacer {
    public struct State: Hashable {
        let space: CGFloat
        
        public init(space: CGFloat) {
            self.space = space
        }
    }
}
