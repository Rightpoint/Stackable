//
//  Stackable+Spacing.swift
//  Stackable
//
//  Created by Jason Clark on 8/3/20.
//

import Foundation

// MARK: - Stackable Spaces
public enum Space {
    case smartSpace(CGFloat)
    case constantSpace(CGFloat)
    case spaceBefore(UIView, CGFloat)
    case spaceAfter(UIView, CGFloat)
    case spaceAfterGroup([UIView], CGFloat)
    case flexibleSpace(FlexibleSpace)

    public enum FlexibleSpace {
        case atLeast(CGFloat)
        case range(ClosedRange<CGFloat>)
        case atMost(CGFloat)
    }
}

extension Space: Stackable {

    public func configure(stackView: UIStackView) {
        switch self {
        case let .smartSpace(space):
            if let view = stackView.arrangedSubviews.last {
                Space.spaceAfter(view, space).configure(stackView: stackView)
            }
            else {
                Space.constantSpace(space).configure(stackView: stackView)
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
                spacer.dimension(along: stackView.axis).constraint(equalToConstant: space)
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
                spacer.dimension(along: stackView.axis).constraint(equalToConstant: space)
            ])
            stackView.addArrangedSubview(spacer)
        }
    }
}
