//
//  Insets.swift
//  Litjets
//
//  Created by Roman Aleksandrov on 18.12.2022.
//

import Foundation

public struct Insets {
    var top: CGFloat?
    var left: CGFloat?
    var bottom: CGFloat?
    var right: CGFloat?
}

extension Insets: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(top)
        hasher.combine(left)
        hasher.combine(bottom)
        hasher.combine(right)
    }
}
