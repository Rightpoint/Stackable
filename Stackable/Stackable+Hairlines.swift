//
//  Stackable+Hairlines.swift
//  Stackable
//
//  Created by Jason Clark on 8/3/20.
//

import Foundation

// MARK: - Stackable Hairlines
public struct StackableHairline {
    internal let type: HairlineType
    
    internal var thickness: CGFloat = 1.0
    internal var color: UIColor = .lightGray
    
    internal var inset: UIEdgeInsets = .zero
    internal var outsetAncestor: UIView?
    
    internal enum HairlineType {
        case after(UIView?)
        case between(UIView?, UIView?)
        case before(UIView?)
        case around(UIView?)
    }
}

public extension StackableExtension where ExtendedType == UIStackView {
    static var hairline: StackableHairline {
        return .init(type: .after(nil))
    }
    static func hairline(after view: UIView) -> StackableHairline {
        return .init(type: .after(view))
    }
    static func hairlineBetween(_ view1: UIView?, _ view2: UIView?) -> StackableHairline {
        return .init(type: .between(view1, view2))
    }
    static func hairline(before view: UIView?) -> StackableHairline {
        return .init(type: .before(view))
    }
    static func hairline(around view: UIView?) -> StackableHairline {
        return .init(type: .around(view))
    }
    static func hairlines(between views: [UIView]) -> [StackableHairline] {
        let pairs = zip(views, views.dropFirst())
        return pairs.map { UIStackView.stackable.hairlineBetween($0.0, $0.1) }
    }
    static func hairlines(after views: [UIView]) -> [StackableHairline] {
        return views.map { UIStackView.stackable.hairline(after: $0) }
    }
    static func hairlines(around views: [UIView]) -> [StackableHairline] {
        return views.map { $0 == views.first
            ? UIStackView.stackable.hairline(around: $0)
            : UIStackView.stackable.hairline(after: $0)
        }
    }
}

public extension StackableHairline {
        
    mutating func inset(by margins: UIEdgeInsets) -> StackableHairline {
        self.inset = margins
        return self
    }
    
    mutating func outset(to ancestor: UIView) -> StackableHairline {
        self.outsetAncestor = ancestor
        return self
    }
    
    mutating func thickness(_ thickness: CGFloat) -> StackableHairline {
        self.thickness = thickness
        return self
    }
    
    mutating func color(_ color: UIColor) -> StackableHairline {
        self.color = color
        return self
    }
    
}

final class StackableHairlineView: UIView {

    init(stackAxis axis: NSLayoutConstraint.Axis, thickness: CGFloat, color: UIColor) {
        super.init(frame: .zero)
        NSLayoutConstraint.activate([
            self.dimension(along: axis).constraint(equalToConstant: thickness),
        ])
        backgroundColor = color
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension StackableHairline: Stackable {

    public func configure(stackView: UIStackView) {
        if let view = hairlineBeforeView {
            let hairline = makeHairline(stackView: stackView)
            stackView.stackable.insertArrangedSubview(hairline, aboveArrangedSubview: view)
        }
        if let view = hairlineAfterView {
            let hairline = makeHairline(stackView: stackView)
            stackView.stackable.insertArrangedSubview(hairline, belowArrangedSubview: view)
        }
        if allViews.isEmpty {
            let hairline = makeHairline(stackView: stackView)
            stackView.addArrangedSubview(hairline)
        }
    }
    
    private func makeHairline(stackView: UIStackView) -> StackableHairlineView {
        let hairline = StackableHairlineView(
            stackAxis: stackView.axis,
            thickness: thickness,
            color: color
        )
        
        if let ancestor = outsetAncestor {
            switch stackView.axis {
            case .horizontal:
                NSLayoutConstraint.activate([
                    hairline.topAnchor.constraint(equalTo: ancestor.topAnchor),
                    hairline.bottomAnchor.constraint(equalTo: ancestor.bottomAnchor),
                ])
                
            case .vertical:
                NSLayoutConstraint.activate([
                    hairline.leadingAnchor.constraint(equalTo: ancestor.leadingAnchor),
                    hairline.trailingAnchor.constraint(equalTo: ancestor.trailingAnchor),
                ])
                
            @unknown default:
                // We've hit some new cool stackview axis that we don't support yet
                break
            }
        }
        
        hairline.bindVisible(toAllVisible: allViews)
        return hairline
    }
    
    private var allViews: [UIView] {
        switch type {
        case .after(let view): return [view].compactMap { $0 }
        case .between(let v0, let v1): return [v0, v1].compactMap { $0 }
        case .before(let view): return [view].compactMap { $0 }
        case .around(let view): return [view].compactMap { $0 }
        }
    }

    private var hairlineAfterView: UIView? {
        switch type {
        case .after(let view): return view
        case .between(let v0, _): return v0
        case .before: return nil
        case .around(let view): return view
        }
    }

    private var hairlineBeforeView: UIView? {
        switch type {
        case .after: return nil
        case .between: return nil
        case .before(let view): return view
        case .around(let view): return view
        }
    }
}
