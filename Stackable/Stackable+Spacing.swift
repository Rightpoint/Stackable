//
//  Stackable+Spacing.swift
//  Stackable
//
//  Created by Jason Clark on 8/3/20.
//  Copyright © 2020 Rightpoint. All rights reserved.
//

import Foundation

// MARK: - Stackable Spaces

/// The public type representing a space. Struct is opaque to consumer and cannot be manipulated futher.
public struct StackableSpaceItem {
    internal let type: SpaceType
    
    /// Defines the different types of spaces supported by Stackable
    internal enum SpaceType {
        /// If added after an arrangedSubview, will coalesce to `.spaceAfter`. If not, will coalesce to a `.constantSpace`
        case smartSpace(CGFloat)
        
        /// A simple space that will be present in the stackView no matter what
        case constantSpace(CGFloat)
        
        /// A space that is added before some view and monitors its visibility.
        case spaceBefore(_ view: UIView?, CGFloat)
        
        /// A space that is added after some view and monitors its visibility. More or less equivalent to `stack.setCustomSpacing`, with the exception that the space will remain present even if the view is the last arrangedSubview
        case spaceAfter(_ view: UIView?, CGFloat)
        
        /// A space that is added between two views. Space will be visible if both views are visible.
        case spaceBetween(_ view1: UIView?, _ view2: UIView?, CGFloat)

        /// A space that is added after some group of views, and will be visible if any member of that group is visible. Useful for spaces between sections of a list, for example.
        case spaceAfterGroup([UIView], CGFloat)
        
        /// A space whose size can flex in response to the overall size of the stackView and content
        case flexibleSpace(StackableFlexibleSpace)
    }
}

/// Defines the different types of spaces with flexible bounds.
public enum StackableFlexibleSpace {
    /// A space with a defined lower bound and infinite upper bound.
    case atLeast(CGFloat)
    
    /// A space whose min and max are defined.
    case range(ClosedRange<CGFloat>)
    
    /// A space with a lower bound of zero and a defined upper bound.
    case atMost(CGFloat)
}

// MARK: - Public API

public extension StackableExtension where ExtendedType == UIStackView {
    /// Add a space to the stackView. If added after a view, will mirror the visibility of that view.
    /// - Parameter space: The size of the space.
    /// - Returns: A `Stackable` that represents the space.
    static func space(_ space: CGFloat) -> StackableSpaceItem {
        return .init(type: .smartSpace(space))
    }
    
    /// Add a space to the stackView after some view, and monitor the visibility of that view.
    /// Similar to `stack.setCustomSpacing(after:)`, with the exception that the space will remain present even if the view is the last arrangedSubview.
    /// - Parameters:
    ///   - view: The  view the space should be inserted after, and whose visibility should be monitored.
    ///   - space: The size of the space.
    /// - Returns: A `Stackable` that represents the space.
    static func space(after view: UIView?, _ space: CGFloat) -> StackableSpaceItem {
        return .init(type: .spaceAfter(view, space))
    }
    
    /// Add a space to the stackView before some view, and monitor the visibility of that view.
     /// Similar to `stack.setCustomSpacing(after:)`, but the spacing is before the view.
     /// - Parameters:
     ///   - view: The  view the space should be inserted before, and whose visibility should be monitored.
     ///   - space: The size of the space.
     /// - Returns: A `Stackable` that represents the space.
    static func space(before view: UIView?, _ space: CGFloat) -> StackableSpaceItem {
        return .init(type: .spaceBefore(view, space))
    }
    
    /// Add a space between two views. Space will be visible if both views are visible.
    /// - Parameters:
    ///   - view1: The  view the space should be inserted after, and whose visibility should be monitored.
    ///   - view2: The  view the space should be inserted before, and whose visibility should be monitored.
    ///   - space: The size of the space.
    /// - Returns: A `Stackable` that represents the space.
    static func spaceBetween(_ view1: UIView?, _ view2: UIView?, _ space: CGFloat) -> StackableSpaceItem {
        return .init(type: .spaceBetween(view1, view2, space))
    }
    
    /// Add spaces between each visible view in `views`.
    /// - Parameters:
    ///   - views: An array of views, of which each pair will receive a space between them.
    ///   - space: The size of the space.
    /// - Returns: A `Stackable` that represents the space.
    static func spaces(between views: [UIView], _ space: CGFloat) -> [StackableSpaceItem] {
        let pairs = zip(views, views.dropFirst())
        return pairs.map { UIStackView.stackable.spaceBetween($0.0, $0.1, space) }
    }
    
    /// Add a space after some group of views. Space wiill be visible if any member of that group is visible.
    /// Useful for spaces between sections of a list, for example.
    /// - Parameters:
    ///   - group: An array of views, after which the view should be placed.
    ///   - space: The size of the space.
    /// - Returns: A `Stackable` that represents the space.
    static func space(afterGroup group: [UIView], _ space: CGFloat) -> StackableSpaceItem {
        return .init(type: .spaceAfterGroup(group, space))
    }
    
    /// Add a space to the stackView. Does not monitor visibility of any arrangedSubview, and will not hide for any reason.
    /// - Parameter space: The size of the space
    /// - Returns: A `Stackable` that represents the space.
    static func constantSpace(_ space: CGFloat) -> StackableSpaceItem {
        return .init(type: .constantSpace(space))
    }
    
