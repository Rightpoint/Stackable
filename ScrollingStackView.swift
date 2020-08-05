//
//  ScrollingStackView.swift
//  Stackable
//
//  Created by Jason Clark on 8/5/20.
//

import Foundation

open class ScrollingStackView: UIScrollView {

    open override var layoutMargins: UIEdgeInsets {
        set { contentView.layoutMargins = newValue }
        get { return contentView.layoutMargins }
    }

    public let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    override open func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIControl
            && !(view is UITextInput)
            && !(view is UISlider)
            && !(view is UISwitch) {
            return true
        }

        return super.touchesShouldCancel(in: view)
    }

    private let contentView = UIView()

    public init() {
        super.init(frame: .zero)

        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.clipsToBounds = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
        ])
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }
    

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
