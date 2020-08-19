//
//  LogoViewController.swift
//  Stackable_Example
//
//  Created by Jason Clark on 8/19/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Stackable

class LogoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let logo = LogoView()
        view.addSubview(logo)
        
        NSLayoutConstraint.activate([
            logo.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            logo.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            logo.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            logo.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
}

class LogoView: UIView {
        
    lazy var sTextImageView: UIImageView = {
        let imageView = UIImageView(image: .init(asset: .sText))
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return imageView
    }()
    
    lazy var addImageView: UIImageView = {
        let imageView = UIImageView(image: .init(asset: .add))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var locationImageView: UIImageView = {
        let imageView = UIImageView(image: .init(asset: .location))
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return imageView
    }()
    
    lazy var progressRingsImageView: UIImageView = {
        let imageView = UIImageView(image: .init(asset: .progressRings))
       imageView.contentMode = .scaleAspectFit
       imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
       return imageView
    }()
    
    lazy var backImageView: UIImageView = {
        let imageView = UIImageView(image: .init(asset: .back))
       imageView.contentMode = .scaleAspectFit
       imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
       return imageView
    }()
    
    lazy var appStoreImageView: UIImageView = {
        let imageView = UIImageView(image: .init(asset: .appStore))
       imageView.contentMode = .scaleAspectFit
       imageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
       return imageView
    }()
    
    lazy var bluetoothImageView: UIImageView = {
        let imageView = UIImageView(image: .init(asset: .bluetooth))
       imageView.contentMode = .scaleAspectFit
       imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
       return imageView
    }()
    
    lazy var numberOneImageView: UIImageView = {
        let imageView = UIImageView(image: .init(asset: .numberOne))
       imageView.contentMode = .scaleAspectFit
       imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
       return imageView
    }()
    
    lazy var listIconImageView: UIImageView = {
        let imageView = UIImageView(image: .init(asset: .list))
       imageView.contentMode = .scaleAspectFit
       imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
       return imageView
    }()
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        applyConstraints()
        configureLayout()
    }
    
    func configureLayout() {
        let firstRow = UIStackView()
        firstRow.heightAnchor.constraint(equalToConstant: 100).isActive = true
        firstRow.axis = .horizontal
        firstRow.stackable.add([
            sTextImageView,
            20,
            addImageView
                .aligned(.top)
                .inset(by: .init(top: 10, left: 10, bottom: 10, right: 10)),
            20,
            locationImageView
                .aligned(.centerY),
            20,
            progressRingsImageView
                .aligned(.centerY),
            20,
            backImageView
                .aligned(.centerY),
        ])
        
        let secondRow = UIStackView()
        secondRow.heightAnchor.constraint(equalToConstant: 100).isActive = true
        secondRow.axis = .horizontal
        secondRow.stackable.add([
            UIStackView.stackable.flexibleSpace,
            appStoreImageView,
            20,
            bluetoothImageView,
            20,
            numberOneImageView,
            20,
            listIconImageView
                .aligned(.centerY),
        ])
        
        stack.stackable.add([
            firstRow,
            20,
            secondRow,
        ])
        
        stack.stackable.debug.showSpaces()
        stack.stackable.debug.showOutlines()
    }
        
    func applyConstraints() {
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leadingAnchor),
            stack.topAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.topAnchor),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.bottomAnchor),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
            stack.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor),
        ])
        
        let lowPriorityFillConstraints = [
            stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ]
        lowPriorityFillConstraints.forEach {
            $0.priority = .defaultLow
        }
        NSLayoutConstraint.activate(lowPriorityFillConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
