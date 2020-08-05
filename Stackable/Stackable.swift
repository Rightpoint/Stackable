//
//  Stackable.swift
//  Stackable
//
//  Created by Jay Clark on 7/30/20.
//

import UIKit

// MARK: - Stackable Protocol Definition

/// Stackable protocol definition
/// Any object conforming to `Stackable` simply needs to define how it interacts with a `UIStackView`, most often by adding views or spacing.
public protocol Stackable {
    func configure(stackView: UIStackView)
}

public protocol StackableView: Stackable {
    func makeStackableView(for stackView: UIStackView) -> UIView
}

extension StackableView {
    public func configure(stackView: UIStackView) {
        let view = makeStackableView(for: stackView)
        stackView.addArrangedSubview(view)
    }
}

internal protocol StackableSpace: Stackable {
    func spaceType(for stackView: UIStackView) -> StackableSpaceItem.SpaceType
}

extension StackableSpace {
    public func configure(stackView: UIStackView) {
        let type = spaceType(for: stackView)
        let item = StackableSpaceItem(type: type)
        item.configure(stackView: stackView)
    }
}

extension UIStackView: StackableExtended {}
extension StackableExtension where ExtendedType == UIStackView {

    public func add(_ stackable: Stackable) {
        add([stackable])
    }

    public func add(_ stackables: [Stackable]) {
        stackables.forEach { $0.configure(stackView: base) }
    }

}

// MARK: - Stackable Conformance
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

extension CGFloat: StackableSpace {
    func spaceType(for stackView: UIStackView) -> StackableSpaceItem.SpaceType {
        return .smartSpace(self)
    }
}

extension Int: StackableSpace {
    func spaceType(for stackView: UIStackView) -> StackableSpaceItem.SpaceType {
        return CGFloat(self).spaceType(for: stackView)
    }
}

extension Float: StackableSpace {
    func spaceType(for stackView: UIStackView) -> StackableSpaceItem.SpaceType {
        CGFloat(self).spaceType(for: stackView)
    }
}

extension ClosedRange: StackableSpace {
    func spaceType(for stackView: UIStackView) -> StackableSpaceItem.SpaceType {
        switch (lowerBound, upperBound) {
        case let (lower, upper) as (CGFloat, CGFloat):
            return .flexibleSpace(.range(lower...upper))
        case let (lower, upper) as (Int, Int):
            return .flexibleSpace(.range(CGFloat(lower)...CGFloat(upper)))
        case let (lower, upper) as (Float, Float):
            return .flexibleSpace(.range(CGFloat(lower)...CGFloat(upper)))
        case let (lower, upper) as (Double, Double):
            return .flexibleSpace(.range(CGFloat(lower)...CGFloat(upper)))
        default:
            preconditionFailure("unsupported range bound: \(Bound.self)")
        }
    }
}

extension PartialRangeFrom: StackableSpace {
    func spaceType(for stackView: UIStackView) -> StackableSpaceItem.SpaceType {
        switch lowerBound {
        case let lower as CGFloat:
            return .flexibleSpace(.atLeast(lower))
        case let lower as Int:
            return .flexibleSpace(.atLeast(CGFloat(lower)))
        case let lower as Float:
            return .flexibleSpace(.atLeast(CGFloat(lower)))
        case let lower as Double:
            return .flexibleSpace(.atLeast(CGFloat(lower)))
        default:
            preconditionFailure("unsupported range bound: \(Bound.self)")
        }
    }
}

extension PartialRangeThrough: StackableSpace {
    func spaceType(for stackView: UIStackView) -> StackableSpaceItem.SpaceType {
        switch upperBound {
        case let upper as CGFloat:
            return .flexibleSpace(.atMost(upper))
        case let upper as Int:
            return .flexibleSpace(.atMost(CGFloat(upper)))
        case let upper as Float:
            return .flexibleSpace(.atMost(CGFloat(upper)))
        case let upper as Double:
            return .flexibleSpace(.atMost(CGFloat(upper)))
        default:
            preconditionFailure("unsupported range bound: \(Bound.self)")
        }
    }
}

extension UILayoutGuide: Stackable {
    public func configure(stackView: UIStackView) {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addLayoutGuide(self)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        stackView.addArrangedSubview(view)
    }
}

extension Array: Stackable where Element: Stackable {

    public func configure(stackView: UIStackView) {
        forEach { $0.configure(stackView: stackView) }
    }

}

extension Optional: Stackable where Wrapped: Stackable {
    
    public func configure(stackView: UIStackView) {
        map { $0.configure(stackView: stackView) }
    }
    
}

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
