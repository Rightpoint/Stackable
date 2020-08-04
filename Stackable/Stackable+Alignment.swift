//
//  Stackable+Alignment.swift
//  Stackable
//
//  Created by Jason Clark on 8/3/20.
//

import Foundation

struct StackableViewItem {
    let makeView: (UIStackView) -> UIView
    var alignment: StackableAlignment = []
    var inset: UIEdgeInsets = .zero
}

public extension StackableView {
    
    func aligned(_ alignment: StackableAlignment) -> StackableView {
        return StackableViewItem(
            makeView: makeStackableView(for:), //TODO: retain cycle?
            alignment: alignment
        )
    }
    
    func inset(by margins: UIEdgeInsets) -> StackableView {
        return StackableViewItem(
            makeView: makeStackableView(for:), //TODO: retain cycle?
            inset: margins
        )
    }
    
}

extension StackableViewItem {
    
    mutating func aligned(_ alignment: StackableAlignment) -> StackableViewItem {
        self.alignment = alignment
        return self
    }
    
    mutating func inset(by margins: UIEdgeInsets) -> StackableViewItem {
        self.inset = margins
        return self
    }
    
}

extension StackableViewItem: StackableView {
    
    func makeStackableView(for stackView: UIStackView) -> UIView {
        let view = makeView(stackView)
        return AlignmentView(view, alignment: alignment, inset: inset)
    }

}

public struct StackableAlignment: OptionSet {
    public let rawValue: Int
    public static let leading          = StackableAlignment(rawValue: 1 << 0)
    public static let left             = StackableAlignment(rawValue: 1 << 1)
    public static let centerX          = StackableAlignment(rawValue: 1 << 2)
    public static let right            = StackableAlignment(rawValue: 1 << 3)
    public static let trailing         = StackableAlignment(rawValue: 1 << 4)
    public static let fillHorizontal   = StackableAlignment(rawValue: 1 << 5)
    public static let flexHorizontal   = StackableAlignment(rawValue: 1 << 6)

    public static let top              = StackableAlignment(rawValue: 1 << 7)
    public static let centerY          = StackableAlignment(rawValue: 1 << 8)
    public static let bottom           = StackableAlignment(rawValue: 1 << 9)
    public static let fillVertical     = StackableAlignment(rawValue: 1 << 10)
    public static let flexVertical     = StackableAlignment(rawValue: 1 << 11)

    public static let center: StackableAlignment = [.centerX, .centerY]

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    fileprivate static let Horizontal: StackableAlignment = [.leading, .left, .centerX, .right, .trailing, .fillHorizontal, .flexHorizontal]
    fileprivate static let Vertical: StackableAlignment = [.top, .centerY, .bottom, .fillVertical, .flexVertical]
}

/// View wrapper that lets you specify internal alignment.
public final class AlignmentView: UIView {

    required init(_ wrapped: UIView, alignment: StackableAlignment, inset: UIEdgeInsets = .zero) {
        super.init(frame: .zero)
        layoutMargins = inset

        addSubview(wrapped)

        var alignment = alignment
        if alignment.isDisjoint(with: StackableAlignment.Horizontal) {
            alignment.formUnion(.fillHorizontal)
        }
        if alignment.isDisjoint(with: StackableAlignment.Vertical) {
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
