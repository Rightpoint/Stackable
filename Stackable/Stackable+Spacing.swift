//
//  Stackable+Spacing.swift
//  Stackable
//
//  Created by Jason Clark on 8/3/20.
//

import Foundation

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

// MARK: - Stackable Spaces
public struct StackableSpaceItem {
    internal let type: SpaceType
    
    internal enum SpaceType {
        case smartSpace(CGFloat)
        case constantSpace(CGFloat)
        case spaceBefore(UIView, CGFloat)
        case spaceAfter(UIView, CGFloat)
        case spaceAfterGroup([UIView], CGFloat)
        case flexibleSpace(StackableFlexibleSpace)
    }
}

public enum StackableFlexibleSpace {
     case atLeast(CGFloat)
     case range(ClosedRange<CGFloat>)
     case atMost(CGFloat)
 }

public extension StackableExtension where ExtendedType == UIStackView {
    static func space(_ space: CGFloat) -> StackableSpaceItem {
        return .init(type: .smartSpace(space))
    }
    static func space(after view: UIView, _ space: CGFloat) -> StackableSpaceItem {
        return .init(type: .spaceAfter(view, space))
    }
    static func space(before view: UIView, _ space: CGFloat) -> StackableSpaceItem {
        return .init(type: .spaceBefore(view, space))
    }
    static func space(afterGroup group: [UIView], _ space: CGFloat) -> StackableSpaceItem {
        return .init(type: .spaceAfterGroup(group, space))
    }
    static func constantSpace(_ space: CGFloat) -> StackableSpaceItem {
        return .init(type: .constantSpace(space))
    }
    static func flexibleSpace(_ flexibleSpace: StackableFlexibleSpace = .atLeast(0)) -> StackableSpaceItem {
        return .init(type: .flexibleSpace(flexibleSpace))
    }
    static var flexibleSpace: StackableSpaceItem {
        return UIStackView.stackable.flexibleSpace()
    }
}

extension StackableSpaceItem: Stackable {

    public func configure(stackView: UIStackView) {
        switch type {
        case let .smartSpace(space):
            if let view = stackView.arrangedSubviews.last {
                StackableSpaceItem(type: .spaceAfter(view, space)).configure(stackView: stackView)
            }
            else {
                StackableSpaceItem(type: .constantSpace(space)).configure(stackView: stackView)
            }

        case let .constantSpace(space):
            let spacer = UIView()
            spacer.setContentHuggingPriority(.required, for: stackView.axis)
            NSLayoutConstraint.activate([
                spacer.dimension(along: stackView.axis).constraint(equalToConstant: space)
            ])
            stackView.addArrangedSubview(spacer)

        case let .spaceBefore(view, space):
            let spacer = UIView()
            spacer.setContentHuggingPriority(.required, for: stackView.axis)
            NSLayoutConstraint.activate([
                spacer.dimension(along: stackView.axis).constraint(equalToConstant: space)
            ])
            stackView.stackable.insertArrangedSubview(spacer, beforeArrangedSubview: view)
            spacer.bindVisible(to: view)

        case let .spaceAfter(view, space):
            let spacer = UIView()
            spacer.setContentHuggingPriority(.required, for: stackView.axis)
            NSLayoutConstraint.activate([
                spacer.dimension(along: stackView.axis).constraint(equalToConstant: space)
            ])
            stackView.stackable.insertArrangedSubview(spacer, afterArrangedSubview: view)
            spacer.bindVisible(to: view)

        case let .spaceAfterGroup(views, space):
            let spacer = UIView()
            spacer.setContentHuggingPriority(.required, for: stackView.axis)
            NSLayoutConstraint.activate([
                spacer.dimension(along: stackView.axis).constraint(equalToConstant: space)
            ])
            if let view = views.last {
                stackView.stackable.insertArrangedSubview(spacer, afterArrangedSubview: view)
            }
            spacer.bindVisible(toAnyVisible: views)

        case let .flexibleSpace(.atLeast(space)):
            let spacer = UIView()
            spacer.setContentHuggingPriority(.defaultLow, for: stackView.axis)
            NSLayoutConstraint.activate([
                spacer.dimension(along: stackView.axis).constraint(greaterThanOrEqualToConstant: space)
            ])
            stackView.addArrangedSubview(spacer)

        case let .flexibleSpace(.range(range)):
            let spacer = UIView()
            spacer.setContentHuggingPriority(.defaultLow, for: stackView.axis)
            let anchor = spacer.dimension(along: stackView.axis)
            NSLayoutConstraint.activate([
                anchor.constraint(lessThanOrEqualToConstant: range.upperBound),
                anchor.constraint(greaterThanOrEqualToConstant: range.lowerBound),
            ])
            stackView.addArrangedSubview(spacer)

        case let .flexibleSpace(.atMost(space)):
            let spacer = UIView()
            spacer.setContentHuggingPriority(.defaultLow, for: stackView.axis)
            NSLayoutConstraint.activate([
                spacer.dimension(along: stackView.axis).constraint(lessThanOrEqualToConstant: space)
            ])
            stackView.addArrangedSubview(spacer)
        }
    }
}
