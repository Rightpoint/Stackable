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
        
        let hello = UILabel()
        hello.text = "Hello"
        
        let world = UILabel()
        world.text = "World"
        
        stack.stackable.add([
            hello
                .aligned(.right)
                .inset(by: .init(top: 0, left: 0, bottom: 0, right: 20)),
            20,
            world,
            UIStackView.stackable.flexibleSpace,
        ])
        
        stack.stackable.add([
            UIStackView.stackable.hairlines(after: [hello, world])
                .outset(to: view)
                .color(.red),
        ])
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }

}
