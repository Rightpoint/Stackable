//
//  Stackable+Debug.swift
//  Stackable
//
//  Created by Jason Clark on 8/18/20.
//

import Foundation

public extension StackableExtension where ExtendedType == UIStackView {

    var debug: DebugStackableExtension  {
        get {
            return DebugStackableExtension(base)
        }
        set {}
    }
    
}

public class DebugStackableExtension {

    public private(set) var stack: UIStackView
    public init(_ stack: UIStackView) {
        self.stack = stack
    }
    
}

public extension DebugStackableExtension {

    func showOutlines() {
        stack.debug_outline(recurse: true)
    }
    
    func showMargins() {
        stack.debug_showMargins(recurse: true)
    }
    
    func showSpaces() {
        stack.debug_showSpaces(axis: stack.axis)
    }
        
}

private extension UIView {
    
    func debug_outline(recurse: Bool) {
        if let stackView = (self as? UIStackView), recurse {
            stackView.arrangedSubviews.forEach { $0.debug_outline(recurse: true) }
        }
        else if recurse {
            subviews.forEach { $0.debug_outline(recurse: true) }
        }
        
        let axIdBlacklist: [String] = [
            UIStackView.stackable.axID.space,
            UIStackView.stackable.axID.hairline,
            UIStackView.stackable.axID.debug.outline,
            UIStackView.stackable.axID.debug.margin,
            UIStackView.stackable.axID.debug.space,
        ]
        
        if let axID = accessibilityIdentifier, axIdBlacklist.contains(axID) { return }
        
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

    func debug_showMargins(recurse: Bool) {
        if recurse {
            if let stackView = (self as? UIStackView) {
                stackView.arrangedSubviews.forEach { $0.debug_showMargins(recurse: true) }
            }
            else {
                subviews.forEach { $0.debug_showMargins(recurse: true) }
            }
        }
        
        let axIdBlacklist: [String] = [
            UIStackView.stackable.axID.space,
            UIStackView.stackable.axID.hairline,
            UIStackView.stackable.axID.debug.outline,
            UIStackView.stackable.axID.debug.margin,
            UIStackView.stackable.axID.debug.space,
        ]
        
        if let axID = accessibilityIdentifier, axIdBlacklist.contains(axID) { return }
        
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
    
    func debug_showSpaces(axis: NSLayoutConstraint.Axis) {
        switch self  {
            case _ where accessibilityIdentifier == UIStackView.stackable.axID.space:
                let axID = UIStackView.stackable.axID.debug.space
                guard !subviews.contains(where: {
                    $0.accessibilityIdentifier == axID
                })
                else { return }
                
                guard let constraint = constraints.first else { return }
                let isFlexible = constraint.relation != .equal
                
                let debugView = DebugView(.init(
                    shape: axis == .vertical ? .height : .width,
                    lineStyle: isFlexible ? .dashed : .solid,
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
                stackView.arrangedSubviews.forEach {
                    $0.debug_showSpaces(axis: stackView.axis)
                }
                
            default:
                subviews.forEach { $0.debug_showSpaces(axis: axis) }
        }
    }
    
}

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
                
                let insetTransform = CGAffineTransform(translationX: config.lineWidth, y: 0)
                
                let start = CGPoint(x: bounds.minX, y: bounds.midY)
                    .applying(insetTransform)
                let end = CGPoint(x: bounds.maxX, y: bounds.midY)
                    .applying(insetTransform.inverted())
                
                path.move(to: start)
                path.addLine(to: end)
                
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
