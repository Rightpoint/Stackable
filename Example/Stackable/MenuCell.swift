//
//  MenuCell.swift
//  Stackable_Example
//
//  Created by Jason Clark on 8/10/20.
//  Copyright © 2020 Rightpoint. All rights reserved.
//

import UIKit

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
        layoutMargins.top = 10
        layoutMargins.bottom = 10
        
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
