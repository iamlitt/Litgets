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
        
        let vStack = VStack(state: .init(spacing: 8, alignment: .center)) {
                Text(state: .init(text: "Hello!",
                                  font: .systemFont(ofSize: 20)))
            
                Image(state: .init(imageStringType: .system("figure.cricket"),
                                   contentMode: .scaleAspectFit))
                .concreteSize(.init(width: 100, height: 100))
            
            
                Text(state: .init(text: "It's me!",
                                  font: .systemFont(ofSize: 50)))
        }
        
        vStack.prerender(in: .init(size: self.view.bounds.size))
        let resultView = vStack.applyLayout()
        
        resultView.frame = .init(origin: .init(x: 0, y: 50), size: resultView.frame.size)
        view.addSubview(resultView)
    }
}

