//
//  File.swift
//  
//
//  Created by Roman Aleksandrov on 30.11.2022.
//

import UIKit

public protocol Component: AnyObject {
    associatedtype State: Hashable
    
    // frame calculations
    @discardableResult
    func prerender(in context: RenderContext) -> ResultLayout
    
    // fill real view
    func applyLayout() -> UIView?
    
    var state: State { get }
}

extension Component {
    func applyConstraints(with renderContext: RenderContext) -> CGSize {
        let size: CGSize
        if let constraints = renderContext.constraints {
            size = constraints.modifySize(renderContext.size)
        } else {
            size = renderContext.size
        }
        return size
    }
}

extension Component {
    func asAny() -> any Component {
        self
    }
}