    /// A space whose size can flex in response to the overall size of the stackView and content
    /// - Parameter flexibleSpace: Defines the type of flexible bounds.
    /// - Returns: A `Stackable` that represents the space.
    static func flexibleSpace(_ flexibleSpace: StackableFlexibleSpace = .atLeast(0)) -> StackableSpaceItem {
        return .init(type: .flexibleSpace(flexibleSpace))
    }
    
    /// A space whose size can flex in response to the overall size of the stackView and content. Similar to  `UIBarButtonItem.SystemItem.flexibleSpace`
    static var flexibleSpace: StackableSpaceItem {
        return UIStackView.stackable.flexibleSpace()
    }
}


// MARK: - Internal

/// Internal Convenience Protocol to transform conforming types into `StackableSpaceItem`
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

// MARK: - Fixed Space Conformance

// Numerically-expressed spaces will prefer to track the visibility of the view before them.
// Constant spaces that do not monitor visibility should use `UIStackView.stackable.constantSpace`
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

// MARK: - Flexible Space Conformance
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

extension StackableSpaceItem: Stackable {
    
    public func configure(stackView: UIStackView) {
        switch type {
            
        case let .smartSpace(space):
            let newType: StackableSpaceItem.SpaceType
            // If added after an arrangedSubview, will coalesce to `.spaceAfter`.
            if let view = stackView.arrangedSubviews.last {
                newType = .spaceAfter(view, space)
            }
            else {
                // If not, will coalesce to a `.constantSpace`
                newType = .constantSpace(space)
            }
            StackableSpaceItem(type: newType).configure(stackView: stackView)

        case let .constantSpace(space):
            let spacer = StackableSpacer()
            spacer.setContentHuggingPriority(.required, for: stackView.axis)
            NSLayoutConstraint.activate([
                spacer.dimension(along: stackView.axis).constraint(equalToConstant: space)
            ])
            stackView.addArrangedSubview(spacer)

        case let .spaceBefore(view, space):
            guard let view = view else { return }
            let spacer = StackableSpacer()
            spacer.setContentHuggingPriority(.required, for: stackView.axis)
            NSLayoutConstraint.activate([
                spacer.dimension(along: stackView.axis).constraint(equalToConstant: space)
            ])
            stackView.stackable.insertArrangedSubview(spacer, beforeArrangedSubview: view)
            spacer.stackable.bindVisible(to: view)

        case let .spaceAfter(view, space):
            guard let view = view else { return }
            let spacer = StackableSpacer()
            spacer.setContentHuggingPriority(.required, for: stackView.axis)
            NSLayoutConstraint.activate([
                spacer.dimension(along: stackView.axis).constraint(equalToConstant: space)
            ])
            stackView.stackable.insertArrangedSubview(spacer, afterArrangedSubview: view)
            spacer.stackable.bindVisible(to: view)

        case let .spaceBetween(view1, view2, space):
            guard let view1 = view1, let view2 = view2 else { return }
            let spacer = StackableSpacer()
            spacer.setContentHuggingPriority(.required, for: stackView.axis)
            NSLayoutConstraint.activate([
                spacer.dimension(along: stackView.axis).constraint(equalToConstant: space)
            ])
            stackView.stackable.insertArrangedSubview(spacer, afterArrangedSubview: view1)
            spacer.bindVisible(toAllVisible: [view1, view2])
            
        case let .spaceAfterGroup(views, space):
            let spacer = StackableSpacer()
            spacer.setContentHuggingPriority(.required, for: stackView.axis)
            NSLayoutConstraint.activate([
                spacer.dimension(along: stackView.axis).constraint(equalToConstant: space)
            ])
            if let view = views.last {
                stackView.stackable.insertArrangedSubview(spacer, afterArrangedSubview: view)
            }
            spacer.stackable.bindVisible(toAnyVisible: views)

        case let .flexibleSpace(.atLeast(space)):
            let spacer = StackableSpacer()
            spacer.setContentHuggingPriority(.defaultLow, for: stackView.axis)
            NSLayoutConstraint.activate([
                spacer.dimension(along: stackView.axis).constraint(greaterThanOrEqualToConstant: space)
            ])
            stackView.addArrangedSubview(spacer)

        case let .flexibleSpace(.range(range)):
            let spacer = StackableSpacer()
            spacer.setContentHuggingPriority(.defaultLow, for: stackView.axis)
            let anchor = spacer.dimension(along: stackView.axis)
            NSLayoutConstraint.activate([
                anchor.constraint(lessThanOrEqualToConstant: range.upperBound),
                anchor.constraint(greaterThanOrEqualToConstant: range.lowerBound),
            ])
            stackView.addArrangedSubview(spacer)

        case let .flexibleSpace(.atMost(space)):
            let spacer = StackableSpacer()
            spacer.setContentHuggingPriority(.defaultLow, for: stackView.axis)
            NSLayoutConstraint.activate([
                spacer.dimension(along: stackView.axis).constraint(lessThanOrEqualToConstant: space)
            ])
            stackView.addArrangedSubview(spacer)
        }
    }
}

/// A simple, transparent view, representing spacing.
internal class StackableSpacer: UIView {
    
    init() {
        super.init(frame: .zero)
        accessibilityIdentifier = UIStackView.stackable.axID.space
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
