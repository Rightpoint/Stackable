//
//  UIStackView+Utilities.swift
//  Stackable
//
//  Created by Jason Clark on 8/3/20.
//

import Foundation

// MARK: - UIStackView Utilities
extension StackableExtension where ExtendedType == UIStackView {
    
    public func removeAllArrangedSubviews() {
        type.arrangedSubviews.forEach {
            type.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    public func insertArrangedSubview(_ view: UIView, aboveArrangedSubview other: UIView) {
        if let idx = type.arrangedSubviews.firstIndex(of: other) {
            type.insertArrangedSubview(view, at: idx)
        }
        else {
            type.addArrangedSubview(view)
        }
    }

    public func insertArrangedSubview(_ view: UIView, belowArrangedSubview other: UIView) {
        if let idx = type.arrangedSubviews.firstIndex(of: other)?.advanced(by: 1) {
            type.insertArrangedSubview(view, at: idx)
        }
        else {
            type.addArrangedSubview(view)
        }
    }

}
