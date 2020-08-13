//
//  Utilities.swift
//  Stackable
//
//  Created by Jason Clark on 8/11/20.
//

import Foundation

internal extension UIView {

    /// Get the dimension anchor of a view along the axis of a `UIStackView`.
    /// For example, fetches the `heightAnchor` for a `.vertical` axis
    /// - Parameter axis: The `stackView.axis`
    /// - Returns: An `NSLayoutDimension` for the size anchor along the axis of a stackView.
    func dimension(along axis: NSLayoutConstraint.Axis) -> NSLayoutDimension {
        switch axis {
        case .vertical: return heightAnchor
        case .horizontal: return widthAnchor
        @unknown default: fatalError()
        }
    }

}
