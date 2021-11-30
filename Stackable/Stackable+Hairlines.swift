//
//  Stackable+Hairlines.swift
//  Stackable
//
//  Created by Jason Clark on 8/3/20.
//  Copyright © 2020 Rightpoint. All rights reserved.
//

import UIKit

/// `StackableHairline` carries information about where to build a hairline, as well as any manipulations that need to be performed before being added to a stackView.
public struct StackableHairline {
    
    /// Defines the on-axis layout rules for the hairline
    internal enum HairlineType {
        /// Hairline is added to current end of stackview.
        case next
        
        /// If `view` is provided, hairline is added after it and mirrors the visibility of the view. If `view` is `nil`, no hairline is added.
        case after(_ view: UIView?)
        
        /// If `view1` and `view2` is provided, hairline is added after `view1`. Hairline monitors visibility of both views and is only visible if both views are visible. If either view is `nil`, no hairline is added.
        case between(_ view1: UIView?, _ view2: UIView?)
        
        /// If `view` is provided, hairline is added before `view`. Hairline monitors visibility of `view`. If `view` is `nil`, no hairline is added.
        case before(_ view: UIView?)
        
        /// If `view` is provided, hairlines are added before and after `view`. Hairlines monitors visibility of `view`. If `view` is `nil`, no hairline is added.
        case around(_ view: UIView?)
    }
    
    /// Holds the on-axis layout rules for the hairline
    internal let type: HairlineType
    
    /// Holds the custom thickness to be applied to this hairline
    internal var thicknessOverride: CGFloat?
    /// Holds the custom color to be applied to this hairline
    internal var colorOverride: UIColor?
    
    /// Holds the inset to be applied to this hairline
    internal var inset: UIEdgeInsets = .zero
    
    /// An ancestor to which the view should anchor its transverse-axis edges.
    /// For example, a hairline outset to the horizontal view edges for a vertical stack.
    internal var outsetAncestor: UIView?
}

// MARK: - Public API
public extension StackableExtension where ExtendedType: UIStackView {
    /// Add a hairline to the stackView
    static var hairline: StackableHairline {
        return .init(type: .next)
    }
    /// Add a hairline to the stackView immediately after `view`. Hairline will mirror the visibilty of `view`.
    static func hairline(after view: UIView) -> StackableHairline {
        return .init(type: .after(view))
    }
    /// Add a hairline between two views. Hairline will be visible if both views are visible.
    static func hairlineBetween(_ view1: UIView?, _ view2: UIView?) -> StackableHairline {
        return .init(type: .between(view1, view2))
    }
    /// Add a hairline before a view. Hairline will mirror the visibilty of `view`.
    static func hairline(before view: UIView?) -> StackableHairline {
        return .init(type: .before(view))
    }
    /// Add a hairline above and below a view. Hairlines will mirror the visibilty of `view`.
    static func hairline(around view: UIView?) -> StackableHairline {
        return .init(type: .around(view))
    }
    /// Add hairlines between each visible view in `views`.
    static func hairlines(between views: [UIView]) -> [StackableHairline] {
        let pairs = zip(views, views.dropFirst())
        return pairs.map { UIStackView.stackable.hairlineBetween($0.0, $0.1) }
    }
    /// Add hairlines after each visible view in `views`.
    static func hairlines(after views: [UIView]) -> [StackableHairline] {
        return views.map { UIStackView.stackable.hairline(after: $0) }
    }
    /// Add around each visible view in `views`.
    static func hairlines(around views: [UIView]) -> [StackableHairline] {
        return views.map { $0 == views.first
            ? UIStackView.stackable.hairline(around: $0)
            : UIStackView.stackable.hairline(after: $0)
        }
    }
}

public extension StackableHairline {
    
