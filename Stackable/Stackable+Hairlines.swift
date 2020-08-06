//
//  Stackable+Hairlines.swift
//  Stackable
//
//  Created by Jason Clark on 8/3/20.
//

import Foundation

// MARK: - Stackable Hairlines
public struct StackableHairline {
    
    internal enum HairlineType {
        case after(UIView?)
        case between(UIView?, UIView?)
        case before(UIView?)
        case around(UIView?)
    }
    
    internal let type: HairlineType
    
    internal var thicknessOverride: CGFloat?
    internal var colorOverride: UIColor?
    
    internal var inset: UIEdgeInsets = .zero
    internal var outsetAncestor: UIView?
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
    
    func inset(by margins: UIEdgeInsets) -> StackableHairline {
        var hairline = self
        hairline.inset = margins
        return hairline
    }
    
    func outset(to ancestor: UIView) -> StackableHairline {
        var hairline = self
        hairline.outsetAncestor = ancestor
        return hairline
    }
    
    func thickness(_ thickness: CGFloat) -> StackableHairline {
        var hairline = self
        hairline.thicknessOverride = thickness
        return hairline
    }
    
    func color(_ color: UIColor) -> StackableHairline {
        var hairline = self
        hairline.colorOverride = color
        return hairline
    }
    
}

public extension Array where Element == StackableHairline {
    
    func inset(by margins: UIEdgeInsets) -> Self {
        return map { $0.inset(by: margins) }
    }
    
    func outset(to ancestor: UIView) -> Self {
        return map { $0.outset(to: ancestor) }
    }
    
    func thickness(_ thickness: CGFloat) -> Self {
        return map { $0.thickness(thickness) }
    }
    
    func color(_ color: UIColor) -> Self {
        return map { $0.color(color) }
    }
    
}

final class StackableHairlineView: UIView {
    
    init(stackAxis axis: NSLayoutConstraint.Axis, thickness: CGFloat, color: UIColor) {
        super.init(frame: .zero)
        
        NSLayoutConstraint.activate([
            self.dimension(along: axis).constraint(equalToConstant: thickness),
        ])
        
        setContentHuggingPriority(.required, for: axis)
        setContentCompressionResistancePriority(.required, for: axis)
        
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
            let outsetHairline = outsetIfNecessary(view: hairline, stackView: stackView).makeStackableView(for: stackView)
            stackView.stackable.insertArrangedSubview(outsetHairline, beforeArrangedSubview: view)
            applyOutsetConstraint(view: hairline, stackView: stackView)
        }
        if let view = hairlineAfterView {
            let hairline = makeHairline(stackView: stackView)
            let outsetHairline = outsetIfNecessary(view: hairline, stackView: stackView).makeStackableView(for: stackView)
            stackView.stackable.insertArrangedSubview(outsetHairline, afterArrangedSubview: view)
            applyOutsetConstraint(view: hairline, stackView: stackView)
        }
        if allViews.isEmpty {
            let hairline = makeHairline(stackView: stackView)
            let outsetHairline = outsetIfNecessary(view: hairline, stackView: stackView).makeStackableView(for: stackView)
            stackView.addArrangedSubview(outsetHairline)
            applyOutsetConstraint(view: hairline, stackView: stackView)
        }
    }
    
    private func makeHairline(stackView: UIStackView) -> UIView {
        let hairline = stackView.stackable.hairlineProvider?(stackView)
            ?? UIStackView.stackable.hairlineProvider?(stackView)
            ?? StackableHairlineView(
                stackAxis: stackView.axis,
                thickness: thicknessOverride
                    ?? stackView.stackable.hairlineThickness
                    ?? UIStackView.stackable.hairlineThickness
                    ?? UIStackView.Default.hairlineThickness,
                color: colorOverride
                    ?? stackView.stackable.hairlineColor
                    ?? UIStackView.stackable.hairlineColor
                    ?? UIStackView.Default.hairlineColor
        )
        
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

extension StackableHairline {
    
    private func outsetHairlineIfNecessary(hairline: UIView, stackView: UIStackView) -> StackableView {
        if outsetAncestor == nil, inset == .zero { return hairline }
        
        switch stackView.axis {
        case .horizontal:
            let wrapper = UIView()
            wrapper.translatesAutoresizingMaskIntoConstraints = false
            hairline.translatesAutoresizingMaskIntoConstraints = false
            wrapper.addSubview(hairline)
            NSLayoutConstraint.activate([
                hairline.leadingAnchor.constraint(equalTo: wrapper.layoutMarginsGuide.leadingAnchor),
                hairline.trailingAnchor.constraint(equalTo: wrapper.layoutMarginsGuide.trailingAnchor),
            ])
            if outsetAncestor == nil {
                NSLayoutConstraint.activate([
                    hairline.topAnchor.constraint(equalTo: wrapper.layoutMarginsGuide.topAnchor),
                    hairline.bottomAnchor.constraint(equalTo: wrapper.layoutMarginsGuide.bottomAnchor),
                ])
            }
            wrapper.layoutMargins = inset
            return wrapper
            
        case .vertical:
            let wrapper = UIView()
            wrapper.translatesAutoresizingMaskIntoConstraints = false
            hairline.translatesAutoresizingMaskIntoConstraints = false
            wrapper.addSubview(hairline)
            NSLayoutConstraint.activate([
                hairline.topAnchor.constraint(equalTo: wrapper.layoutMarginsGuide.topAnchor),
                hairline.bottomAnchor.constraint(equalTo: wrapper.layoutMarginsGuide.bottomAnchor),
            ])
            if outsetAncestor == nil {
                NSLayoutConstraint.activate([
                    hairline.leftAnchor.constraint(equalTo: wrapper.layoutMarginsGuide.leftAnchor),
                    hairline.rightAnchor.constraint(equalTo: wrapper.layoutMarginsGuide.rightAnchor),
                ])
            }
            wrapper.layoutMargins = inset
            return wrapper
            
        @unknown default:
            // We've hit some new cool stackview axis that we don't support yet
            debugPrint("Unsupported stackView axis: \(stackView.axis)")
            return hairline
        }
    }
    
    private func applyOutsetConstraint(hairline: UIView, stackView: UIStackView) {
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
                debugPrint("Unsupported stackView axis: \(stackView.axis)")
            }
        }
    }
    
}

public typealias StackableHairlineProvider = (UIStackView) -> UIView

public extension UIStackView {
    fileprivate struct AssociatedKeys {
        static var hairlineColor = "hairlineColor"
        static var hairlineThickness = "hairlineThickness"
        static var hairlineProvider = "hairlineProvider"
    }
    
    fileprivate struct Default {
        static let hairlineColor = UIColor.lightGray
        static let hairlineThickness = CGFloat(1.0)
    }
}

public extension StackableExtension where ExtendedType == UIStackView {
    
    var hairlineColor: UIColor? {
        get { return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.hairlineColor) as? UIColor }
        set { objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.hairlineColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var hairlineThickness: CGFloat? {
        get { return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.hairlineThickness) as? CGFloat }
        set { objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.hairlineThickness, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var hairlineProvider: StackableHairlineProvider? {
        get { return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.hairlineProvider) as? StackableHairlineProvider }
        set { objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.hairlineProvider, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    static var hairlineColor: UIColor?
    static var hairlineThickness: CGFloat?
    static var hairlineProvider: StackableHairlineProvider?
    
}
