//
//  Stackable+Alignment.swift
//  Stackable
//
//  Created by Jason Clark on 8/3/20.
//  Copyright © 2020 Rightpoint. All rights reserved.
//

import Foundation

/// `StackableViewItem` carries information about how to build a source view, as well as any manipulations that need to be performed before being added to a stackView
public struct StackableViewItem {
    
    /// A closure defining how to create the view for a particular stackView
    internal let makeView: (UIStackView) -> UIView
    
    /// Alignment that should be applied to an `AlignmentView`
    internal var alignment: StackableAlignment = []
    
    /// Inset that should be applied to an `AlignmentView`
    internal var inset: UIEdgeInsets = .zero
    
    /// An ancestor to which the view should anchor its transverse-axis edges.
    /// For example, a hairline outset to the horizontal view edges for a vertical stack.
    internal var outsetAncestor: UIView? = nil
    
    /// An ancestor to which the view should align its transverse-axis layout margins.
    /// For example, a cell whose background should outset to the view edges, but whose margins should align with the stack.
    internal var marginsAncestor: UIView? = nil
}

// MARK: - Public API
public extension StackableView {
    
    /**
     Change the alignment of any `StackableView`. View will be wrapped in a container and constraints will be added within the container.
     
     Composable with other transforms, ie. `inset(by:)`.
     
     - Parameters:
        - alignment: A single or set of alignments that define the constraints to be added.
     
     - Returns: A `StackableViewItem` that can be further manipulated.
     
     ```
     stack.add([
        viewA.aligned(.right),
        viewB.aligned([.top, .left]),
        viewC
            .aligned(.centerX)
            .inset(by: .init(top: 20, left: 20, bottom: 20, right: 20),
     ])
     ```
     */
    func aligned(_ alignment: StackableAlignment) -> StackableViewItem {
        if var item = self as? StackableViewItem {
            item.alignment = alignment
            return item
        }
        
        return StackableViewItem(
            makeView: makeStackableView(for:),
            alignment: alignment
        )
    }
    
    /**
     Adjust the inset of any `StackableView`. View will be wrapped in a container and inset will be added within the container.
     
     Composable with other transforms, ie. `aligned`.
     
     - Parameters:
        - margins: `UIEdgeInsets` defining the margins to be applied to the container.
     
     - Returns: A `StackableViewItem` that can be further manipulated.

     ```
     stack.add([
        viewA.inset(by: .init(top: 20, left: 20, bottom: 20, right: 20),
        // negative margins work too!
        viewB.inset(by: .init(top: -20, left: 20, bottom: 20, right: -20),
        // composable with other transforms
        viewC
            .inset(by: .init(top: 20, left: 20, bottom: 20, right: 20),
            .aligned(.right)
     ])
     ```
     */
    func inset(by margins: UIEdgeInsets) -> StackableViewItem {
       if var item = self as? StackableViewItem {
            item.inset = margins
           return item
       }
        
        return StackableViewItem(
            makeView: makeStackableView(for:),
            inset: margins
        )
    }
    
    /**
     Outset the `StackableView` to anchor its transverse-axis edges (ie. horizontal for a vertical stack) with some ancestor.
     
     Composable with other transforms, ie. `margins(alignedWith:)`.
     
     - Precondition: Stack and ancestor need to be in same view hiearchy prior to applying this transform.
     
     - Parameters:
        - ancestor: A superView to which the transverse-axis edges (ie. horizontal for a vertical stack) should be anchored. Make sure to add your stack to the view hierachy before applying this transform. The subview and ancestor MUST be in the same view hierarchy at stack time.
     
     - Returns: A `StackableViewItem` that can be further manipulated.

     ```
     stack.add([
        UIImage(named: "Hero").outset(to: view),
     ])
     ```
     */
    func outset(to ancestor: UIView) -> StackableViewItem {
        if var item = self as? StackableViewItem {
            item.outsetAncestor = ancestor
            return item
        }
        
        return StackableViewItem(
            makeView: makeStackableView(for:),
            outsetAncestor: ancestor
        )
    }
    
