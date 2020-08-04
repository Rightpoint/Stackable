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

        let label = UILabel()
        label.text = "hello"
        
        let stack = UIStackView()
        stack.axis = .vertical
        
        stack.stackable.add([
            label
                .aligned(.centerX),
            UIStackView.stackable.hairline,
            ...40,
            "World",
        ])
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }

}

