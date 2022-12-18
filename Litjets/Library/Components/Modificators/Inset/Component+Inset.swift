//
//  Component+Inset.swift
//  Litjets
//
//  Created by Roman Aleksandrov on 18.12.2022.
//

import Foundation

extension Component {
    func insets(_ insets: Insets) -> InsetsComponent {
        InsetsComponent(insets, component: self)
    }
    
    func insetLeft(_ value: CGFloat) -> InsetsComponent {
        InsetsComponent(.init(top: nil, left: value, bottom: nil, right: nil), component: self)
    }
    
    func insetRight(_ value: CGFloat) -> InsetsComponent {
        InsetsComponent(.init(top: nil, left: nil, bottom: nil, right: value), component: self)
    }
    
    func insetBottom(_ value: CGFloat) -> InsetsComponent {
        InsetsComponent(.init(top: nil, left: nil, bottom: value, right: nil), component: self)
    }
    
    func insetTop(_ value: CGFloat) -> InsetsComponent {
        InsetsComponent(.init(top: value, left: nil, bottom: nil, right: nil), component: self)
    }
    
    func insetVertical(_ value: CGFloat) -> InsetsComponent {
        InsetsComponent(.init(top: value, left: nil, bottom: value, right: nil), component: self)
    }
    
    func insetHorizontal(_ value: CGFloat) -> InsetsComponent {
        InsetsComponent(.init(top: nil, left: value, bottom: nil, right: value), component: self)
    }
}
