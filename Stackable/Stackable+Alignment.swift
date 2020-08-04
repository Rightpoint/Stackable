//
//  Stackable+Alignment.swift
//  Stackable
//
//  Created by Jason Clark on 8/3/20.
//

import Foundation

public protocol StackAlignable: Stackable {
    
    func aligned(_ alignment: Alignment) -> AlignmentView
    func inset(by margins: UIEdgeInsets) -> AlignmentView
    
}

extension Stackable where Self: UIView {
    
    public func aligned(_ alignment: Alignment) -> AlignmentView {
        return AlignmentView(self, alignment: alignment)
    }
    
    public func inset(by margins: UIEdgeInsets) -> AlignmentView {
        return AlignmentView(self, alignment: [], inset: margins)
    }
    
}

public struct Alignment: OptionSet {
    public let rawValue: Int
    public static let leading          = Alignment(rawValue: 1 << 0)
    public static let left             = Alignment(rawValue: 1 << 1)
    public static let centerX          = Alignment(rawValue: 1 << 2)
    public static let right            = Alignment(rawValue: 1 << 3)
    public static let trailing         = Alignment(rawValue: 1 << 4)
    public static let fillHorizontal   = Alignment(rawValue: 1 << 5)
    public static let flexHorizontal   = Alignment(rawValue: 1 << 6)

    public static let top              = Alignment(rawValue: 1 << 7)
    public static let centerY          = Alignment(rawValue: 1 << 8)
    public static let bottom           = Alignment(rawValue: 1 << 9)
    public static let fillVertical     = Alignment(rawValue: 1 << 10)
    public static let flexVertical     = Alignment(rawValue: 1 << 11)

    public static let center: Alignment = [.centerX, .centerY]

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    fileprivate static let Horizontal: Alignment = [.leading, .left, .centerX, .right, .trailing, .fillHorizontal, .flexHorizontal]
    fileprivate static let Vertical: Alignment = [.top, .centerY, .bottom, .fillVertical, .flexVertical]
}

/// View wrapper that lets you specify internal alignment.
public final class AlignmentView: UIView {

    required init(_ wrapped: UIView, alignment: Alignment, inset: UIEdgeInsets = .zero) {
        super.init(frame: .zero)
        layoutMargins = inset

        addSubview(wrapped)

        var alignment = alignment
        if alignment.isDisjoint(with: Alignment.Horizontal) {
            alignment.formUnion(.fillHorizontal)
        }
        if alignment.isDisjoint(with: Alignment.Vertical) {
            alignment.formUnion(.fillVertical)
        }

        if alignment.contains(.leading) { wrapped.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true }
        if alignment.contains(.left) { wrapped.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor).isActive = true }
        if alignment.contains(.centerX) { wrapped.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true }
        if alignment.contains(.right) { wrapped.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor).isActive = true }
        if alignment.contains(.trailing) { wrapped.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true }
        if alignment.contains(.fillHorizontal) {
            wrapped.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
            wrapped.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        }

        if alignment.contains(.top) { wrapped.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true }
        if alignment.contains(.centerY) { wrapped.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor).isActive = true }
        if alignment.contains(.bottom) { wrapped.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true }
        if alignment.contains(.fillVertical) {
            wrapped.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
            wrapped.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        }

        translatesAutoresizingMaskIntoConstraints = false
        wrapped.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wrapped.topAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.topAnchor),
            wrapped.leadingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leadingAnchor),
            wrapped.bottomAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.bottomAnchor),
            wrapped.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
        ])

        self.bindVisible(to: wrapped)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
