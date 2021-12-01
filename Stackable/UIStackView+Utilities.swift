//
//  UIStackView+Utilities.swift
//  Stackable
//
//  Created by Jason Clark on 8/3/20.
//  Copyright © 2020 Rightpoint. All rights reserved.
//

import UIKit

// MARK: - UIStackView Utilities
extension StackableExtension where ExtendedType: UIStackView {
    
    /// Removes all `stack.arrangedSubviews` from the `UIStackView`
    public func removeAllArrangedSubviews() {
        base.arrangedSubviews.forEach {
            base.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    /// Locate  `other` in `.arrangedSubviews`, and insert `view` at the index before it. If `other` cannot be found, `view` is added at the next available index.
    public func insertArrangedSubview(_ view: UIView, beforeArrangedSubview other: UIView) {
        if let idx = base.arrangedSubviews.firstIndex(where: { other.isDescendant(of: $0) }) {
            base.insertArrangedSubview(view, at: idx)
        }
        else {
            base.addArrangedSubview(view)
        }
    }

    /// Locate  `other` in `.arrangedSubviews`, and insert `view` at the index after it. If `other` cannot be found, `view` is added at the next available index.
    public func insertArrangedSubview(_ view: UIView, afterArrangedSubview other: UIView) {
        if let idx = base.arrangedSubviews.firstIndex(where: { other.isDescendant(of: $0) })?.advanced(by: 1) {
            base.insertArrangedSubview(view, at: idx)
        }
        else {
            base.addArrangedSubview(view)
        }
    }

}
