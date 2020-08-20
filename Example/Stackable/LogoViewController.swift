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
        
        title = "Stackable Logo"
        
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
        
    let sTextImageView = ImageView(.sText)
    let addImageView = ImageView(.add)
    let locationImageView = ImageView(.location)
    let progressRingsImageView = ImageView(.progressRings)
    let backImageView = ImageView(.back)
    let appStoreImageView = ImageView(.appStore)
    let bluetoothImageView = ImageView(.bluetooth)
    let numberOneImageView = ImageView(.numberOne)
    let listIconImageView = ImageView(.list)
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()

    init() {
        super.init(frame: .zero)
        layoutMargins = .zero
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        configureLayout()
        applyConstraints()
    }
    
    func configureLayout() {
        let firstRow = UIStackView()
        firstRow.heightAnchor.constraint(equalToConstant: 100).isActive = true
        firstRow.axis = .horizontal
        firstRow.stackable.add([
            sTextImageView,
            10,
            addImageView
                .aligned(.top)
                .inset(by: .init(top: 15, left: 10, bottom: 10, right: 10)),
            10,
            locationImageView
                .aligned(.centerY),
            20,
            progressRingsImageView
                .aligned(.centerY),
            15,
            backImageView
                .inset(by: .init(top: 0, left: 0, bottom: 10, right: 0))
                .aligned(.centerY),
        ])
        
        let secondRow = UIStackView()
        secondRow.heightAnchor.constraint(equalToConstant: 100).isActive = true
        secondRow.axis = .horizontal
        secondRow.stackable.add([
            UIStackView.stackable.flexibleSpace,
            appStoreImageView,
            15,
            bluetoothImageView,
            20,
            numberOneImageView
                .inset(by: .init(top: 10, left: 0, bottom: 10, right: 0)),
            20,
            listIconImageView
                .aligned(.centerY),
        ])
        
        stack.stackable.add([
            firstRow,
            15,
            secondRow,
        ])
        
        stack.stackable.debug.showMargins()
        stack.stackable.debug.showOutlines()
        stack.stackable.debug.showSpaces()
    }
    
    static func ImageView(_ asset: UIImage.Asset) -> UIImageView {
        let imageView = UIImageView(image: .init(asset: asset))
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }
        
    func applyConstraints() {

        NSLayoutConstraint.activate([
            // Logo should not exceed container
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leadingAnchor),
            stack.topAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.topAnchor),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.bottomAnchor),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
            
            // Logo should stay centered
            stack.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor),
        ])
        
        let lowPriorityFillConstraints = [
            // Logo should attempt to fill container if possible
            stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ]
        lowPriorityFillConstraints.forEach {
            $0.priority = .defaultLow
        }
        NSLayoutConstraint.activate(lowPriorityFillConstraints)
        
        // Adjust the width constraints of the image views relative to each other
        let widthProportions = [
            sTextImageView: 0.8,
            addImageView: 0.3,
            locationImageView: 0.3,
            progressRingsImageView: 0.7,
            backImageView: 0.4,
            appStoreImageView: 0.5,
            bluetoothImageView: 0.5,
            numberOneImageView: 0.25,
            listIconImageView: 0.4
        ]
        
        // Factor that each number above will be multiplied by to achieve a total proportion of the `layoutMarginsGuide.width`
        let widthMultiplier = 0.25
        
        widthProportions.forEach { image, proportion in
            let multiplier = CGFloat(proportion * widthMultiplier)
            image.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor, multiplier: multiplier).isActive = true
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
