//
//  File.swift
//  
//
//  Created by Roman Aleksandrov on 29.11.2022.
//

import UIKit

public class Text: Component {
    public var state: TextState
    
    public init(state: TextState) {
        self.state = state
    }
    
    private lazy var node: Node = Node(frame: .zero)
       
    @discardableResult
    public func prerender(in context: RenderContext) -> ResultLayout {
        let size: CGSize
        if let constraints = context.constraints {
            size = constraints.modifySize(context.size)
        } else {
            size = context.size
        }
        let heightForText = state.text.height(withWidth: size.width, font: state.font)
        let widthForText = state.text.width(withHeight: heightForText, font: state.font)
        node.frame = .init(origin: .zero,
                           size: .init(width: min(size.width, widthForText),
                                       height: min(size.height, heightForText)))
        return .init(node: node)
    }
    
    private lazy var label: UILabel = UILabel()
    
    public func applyLayout() -> UIView {
        label.frame = node.frame
        label.text = state.text
        label.font = state.font
        return label
    }
}

// MARK: - State
extension Text {
    public struct TextState: Hashable {
        let text: String
        let font: UIFont
        
        init(text: String, font: UIFont) {
            self.text = text
            self.font = font
        }
    }
}
                    
extension String {
    
    static var metricCache: [String: CGFloat] = [:]
    static var metricSizeCache: [String: CGSize] = [:]
    
    func height(withWidth width: CGFloat, font: UIFont) -> CGFloat {
        let key = self + "height" + "forWidth" + String(Float(width)) + font.description
        
        if let cachedHeight = String.metricCache[key] {
            return cachedHeight
        } else {
            let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
            let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font : font], context: nil)
            let height = actualSize.integral.height
            String.metricCache[key] = height
            return actualSize.height
        }
    }
    
    func width(withHeight height: CGFloat, font: UIFont) -> CGFloat {
        let key = self + "width" + "forHeight" + String(Float(height)) + font.description
        
        if let cachedWidth = String.metricCache[key] {
            return cachedWidth
        } else {
            let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
            let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font : font], context: nil)
            let width = actualSize.integral.width
            String.metricCache[key] = width
            return width
        }
    }
    
    func threeStepsFrameCalculation(font: UIFont) -> CGSize {
        let key = self + "size" + "Font" + font.description
        
        if let cachedSize = String.metricSizeCache[key] {
            return cachedSize
        } else {
            let width1 = self.width(withHeight: 999, font: font)
            let height = self.height(withWidth: width1, font: font)
            let width = self.width(withHeight: height, font: font)
            let size = CGSize(width: width, height: height)
            String.metricSizeCache[key] = size
            return size
        }
    }
}
