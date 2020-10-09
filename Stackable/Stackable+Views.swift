//
//  Stackable+Views.swift
//  Stackable
//
//  Created by Jason Clark on 8/11/20.
//  Copyright © 2020 Rightpoint. All rights reserved.
//

import UIKit

// MARK: - StackableView Conformance
extension UIView: StackableView {
    public func makeStackableView(for stackView: UIStackView) -> UIView {
        return self
    }
}

extension UIViewController: StackableView {
    public func makeStackableView(for stackView: UIStackView) -> UIView {
        return view
    }
}

extension NSAttributedString: StackableView {
    public func makeStackableView(for stackView: UIStackView) -> UIView {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: stackView.axis)
        label.attributedText = self
        label.numberOfLines = 0
        return label
    }
}

extension String: StackableView {
    public func makeStackableView(for stackView: UIStackView) -> UIView {
        return NSAttributedString(string: self).makeStackableView(for: stackView)
    }
}

extension UIImage: StackableView {
    public func makeStackableView(for stackView: UIStackView) -> UIView {
        let imageView = UIImageView(image: self)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}

extension UILayoutGuide: StackableView {
    public func makeStackableView(for stackView: UIStackView) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addLayoutGuide(self)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        return view
    }
}
