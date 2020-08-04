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
        
        stack.stackable.add([
            "Hello"
                .aligned(.right)
                .inset(by: .init(top: 20, left: 0, bottom: 0, right: 10)),
            UIStackView.stackable.hairline,
            20,
            "World",
            UIStackView.stackable.flexibleSpace,
        ])
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }

}

