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
        base.arrangedSubviews.forEach {
            base.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    public func insertArrangedSubview(_ view: UIView, beforeArrangedSubview other: UIView) {
        if let idx = base.arrangedSubviews.firstIndex(where: { other.isDescendant(of: $0) }) {
            base.insertArrangedSubview(view, at: idx)
        }
        else {
            base.addArrangedSubview(view)
        }
    }

    public func insertArrangedSubview(_ view: UIView, afterArrangedSubview other: UIView) {
        if let idx = base.arrangedSubviews.firstIndex(where: { other.isDescendant(of: $0) })?.advanced(by: 1) {
            base.insertArrangedSubview(view, at: idx)
        }
        else {
            base.addArrangedSubview(view)
        }
    }

}
