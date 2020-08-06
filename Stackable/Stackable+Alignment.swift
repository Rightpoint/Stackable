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
    
}

public extension Array where Element: StackableView {
    
    func aligned(_ alignment: StackableAlignment) -> [StackableViewItem] {
        return map { $0.aligned(alignment) }
    }
    
    func inset(by margins: UIEdgeInsets) -> [StackableViewItem] {
        return map { $0.inset(by: margins) }
    }
 
}

extension StackableViewItem: StackableView {
    
    public func makeStackableView(for stackView: UIStackView) -> UIView {
        let view = makeView(stackView)
        return AlignmentView(view, alignment: alignment, inset: inset)
    }

}
