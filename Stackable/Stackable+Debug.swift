//
//  Stackable+Debug.swift
//  Stackable
//
//  Created by Jason Clark on 8/18/20.
//  Copyright © 2020 Rightpoint. All rights reserved.
//

import Foundation

public extension StackableExtension where ExtendedType == UIStackView {

    /// Debug API extension point
    var debug: DebugStackableExtension  {
        get {
            return DebugStackableExtension(base)
        }
        set {}
    }
    
}

/// Type that acts as a generic extension point for all `StackableExtended` types.
public class DebugStackableExtension {

    public private(set) var stack: UIStackView
    public init(_ stack: UIStackView) {
        self.stack = stack
    }
    
}

// MARK: - Public API

public extension DebugStackableExtension {

    /// Draw an outline around all content subviews. Excludes `Stackable` spaces and hairlines.
    func showOutlines() {
        stack.debug_outline(recurse: true)
    }
    
    /// Draw an outline around all content subviews' layoutMarginsGuide. Excludes `Stackable` spaces and hairlines.
    func showMargins() {
        stack.debug_showMargins(recurse: true)
    }
    
    /// Illustrate the `Stackable` spaces of all children of this `UIStackView`. Fixed spaces represented by a solid line. Flexible spaces represented by a dotted line.
    func showSpaces() {
        stack.debug_showSpaces(axis: stack.axis)
    }

}

// MARK: - Private

private extension UIView {
    
