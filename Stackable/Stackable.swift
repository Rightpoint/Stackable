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

extension UIStackView: StackableExtended {}
extension StackableExtension where ExtendedType == UIStackView {

    public func add(_ stackable: Stackable) {
        add([stackable])
    }

    public func add(_ stackables: [Stackable]) {
        stackables.forEach { $0.configure(stackView: type) }
    }

}

// MARK: - Stackable Conformance
extension UIView: Stackable {
    public func configure(stackView: UIStackView) {
        stackView.addArrangedSubview(self)
    }
}

extension UIViewController: Stackable {
    public func configure(stackView: UIStackView) {
        stackView.addArrangedSubview(view)
    }
}

extension NSAttributedString: Stackable {
    public func configure(stackView: UIStackView) {
        let label = UILabel()
        label.attributedText = self
        label.numberOfLines = 0
        stackView.addArrangedSubview(label)
    }
}

extension String: Stackable {
    public func configure(stackView: UIStackView) {
        NSAttributedString(string: self).configure(stackView: stackView)
    }
}

extension UIImage: Stackable {
    public func configure(stackView: UIStackView) {
        let imageView = UIImageView(image: self)
        imageView.contentMode = .scaleAspectFit
        imageView.configure(stackView: stackView)
    }
}

extension CGFloat: Stackable {
    public func configure(stackView: UIStackView) {
        stackView.stackable.add([Space.smartSpace(self)])
    }
}

extension Int: Stackable {
    public func configure(stackView: UIStackView) {
        CGFloat(self).configure(stackView: stackView)
    }
}

extension Float: Stackable {
    public func configure(stackView: UIStackView) {
        CGFloat(self).configure(stackView: stackView)
    }
}

extension ClosedRange: Stackable {
    public func configure(stackView: UIStackView) {
        switch (lowerBound, upperBound) {
        case let (lower, upper) as (CGFloat, CGFloat):
            stackView.stackable.add(Space.flexibleSpace(.range(lower...upper)))
        case let (lower, upper) as (Int, Int):
            stackView.stackable.add(Space.flexibleSpace(.range(CGFloat(lower)...CGFloat(upper))))
        case let (lower, upper) as (Float, Float):
            stackView.stackable.add(Space.flexibleSpace(.range(CGFloat(lower)...CGFloat(upper))))
        case let (lower, upper) as (Double, Double):
            stackView.stackable.add(Space.flexibleSpace(.range(CGFloat(lower)...CGFloat(upper))))
        default:
            preconditionFailure("unsupported range bound: \(Bound.self)")
        }
    }
}

extension PartialRangeFrom: Stackable {
    public func configure(stackView: UIStackView) {
        switch lowerBound {
        case let lower as CGFloat:
            stackView.stackable.add(Space.flexibleSpace(.atLeast(lower)))
        case let lower as Int:
            stackView.stackable.add(Space.flexibleSpace(.atLeast(CGFloat(lower))))
        case let lower as Float:
            stackView.stackable.add(Space.flexibleSpace(.atLeast(CGFloat(lower))))
        case let lower as Double:
            stackView.stackable.add(Space.flexibleSpace(.atLeast(CGFloat(lower))))
        default:
            preconditionFailure("unsupported range bound: \(Bound.self)")
        }
    }
}

extension PartialRangeThrough: Stackable {
    public func configure(stackView: UIStackView) {
        switch upperBound {
        case let upper as CGFloat:
            stackView.stackable.add(Space.flexibleSpace(.atMost(upper)))
        case let upper as Int:
            stackView.stackable.add(Space.flexibleSpace(.atMost(CGFloat(upper))))
        case let upper as Float:
            stackView.stackable.add(Space.flexibleSpace(.atMost(CGFloat(upper))))
        case let upper as Double:
            stackView.stackable.add(Space.flexibleSpace(.atMost(CGFloat(upper))))
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

public extension StackableExtension where ExtendedType == UIStackView {
    static func space(_ space: CGFloat) -> Space {
        return Space.smartSpace(space)
    }
    static func space(after view: UIView, _ space: CGFloat) -> Space {
        return Space.spaceAfter(view, space)
    }
    static func space(before view: UIView, _ space: CGFloat) -> Space {
        return Space.spaceBefore(view, space)
    }
    static func space(afterGroup group: [UIView], _ space: CGFloat) -> Space {
        return Space.spaceAfterGroup(group, space)
    }
    static func constantSpace(_ space: CGFloat) -> Space {
        return Space.constantSpace(space)
    }
    static func flexibleSpace(_ flexibleSpace: Space.FlexibleSpace = .atLeast(0)) -> Space {
        return Space.flexibleSpace(flexibleSpace)
    }
    static var flexibleSpace: Space {
        return UIStackView.stackable.flexibleSpace()
    }
}

public extension StackableExtension where ExtendedType == UIStackView {
    static var hairline: Hairline {
        return Hairline.after(nil)
    }
    static func hairline(after view: UIView) -> Hairline {
        return Hairline.after(view)
    }
    static func hairlineBetween(_ view1: UIView?, _ view2: UIView?) -> Hairline {
        return Hairline.between(view1, view2)
    }
    static func hairline(before view: UIView?) -> Hairline {
        return Hairline.before(view)
    }
    static func hairline(around view: UIView?) -> Hairline {
        return Hairline.around(view)
    }
    static func hairlines(between views: [UIView]) -> [Hairline] {
        let pairs = zip(views, views.dropFirst())
        return pairs.map { UIStackView.stackable.hairlineBetween($0.0, $0.1) }
    }
    static func hairlines(after views: [UIView]) -> [Hairline] {
        return views.map { UIStackView.stackable.hairline(after: $0) }
    }
    static func hairlines(around views: [UIView]) -> [Hairline] {
        return views.map { $0 == views.first
            ? UIStackView.stackable.hairline(around: $0)
            : UIStackView.stackable.hairline(after: $0)
        }
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
