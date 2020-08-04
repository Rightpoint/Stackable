//
//  Stackable+Spacing.swift
//  Stackable
//
//  Created by Jason Clark on 8/3/20.
//

import Foundation

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
            NSLayoutConstraint.activate([
                spacer.dimension(along: stackView.axis).constraint(equalToConstant: space)
            ])
            stackView.addArrangedSubview(spacer)

        case let .spaceBefore(view, space):
            let spacer = UIView()
            NSLayoutConstraint.activate([
                spacer.dimension(along: stackView.axis).constraint(equalToConstant: space)
            ])
            stackView.addArrangedSubview(spacer)
            spacer.bindVisible(to: view)

        case let .spaceAfter(view, space):
            stackView.setCustomSpacing(space, after: view)

        case let .spaceAfterGroup(views, space):
            let spacer = UIView()
            NSLayoutConstraint.activate([
                spacer.dimension(along: stackView.axis).constraint(equalToConstant: space)
            ])
            if let view = views.last {
                stackView.stackable.insertArrangedSubview(spacer, belowArrangedSubview: view)
            }
            spacer.bindVisible(toAnyVisible: views)

        case let .flexibleSpace(.atLeast(space)):
            let spacer = UIView()
            NSLayoutConstraint.activate([
                spacer.dimension(along: stackView.axis).constraint(greaterThanOrEqualToConstant: space)
            ])
            stackView.addArrangedSubview(spacer)

        case let .flexibleSpace(.range(range)):
            let spacer = UIView()
            let anchor = spacer.dimension(along: stackView.axis)
            NSLayoutConstraint.activate([
                anchor.constraint(lessThanOrEqualToConstant: range.upperBound),
                anchor.constraint(greaterThanOrEqualToConstant: range.lowerBound),
            ])
            stackView.addArrangedSubview(spacer)

        case let .flexibleSpace(.atMost(space)):
            let spacer = UIView()
            NSLayoutConstraint.activate([
                spacer.dimension(along: stackView.axis).constraint(lessThanOrEqualToConstant: space)
            ])
            stackView.addArrangedSubview(spacer)
        }
    }
}