    /**
     Align the transverse-axis layoutMarginsGuide (ie. leading and trailing for a vertical stack) of any `StackableView` to the layoutMarginsGuide of some ancestor.
     
     Composable with other transforms, ie. `outset(to:)`.
          
     - Parameters:
        - ancestor: A superView to which the transverse-axis layoutMarginsGuide (ie. leading and trailing for a vertical stack)  should be aligned with the `StackableView` transverse-axis layoutMarginsGuide.
     
     - Returns: A `StackableViewItem` that can be further manipulated.

     ```
     stack.add([
        cells
            .outset(to: view)
            .margins(alignedWith: stack),
     ])
     ```
     */
    func margins(alignedWith ancestor: UIView) -> StackableViewItem {
        if var item = self as? StackableViewItem {
            item.marginsAncestor = ancestor
            return item
        }
        
        return StackableViewItem(
            makeView: makeStackableView(for:),
            marginsAncestor: ancestor
        )
    }

}

public extension Array where Element: StackableView {
    
    /**
       Change the alignment of an array of `StackableView`. Views will be wrapped in a container and constraints will be added within the container.
       
       Composable with other transforms, ie. `inset(by:)`.
       
       - Parameters:
          - alignment: A single or set of alignments that define the constraints to be added.
       
       - Returns: An array of `StackableViewItem` that can be further manipulated.
       
       ```
       stack.add([
          viewA.aligned(.right),
          viewB.aligned([.top, .left]),
          viewC
              .aligned(.centerX)
              .inset(by: .init(top: 20, left: 20, bottom: 20, right: 20),
       ])
       ```
       */
    func aligned(_ alignment: StackableAlignment) -> [StackableViewItem] {
        return map { $0.aligned(alignment) }
    }
    
    /**
     Adjust the inset of an array of `StackableView`. Views will be wrapped in a container and inset will be added within the container.
     
     Composable with other transforms, ie. `aligned`.
     
     - Parameters:
        - margins: `UIEdgeInsets` defining the margins to be applied to the container.
     
     - Returns: An array of `StackableViewItem` that can be further manipulated.

     ```
     stack.add([
        viewA.inset(by: .init(top: 20, left: 20, bottom: 20, right: 20),
        // negative margins work too!
        viewB.inset(by: .init(top: -20, left: 20, bottom: 20, right: -20),
        // composable with other transforms
        viewC
            .inset(by: .init(top: 20, left: 20, bottom: 20, right: 20),
            .aligned(.right)
     ])
     ```
     */
    func inset(by margins: UIEdgeInsets) -> [StackableViewItem] {
        return map { $0.inset(by: margins) }
    }
 
    /**
     Outsets an array of `StackableView` to anchor their transverse-axis edges (ie. horizontal for a vertical stack) with some ancestor.
     
     Composable with other transforms, ie. `margins(alignedWith:)`.
     
     - Precondition: Stack and ancestor need to be in same view hiearchy prior to applying this transform.
     
     - Parameters:
        - ancestor: A superView to which the transverse-axis edges (ie. horizontal for a vertical stack) should be anchored. Make sure to add your stack to the view hierachy before applying this transform. The subview and ancestor MUST be in the same view hierarchy at stack time.
     
     - Returns: An array of `StackableViewItem` that can be further manipulated.

     ```
     stack.add([
        UIImage(named: "Hero").outset(to: view),
     ])
     ```
     */
    func outset(to ancestor: UIView) -> [StackableViewItem] {
        return map  { $0.outset(to: ancestor) }
    }
    
