//
//  File.swift
//  
//
//  Created by Roman Aleksandrov on 30.11.2022.
//

import Foundation

public final class Node {
    var frame: CGRect
    var supernode: Node?
    var subnodes: [Node]
    
    // from 1 to 100
    var priority: Int
    var component: (any Component)?
    
    init(frame: CGRect) {
        self.frame = frame
        self.supernode = nil
        self.subnodes = []
        self.priority = 50
    }
    
    public func addSubnode(_ node: Node) {
        node.supernode = self
        subnodes.append(node)
    }
    
    public func subnodeSizeChange(_ subnode: Node) {
        
    }
}
