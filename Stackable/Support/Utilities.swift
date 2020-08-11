//
//  Utilities.swift
//  Stackable
//
//  Created by Jason Clark on 8/11/20.
//

import Foundation

// MARK: - Support
internal extension UIView {

    func dimension(along axis: NSLayoutConstraint.Axis) -> NSLayoutDimension {
        switch axis {
        case .vertical: return heightAnchor
        case .horizontal: return widthAnchor
        @unknown default: fatalError()
        }
    }

}

internal extension NSLayoutConstraint.Axis {
    
    var opposite: NSLayoutConstraint.Axis {
        switch self {
        case .horizontal:
            return .vertical
        case .vertical:
            return .horizontal
        @unknown default: fatalError()
        }
    }
    
}