    /// Add a view illustrating the outline of this view and every subview, excluding `Stackable` space, hairline, and debug views.
    func debug_outline(recurse: Bool) {
        
        // If recursive, dive into subviews or arranged subviews appropriately.
        if recurse {
            if let stackView = (self as? UIStackView) {
                stackView.arrangedSubviews.forEach {
                    $0.debug_outline(recurse: true)
                }
            }
            else {
                subviews.forEach { $0.debug_outline(recurse: true) }
            }
        }
        
        // list of accessibility identifiers to skip
        let axIdBlacklist: [String] = [
            UIStackView.stackable.axID.space,
            UIStackView.stackable.axID.hairline,
            UIStackView.stackable.axID.debug.outline,
            UIStackView.stackable.axID.debug.margin,
            UIStackView.stackable.axID.debug.space,
        ]
        
        if let axID = accessibilityIdentifier, axIdBlacklist.contains(axID) { return }
        
        // Make sure we haven't added an outline debug view already
        guard !subviews.contains(where: {
            $0.accessibilityIdentifier == UIStackView.stackable.axID.debug.outline
        }) else { return }
        
        let view = DebugView(.init(
            shape: .outline,
            lineStyle: .solid,
            color: .groupTableViewBackground,
            lineWidth: 2
        ))
        view.accessibilityIdentifier = UIStackView.stackable.axID.debug.outline
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    /// Add a view illustrating the `layoutMarginsGuide` of this view and every subview, excluding `Stackable` space, hairline, and debug views.
    func debug_showMargins(recurse: Bool) {
        
        // If recursive, dive into subviews or arranged subviews appropriately.
        if recurse {
            if let stackView = (self as? UIStackView) {
                stackView.arrangedSubviews.forEach {
                    $0.debug_showMargins(recurse: true)
                }
            }
            else {
                subviews.forEach { $0.debug_showMargins(recurse: true) }
            }
        }
        
        // list of accessibility identifiers to skip
        let axIdBlacklist: [String] = [
            UIStackView.stackable.axID.space,
            UIStackView.stackable.axID.hairline,
            UIStackView.stackable.axID.debug.outline,
            UIStackView.stackable.axID.debug.margin,
            UIStackView.stackable.axID.debug.space,
        ]
        
        if let axID = accessibilityIdentifier, axIdBlacklist.contains(axID) { return }
        
        // Make sure we haven't added an margin debug view already
        guard !subviews.contains(where: {
            $0.accessibilityIdentifier == UIStackView.stackable.axID.debug.margin
        }) else { return }
        
        let view = DebugView(.init(
            shape: .outline,
            lineStyle: .dashed,
            color: UIColor.black.withAlphaComponent(0.1),
            lineWidth: 2
        ))
        view.accessibilityIdentifier = UIStackView.stackable.axID.debug.margin
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            layoutMarginsGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            layoutMarginsGuide.topAnchor.constraint(equalTo: view.topAnchor),
            layoutMarginsGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            layoutMarginsGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    /// Add a view illustrating the direction and size of `Stackable` spaces in all subviews.
    func debug_showSpaces(axis: NSLayoutConstraint.Axis) {
        switch self  {
            // If we have landed on a StackableSpace, add debug view
            case _ where accessibilityIdentifier == UIStackView.stackable.axID.space:
                
                // Make sure we haven't added a debug space viz view already
                let axID = UIStackView.stackable.axID.debug.space
                guard !subviews.contains(where: {
                    $0.accessibilityIdentifier == axID
                })
                else { return }
                
                // Determine from the contstraints if this is a firm or flexible space.
                guard let constraint = constraints.first else { return }
                let isFlexible = constraint.relation != .equal
                
                // Flexible constraints get dashed lines
                let lineStyle: DebugView.LineStyle = isFlexible ? .dashed : .solid
                
                let debugView = DebugView(.init(
                    shape: axis == .vertical ? .height : .width,
                    lineStyle: lineStyle,
                    color: UIColor.red.withAlphaComponent(0.3),
                    lineWidth: 2
                ))
                debugView.accessibilityIdentifier = axID
                debugView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(debugView)
                
                NSLayoutConstraint.activate([
                    debugView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    debugView.topAnchor.constraint(equalTo: topAnchor),
                    debugView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    debugView.bottomAnchor.constraint(equalTo: bottomAnchor),
                ])
            
            case let stackView as UIStackView:
                // If we are a stack view, recurse
                stackView.arrangedSubviews.forEach {
                    $0.debug_showSpaces(axis: stackView.axis)
                }
                
            default:
                // otherwise, recurse to subviews if they exist
                subviews.forEach { $0.debug_showSpaces(axis: axis) }
        }
    }
    
}

/// A view that draws debug vizualizations, to be aligned with content views.
private class DebugView: UIView {
    
    struct Shape: OptionSet {
        public let rawValue: Int

        public static let outline = Shape(rawValue: 1 << 0)
        public static let width = Shape(rawValue: 1 << 1)
        public static let height = Shape(rawValue: 1 << 2)
    }
    
    enum LineStyle {
        case solid
        case dashed
    }
    
    struct Config {
        let shape: Shape
        let lineStyle: LineStyle
        let color: UIColor
        let lineWidth: CGFloat
    }
    
    enum Constant {
        static let endCapSize = CGFloat(5)
    }
    
    let config: Config
            
    lazy var outlineShapeLayer = ShapeLayer()
    lazy var centerXShapeLayer = ShapeLayer()
    lazy var centerYShapeLayer = ShapeLayer()
    
    init(_ config: Config) {
        self.config = config
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if config.shape.contains(.outline) {
            outlineShapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 0).cgPath
            outlineShapeLayer.frame = bounds
            outlineShapeLayer.position = .init(x: bounds.midX, y: bounds.midY)
        }
            
        if config.shape.contains(.height) {
            centerXShapeLayer.path = {
                let path = UIBezierPath()
                
                // Inset from bounds so stroke doesn't bleed over bounds
                let insetTransform = CGAffineTransform(translationX: 0, y: config.lineWidth)

                let start = CGPoint(
                    x: bounds.midX,
                    y: bounds.minY
                ).applying(insetTransform)
                
                let end = CGPoint(
                    x: bounds.midX,
                    y: bounds.maxY
                ).applying(insetTransform.inverted())
                
                path.move(to: start)
                path.addLine(to: end)
                
                // Transform that defines how far off of center we should draw endcaps
                let capTransform = CGAffineTransform(translationX: Constant.endCapSize, y: 0)
                
                path.move(to: start
                    .applying(capTransform)
                )
                path.addLine(to: start
                    .applying(capTransform.inverted())
                )
                
                path.move(to: end
                    .applying(capTransform)
                )
                path.addLine(to: end
                    .applying(capTransform.inverted())
                )
                
                return path.cgPath
            }()
            centerXShapeLayer.frame = bounds
            centerXShapeLayer.position = .init(x: bounds.midX, y: bounds.midY)
        }
            
        if config.shape.contains(.width) {
            centerYShapeLayer.path = {
                let path = UIBezierPath()
                
                // Inset from bounds so stroke doesn't bleed over bounds
                let insetTransform = CGAffineTransform(translationX: config.lineWidth, y: 0)
                
                let start = CGPoint(x: bounds.minX, y: bounds.midY)
                    .applying(insetTransform)
                let end = CGPoint(x: bounds.maxX, y: bounds.midY)
                    .applying(insetTransform.inverted())
                
                path.move(to: start)
                path.addLine(to: end)
                
                // Transform that defines how far off of center we should draw endcaps
                let capTransform = CGAffineTransform(translationX: 0, y: Constant.endCapSize)
                
                path.move(to: start
                    .applying(capTransform))
                path.addLine(to: start
                    .applying(capTransform.inverted())
                )
                
                path.move(to: end
                    .applying(capTransform)
                )
                path.addLine(to: end
                    .applying(capTransform.inverted())
                )
                
                return path.cgPath
            }()
            centerYShapeLayer.frame = bounds
            centerYShapeLayer.position = .init(x: bounds.midX, y: bounds.midY)
        }
    }
    
    func ShapeLayer() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        layer.addSublayer(shapeLayer)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = config.color.cgColor
        shapeLayer.lineWidth = config.lineWidth

        switch config.lineStyle {
        case .solid:
            break
            
        case .dashed:
            shapeLayer.lineJoin = CAShapeLayerLineJoin.round
            shapeLayer.lineDashPattern = [4, 2]
        }

        return shapeLayer
    }

}