    /**
     Adjust the inset of a `StackableHairline`.
          
     - Parameters:
        - margins: `UIEdgeInsets` defining the margins to be applied to the hairline.
     
     - Returns: A `StackableHairline` that can be further manipulated.

     ```
     stack.add([
        UIStackView.stackable.hairline
            .inset(by: .init(top: 20, left: 20, bottom: 20, right: 20),
        // negative margins work too!
        UIStackView.stackable.hairline
            .inset(by: .init(top: -20, left: 20, bottom: 20, right: -20),
        // composable with other transforms
        UIStackView.stackable.hairline
            .inset(by: .init(top: 20, left: 20, bottom: 20, right: 20)
            .thickness(1)
     ])
     ```
     */
    func inset(by margins: UIEdgeInsets) -> StackableHairline {
        var hairline = self
        hairline.inset = margins
        return hairline
    }
    
    /**
     Outset the `StackableHairline` to anchor its transverse-axis edges (ie. horizontal for a vertical stack) with some ancestor.
     
     - Precondition: Stack and ancestor need to be in same view hiearchy prior to applying this transform.
     
     - Parameters:
        - ancestor: A superView to which the transverse-axis edges (ie. horizontal for a vertical stack) should be anchored. Make sure to add your stack to the view hierachy before applying this transform. The subview and ancestor MUST be in the same view hierarchy at stack time.
     
     - Returns: A `StackableHairline` that can be further manipulated.

     ```
     stack.add([
        UIStackView.stackable.hairline.outset(to: view),
     ])
     ```
     */
    func outset(to ancestor: UIView) -> StackableHairline {
        var hairline = self
        hairline.outsetAncestor = ancestor
        return hairline
    }
    
    /**
     Customize the thickness of a `StackableHairline`.
          
     - Parameters:
        - thickness: A CGFloat defining the on-axis thickenss of the hairline.
     
     - Returns: A `StackableHairline` that can be further manipulated.

     ```
     stack.add([
        UIStackView.stackable.hairline
            .thickenss(2),
     ])
     ```
     */
    func thickness(_ thickness: CGFloat) -> StackableHairline {
        var hairline = self
        hairline.thicknessOverride = thickness
        return hairline
    }
    
    /**
     Customize the color of a `StackableHairline`.
          
     - Parameters:
        - color: A UIColor defining the color of the hairline.
     
     - Returns: A `StackableHairline` that can be further manipulated.

     ```
     stack.add([
        UIStackView.stackable.hairline
            .color(.lightGray),
     ])
     ```
     */
    func color(_ color: UIColor) -> StackableHairline {
        var hairline = self
        hairline.colorOverride = color
        return hairline
    }
    
}

public extension Array where Element == StackableHairline {
    
    /**
     Adjust the inset of an array of `StackableHairline`.
          
     - Parameters:
        - margins: `UIEdgeInsets` defining the margins to be applied to the hairlines.
     
     - Returns: An array of `StackableHairline` that can be further manipulated.

     ```
     stack.add([
        UIStackView.stackable.hairline
            .inset(by: .init(top: 20, left: 20, bottom: 20, right: 20),
        // negative margins work too!
        UIStackView.stackable.hairline
            .inset(by: .init(top: -20, left: 20, bottom: 20, right: -20),
        // composable with other transforms
        UIStackView.stackable.hairline
            .inset(by: .init(top: 20, left: 20, bottom: 20, right: 20)
            .thickness(1)
     ])
     ```
     */
    func inset(by margins: UIEdgeInsets) -> Self {
        return map { $0.inset(by: margins) }
    }
    
    /**
      Outset an array of `StackableHairline` to anchor their transverse-axis edges (ie. horizontal for a vertical stack) with some ancestor.
      
      - Precondition: Stack and ancestor need to be in same view hiearchy prior to applying this transform.
      
      - Parameters:
         - ancestor: A superView to which the transverse-axis edges (ie. horizontal for a vertical stack) should be anchored. Make sure to add your stack to the view hierachy before applying this transform. The subview and ancestor MUST be in the same view hierarchy at stack time.
      
      - Returns: An array of `StackableHairline` that can be further manipulated.

      ```
      stack.add([
        cells,
        UIStackView.stackable.hairlines(around: cells)
            .outset(to: view),
      ])
      ```
      */
    func outset(to ancestor: UIView) -> Self {
        return map { $0.outset(to: ancestor) }
    }
    
