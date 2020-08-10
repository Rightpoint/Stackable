//
//  ExampleMenuViewController.swift
//  Stackable
//
//  Created by Jay Clark on 07/30/2020.
//  Copyright (c) 2020 Rightpoint. All rights reserved.
//

import UIKit
import Stackable

class ExampleMenuViewController: UIViewController {

    enum ExampleCell: String, CaseIterable {
        case signIn = "Sign In"
        case onboarding = "Onboarding"
        case settings  = "Settings"
        case contentList = "Content List"
        case contentDetail = "Content Detail"
    }
    
    let contentView: ScrollingStackView = {
        let view = ScrollingStackView()
        view.layoutMargins = Constant.margins
        return view
    }()
    
    lazy var cells: [UIView] = ExampleCell.allCases.map(cell(for:))
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.addSubview(contentView)
        contentView.pinToSuperview(view)
        
        contentView.backgroundColor = .groupTableViewBackground
        let stack = contentView.stackView
                
        stack.stackable.add([
            UIImage(asset: .example),
            20,
            "Stackable Example"
                .aligned(.centerX),
            20,
            cells
                .outset(to: view)
                .margins(alignedWith: contentView),
            UIStackView.stackable.hairlines(around: cells)
                .outset(to: view),
            20...,
            "Copyright Rightpoint",
        ])
    }
        
}

extension ExampleMenuViewController  {
    
    func cell(for example: ExampleCell) -> UIView {
        let cell = MenuCell()
        cell.title = example.rawValue
        cell.onSelect = { [weak self] in
            self?.exampleSelected(example: example)
        }
        return cell
    }
    
    func exampleSelected(example: ExampleCell) {
        print("pressed \(example)")
    }
    
    enum Constant  {
        static let margins = UIEdgeInsets(
            top: 20,
            left: 20,
            bottom: 20,
            right: 20
        )
    }

}

class MenuCell: UIControl {
    
    var title: String? {
        set { label.text = newValue }
        get { label.text }
    }
    
    var onSelect: (() -> Void)?
    
    private let label: UILabel = {
        let label = UILabel()
        return label
    }()
        
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        layoutMargins = .init(top: 10, left: 0, bottom: 10, right: 0)
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.isUserInteractionEnabled = false
        addSubview(stack)
        stack.pinToSuperviewMargins(self)
        stack.stackable.add([
            label,
            UIStackView.stackable.flexibleSpace,
            UIImage(asset: .chevron)
        ])
        
        addTarget(self, action: #selector(didPress), for: .touchUpInside)
    }
    
    @objc func didPress() {
        onSelect?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIView {
    
    func pinToSuperviewMargins(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    func pinToSuperview(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
}

extension UIImage {
    
    enum Asset: String {
        case chevron = "Chevron"
        case example = "Example"
    }
    
    convenience init(asset: Asset) {
        self.init(named: asset.rawValue)!
    }

}
