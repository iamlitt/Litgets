//
//  ViewController.swift
//  Components
//
//  Created by Roman Aleksandrov on 12.12.2022.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vStack = VStack(state: .init(spacing: 8, alignment: .leading)) {
            
            HStack(state: .init(spacing: 12, alignment: .center)) {
                Image(state: .init(imageStringType: .system("figure.cricket"),
                                   contentMode: .scaleAspectFit))
                .concreteSize(.init(width: 25, height: 25))
                Text(state: .init(text: "SwiftUI",
                                  font: .systemFont(ofSize: 20)))
                Text(state: .init(text: "SUCKS!",
                                  font: .systemFont(ofSize: 50)))
            }
            
            Text(state: .init(text: "Hello!",
                              font: .systemFont(ofSize: 20)))
            
            Spacer(state: .init(space: 10))
            
            Image(state: .init(imageStringType: .system("figure.cricket"),
                               contentMode: .scaleAspectFit))
            .concreteSize(.init(width: 100, height: 100))
            .insetTop(20)
            
            Text(state: .init(text: "It's me!",
                              font: .systemFont(ofSize: 50)))
        }.insetLeft(12).insetTop(50).insetRight(12)
        
        vStack.prerender(in: .init(size: self.view.bounds.size, renderType: .sizeToFit))
        if let resultView = vStack.applyLayout() {
            view.addSubview(resultView)
        }
    }
}