    /**
     Customize the thickness of an array of `StackableHairline`.
          
     - Parameters:
        - thickness: A CGFloat defining the on-axis thickness of the hairlines.
     
     - Returns: An array of `StackableHairline` that can be further manipulated.

     ```
     stack.add([
        cells,
        UIStackView.stackable.hairlines(around: cells)
            .thickness(2),
     ])
     ```
     */
    func thickness(_ thickness: CGFloat) -> Self {
        return map { $0.thickness(thickness) }
    }
    
    /**
     Customize the color of an array of `StackableHairline`.
          
     - Parameters:
        - color: A UIColor defining the color of the hairlines.
     
     - Returns: An array of `StackableHairline` that can be further manipulated.

     ```
     stack.add([
        cells,
        UIStackView.stackable.hairlines(around: cells)
            .color(.lightGray),
     ])
     ```
     */
    func color(_ color: UIColor) -> Self {
        return map { $0.color(color) }
    }
    
}

/// A simple hairline view with a color and thickness.
internal final class StackableHairlineView: UIView {
    
    
    /// Creates a hairline.
    /// - Parameters:
    ///   - axis: This should be the stackView.axis, thickness constraint is applied along this direction.
    ///   - thickness: Applied as a constraint along the stackView.axis.
    ///   - color: Applied as a background color of the view.
    init(stackAxis axis: NSLayoutConstraint.Axis, thickness: CGFloat, color: UIColor) {
        super.init(frame: .zero)
        
        accessibilityIdentifier = UIStackView.stackable.axID.hairline
        
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
        // Add hairline before specific view if necessary.
        if let view = hairlineBeforeView {
            insertHairline(stackView: stackView) { stack, hairline in
                stack.stackable.insertArrangedSubview(hairline, beforeArrangedSubview: view)
            }
        }
        // Add hairline after specific view if necessary. Note that the `.around` hairline type adds a hairline above and below a view, so this should NOT be an `else if`.
        if let view = hairlineAfterView {
            insertHairline(stackView: stackView) { stack, hairline in
                stack.stackable.insertArrangedSubview(hairline, afterArrangedSubview: view)
            }
        }
        // For a simple hairline with no specific view provided, append hairline to arrangedSubviews.
        if case .next = type {
            insertHairline(stackView: stackView) { stack, hairline in
                stack.addArrangedSubview(hairline)
            }
        }
    }
    
    /// Constructs a hairline, applies any required transforms, inserts it into stack using the provided closure, and applies ancestor constraints if necessary.
    /// - Parameters:
    ///   - stackView: The stackView that the hairlines should be constructed for
    ///   - insert: A clousure inserting the hairline `UIView` into the given `UIStackView`
    private func insertHairline(stackView: UIStackView, insert: (UIStackView, UIView) -> Void) {
         let hairline = makeHairline(stackView: stackView)
         let outsetHairline = outsetIfNecessary(
             view: hairline,
             outsetAncestor: outsetAncestor,
             inset: inset,
             stackView: stackView)
             .makeStackableView(for: stackView)
         insert(stackView, outsetHairline)
         applyOutsetConstraint(view: hairline, outsetAncestor: outsetAncestor, stackView: stackView)
     }
    
