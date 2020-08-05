//
//  ViewController.swift
//  Stackable
//
//  Created by Jay Clark on 07/30/2020.
//  Copyright (c) 2020 Rightpoint. All rights reserved.
//

import UIKit
import Stackable

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let stack = UIStackView()
        stack.axis = .vertical
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.stackable.hairlineProvider = { _ in
            let custom = UIView()
            custom.heightAnchor.constraint(equalToConstant: 10.0).isActive = true
            custom.backgroundColor = .cyan
            return custom
        }
        
        let hello = UILabel()
        hello.text = "Hello"
        
        let world = UILabel()
        world.text = "World"
        
        stack.stackable.add([
            [hello, world]
                .aligned(.right),
            UIStackView.stackable.hairline
                .outset(to: view),
            UIStackView.stackable.flexibleSpace,
            "Jonas",
            20,
        ])
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }

}