    /**
     Align the transverse-axis layoutMarginsGuide (ie. leading and trailing for a vertical stack) of an array of `StackableView` to the layoutMarginsGuide of some ancestor.
     
     Composable with other transforms, ie. `outset(to:)`.
          
     - Parameters:
        - ancestor: A superView to which the transverse-axis layoutMarginsGuide (ie. leading and trailing for a vertical stack)  should be aligned with the `StackableView` transverse-axis layoutMarginsGuide.
     
     - Returns: An array of `StackableViewItem` that can be further manipulated.

     ```
     stack.add([
        cells
            .outset(to: view)
            .margins(alignedWith: stack),
     ])
     ```
     */
    func margins(alignedWith ancestor: UIView) -> [StackableViewItem] {
        return map { $0.margins(alignedWith: ancestor) }
    }
    
}

// MARK: - StackableViewItem StackableView conformance
extension StackableViewItem: StackableView {
    
    public func makeStackableView(for stackView: UIStackView) -> UIView {
        let view = makeView(stackView)
        
        // resist wrapping the source view unless we have to
        if alignment.isEmpty && inset == .zero  {
            return view
        }
        else  {
            return AlignmentView(view, alignment: alignment, inset: inset)
        }
    }
    
    public func configure(stackView: UIStackView) {
        // make source view, including alignment and inset
        let source = makeStackableView(for: stackView)
        
        // wrap it in a flex container if necessary, excluding inset
        let wrapped = outsetIfNecessary(
            view: source,
            outsetAncestor: outsetAncestor,
            inset: .zero, // Margins are already applied from `makeStackableView`
            stackView: stackView
        ).makeStackableView(for: stackView)

        // add to view hierachy
        stackView.addArrangedSubview(wrapped)
        
        // apply outset constraints if necessary
        applyOutsetConstraint(view: source, outsetAncestor: outsetAncestor, stackView: stackView)
        
        // apply margins observation if necessary
        applyMarginsObservation(view: source, marginsAncestor: marginsAncestor, stackView: stackView)
    }

}

internal extension Stackable {
    
    // If `outsetAncestor` exists, wrap in AlignmentView with a flex on the transverse-axis. This will free the view to accept edge constraints beyond the bounds of the stackView. Currently used by both `StackableViewItem` and `StackableHairline`
    // TODO: Consider marrying behind a shared protocol so there is only one call site.
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
    
    // If `outsetAncestor` exists, apply constraints to the transverse-axis edges of the ancestor.
    // Currently used by `StackableViewItem` and `StackableHairline`
    // TODO: Consider marrying behind a shared protocol so there is only one call site.
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
    
    
    // If `marginsAncestor` exists, attach an observation monitoring frame changes of the ancestor.
    // Update layout margins to line up `layoutMarginsGuide` in the global coordinate space.
    func applyMarginsObservation(view: UIView, marginsAncestor: UIView?, stackView: UIStackView) {
        if let ancestor = marginsAncestor {
            if let alignment = view as? AlignmentView, let subview = alignment.subviews.first {
                applyMarginsObservation(view: subview, marginsAncestor: marginsAncestor, stackView: stackView)
                return
            }
            
            let observation = ancestor.observe(\.frame, options: [.initial, .new]) { _, _ in
                let bounds = view.bounds
                let ancestorBounds = view.convert(ancestor.bounds, to: view)
                
                switch stackView.axis {
                case .horizontal:
                    let top = (ancestorBounds.minY - bounds.minY) + ancestor.layoutMargins.top
                    let bottom = (bounds.maxY - ancestorBounds.maxY) + ancestor.layoutMargins.bottom
                    view.layoutMargins.top = top
                    view.layoutMargins.bottom = bottom
                    
                case .vertical:
                    let left = (ancestorBounds.minX - bounds.minX) + ancestor.layoutMargins.left
                    let right = (bounds.maxX - ancestorBounds.maxX) + ancestor.layoutMargins.right
                    view.layoutMargins.left = left
                    view.layoutMargins.right = right
                    
                @unknown default:
                    // We've hit some new cool stackview axis that we don't support yet
                    debugPrint("Unsupported stackView axis: \(stackView.axis)")
                    
                }
            }
            observation.attach(to: view)
        }
    }
    
}