    /// Constructs a single hairline for a given `UIStackView`.
    /// `.hairlineProvider` will be used if provided from the `UIStackView` instance, then global config. If not provided, will use default `StackableHairlineView`
    /// Superficial config like `.thickness` and `.color` are coalesced to prefer first local styling on the `StackableHairline`, then to `UIStackView` instance-based styling (`stackView.stackable.hairlineColor`), then to `UIStackView` global-based styling (`UIStackView.stackable.hairlineColor`), and finally to internal defaults.
    /// - Parameter stackView: The `UIStackView` to make the hairline for
    /// - Returns: A `StackableHairlineView`
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
        
        // Hairline is only visible if all associated views are visible. For example, a `.between` hairline should only be visible if both provided views are visible.
        hairline.stackable.bindVisible(toAllVisible: allViews)
        return hairline
    }
    
    
    /// Every view the `StackableHairline` is associated with and should monitor visibility for.
    private var allViews: [UIView] {
        switch type {
        case .next: return []
        case .after(let view): return [view].compactMap { $0 }
        case .between(let v0, let v1): return [v0, v1].compactMap { $0 }
        case .before(let view): return [view].compactMap { $0 }
        case .around(let view): return [view].compactMap { $0 }
        }
    }
    
    /// The view the `StackableHairline` should be inserted after in the stack.
    private var hairlineAfterView: UIView? {
        switch type {
        case .next: return nil
        case .after(let view): return view
        case .between(let v0, .some): return v0
        case .between: return nil
        case .before: return nil
        case .around(let view): return view
        }
    }
    
    /// The view the `StackableHairline` should be inserted before in the stack.
    private var hairlineBeforeView: UIView? {
        switch type {
        case .next: return nil
        case .after: return nil
        case .between: return nil
        case .before(let view): return view
        case .around(let view): return view
        }
    }
}

/// A custom hairline provider  must vend some view to use as a hairline given the `UIStackView`
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

public extension StackableExtension where ExtendedType: UIStackView {
    
    /// Instance-based `UIStackView` color override. Ultimate styling will prefer hairline-instance config first, but will prefer this over `UIStackView` static config.
    var hairlineColor: UIColor? {
        get { return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.hairlineColor) as? UIColor }
        set { objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.hairlineColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// Instance-based `UIStackView` thickness override. Ultimate styling will prefer hairline-instance config first, but will prefer this over `UIStackView` static config.
    var hairlineThickness: CGFloat? {
        get { return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.hairlineThickness) as? CGFloat }
        set { objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.hairlineThickness, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// Instance-based `UIStackView` hairlineProvider override. Will prefer this over `UIStackView` static config.
    var hairlineProvider: StackableHairlineProvider? {
        get { return objc_getAssociatedObject(base, &type(of: base).AssociatedKeys.hairlineProvider) as? StackableHairlineProvider }
        set { objc_setAssociatedObject(base, &type(of: base).AssociatedKeys.hairlineProvider, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// Static `UIStackView` color override. Ultimate styling will prefer hairline-instance config first, then `UIStackView` instance config.
    static var hairlineColor: UIColor? {
        get { return objc_getAssociatedObject(self, &UIStackView.AssociatedKeys.hairlineColor) as? UIColor }
        set { objc_setAssociatedObject(self, &UIStackView.AssociatedKeys.hairlineColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// Static `UIStackView` thickness override. Ultimate styling will prefer hairline-instance config first, then `UIStackView` instance config.
    static var hairlineThickness: CGFloat? {
        get { return objc_getAssociatedObject(self, &UIStackView.AssociatedKeys.hairlineThickness) as? CGFloat }
        set { objc_setAssociatedObject(self, &UIStackView.AssociatedKeys.hairlineThickness, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// Static `UIStackView` hairlineProvider override. Ultimate styling will prefer `UIStackView` instance config.
    static var hairlineProvider: StackableHairlineProvider? {
        get { return objc_getAssociatedObject(self, &UIStackView.AssociatedKeys.hairlineProvider) as? StackableHairlineProvider }
        set { objc_setAssociatedObject(self, &UIStackView.AssociatedKeys.hairlineProvider, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
}
