//
//  ImageComponent.swift
//  Components
//
//  Created by Roman Aleksandrov on 13.12.2022.
//

import UIKit

public class Image: Component {
    public var state: ImageState
    
    public init(state: ImageState) {
        self.state = state
    }
    
    private lazy var node: Node = Node(frame: .zero)
       
    @discardableResult
    public func prerender(in context: RenderContext) -> ResultLayout {
        let size = applyConstraints(with: context)
        node.frame = .init(origin: .zero,
                           size: size)
        return .init(node: node)
    }
    
    private lazy var imageView: UIImageView = UIImageView()
    
    public func applyLayout() -> UIView {
        let image: UIImage?
        switch state.imageStringType {
        case .asset(let assetString):
            image = UIImage(named: assetString)
        case .system(let systemString):
            image = UIImage(systemName: systemString)
        }
        imageView.image = image
        imageView.contentMode = state.contentMode
        imageView.frame = node.frame
        return imageView
    }
}

// MARK: - State
extension Image {
    public struct ImageState: Hashable {
        public typealias ContentMode = UIView.ContentMode
        public enum SourceType: Hashable {
            case system(String)
            case asset(String)
        }
        
        let imageStringType: SourceType
        let contentMode: ContentMode
        
        public init(imageStringType: SourceType,
                    contentMode: ContentMode) {
            self.imageStringType = imageStringType
            self.contentMode = contentMode
        }
    }
}
