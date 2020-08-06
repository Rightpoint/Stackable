//
//  Stackable+Alignment.swift
//  Stackable
//
//  Created by Jason Clark on 8/3/20.
//

import Foundation

public struct StackableViewItem {
    internal let makeView: (UIStackView) -> UIView
    internal var alignment: StackableAlignment = []
    internal var inset: UIEdgeInsets = .zero
    internal var outsetAncestor: UIView? = nil
}

public extension StackableView {
    
    func aligned(_ alignment: StackableAlignment) -> StackableViewItem {
        return StackableViewItem(
            makeView: makeStackableView(for:), //TODO: retain cycle?
            alignment: alignment
        )
    }
    
    func inset(by margins: UIEdgeInsets) -> StackableViewItem {
        return StackableViewItem(
            makeView: makeStackableView(for:), //TODO: retain cycle?
            inset: margins
        )
    }
    
    func outset(to ancestor: UIView) -> StackableViewItem {
        return StackableViewItem(
            makeView: makeStackableView(for:), //TODO: retain cycle?
            outsetAncestor: ancestor
        )
    }
    
}

public extension StackableViewItem  {
    
    func aligned(_ alignment: StackableAlignment) -> Self {
        var item = self
        item.alignment = alignment
        return item
    }

    func inset(by margins: UIEdgeInsets) -> Self {
        var item = self
        item.inset = margins
        return item
    }

    func outset(to ancestor: UIView) -> Self {
        var item = self
        item.outsetAncestor = ancestor
        return item
    }
    
}

public extension Array where Element: StackableView {
    
    func aligned(_ alignment: StackableAlignment) -> [StackableViewItem] {
        return map { $0.aligned(alignment) }
    }
    
    func inset(by margins: UIEdgeInsets) -> [StackableViewItem] {
        return map { $0.inset(by: margins) }
    }
 
    func outset(to ancestor: UIView) -> [StackableViewItem] {
        return map  { $0.outset(to: ancestor) }
    }
    
}

public extension Array where Element == StackableViewItem {
    
    func aligned(_ alignment: StackableAlignment) -> [StackableViewItem] {
        return map { $0.aligned(alignment) }
    }
    
    func inset(by margins: UIEdgeInsets) -> [StackableViewItem] {
        return map { $0.inset(by: margins) }
    }
 
    func outset(to ancestor: UIView) -> [StackableViewItem] {
        return map  { $0.outset(to: ancestor) }
    }
    
}

extension StackableViewItem: StackableView {
    
    public func makeStackableView(for stackView: UIStackView) -> UIView {
        let view = makeView(stackView)
        return AlignmentView(view, alignment: alignment, inset: inset)
    }
    
    public func configure(stackView: UIStackView) {
        let source = makeStackableView(for: stackView)
        let wrapped = outsetIfNecessary(
            view: source,
            outsetAncestor: outsetAncestor,
            inset: .zero, // Margins are already applied from `makeStackableView`
            stackView: stackView
        ).makeStackableView(for: stackView)
        stackView.addArrangedSubview(wrapped)
        applyOutsetConstraint(view: source, outsetAncestor: outsetAncestor, stackView: stackView)
    }

}

internal extension Stackable {
    
    func outsetIfNecessary(view: UIView, outsetAncestor: UIView?, inset: UIEdgeInsets, stackView: UIStackView) -> StackableView {
        if outsetAncestor == nil, inset == .zero { return view }
        
        switch stackView.axis {
        case .horizontal:
            var wrapper = view.inset(by: inset)
            if outsetAncestor != nil {
                wrapper = wrapper
                    .aligned(.flexVertical)
            }
            return wrapper
            
        case .vertical:
            var wrapper = view.inset(by: inset)
            if outsetAncestor != nil {
                wrapper = wrapper
                    .aligned(.flexHorizontal)
            }
            return wrapper
            
        @unknown default:
            // We've hit some new cool stackview axis that we don't support yet
            debugPrint("Unsupported stackView axis: \(stackView.axis)")
            return view
        }
    }
    
    func applyOutsetConstraint(view: UIView, outsetAncestor: UIView?, stackView: UIStackView) {
        if let ancestor = outsetAncestor {
            switch stackView.axis {
            case .horizontal:
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: ancestor.topAnchor),
                    view.bottomAnchor.constraint(equalTo: ancestor.bottomAnchor),
                ])
                
            case .vertical:
                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: ancestor.leadingAnchor),
                    view.trailingAnchor.constraint(equalTo: ancestor.trailingAnchor),
                ])
                
            @unknown default:
                // We've hit some new cool stackview axis that we don't support yet
                debugPrint("Unsupported stackView axis: \(stackView.axis)")
            }
        }
    }
    
}
