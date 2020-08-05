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

    public func insertArrangedSubview(_ view: UIView, beforeArrangedSubview other: UIView) {
        if let idx = type.arrangedSubviews.firstIndex(where: { other.isDescendant(of: $0) }) {
            type.insertArrangedSubview(view, at: idx)
        }
        else {
            type.addArrangedSubview(view)
        }
    }

    public func insertArrangedSubview(_ view: UIView, afterArrangedSubview other: UIView) {
        if let idx = type.arrangedSubviews.firstIndex(where: { other.isDescendant(of: $0) })?.advanced(by: 1) {
            type.insertArrangedSubview(view, at: idx)
        }
        else {
            type.addArrangedSubview(view)
        }
    }

}
