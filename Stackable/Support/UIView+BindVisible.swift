//
//  UIView+BindVisible.swift
//  Stackable
//
//  Created by Jason Clark on 8/3/20.
//  Copyright © 2020 Rightpoint. All rights reserved.
//

import UIKit

// MARK: Bind Visible
// Use this pattern to monitor `.isHidden` of some other view, and update `self.isHidden` to match.
extension NSKeyValueObservation: Attachable {}
private extension UIView {
    
    /// Observe `.isHidden` of `view`, and update `self.isHidden` to match.
    /// - Parameter view: The view to observe.
    func bindVisible(to view: UIView) {
        let isHiddenObservation = view.observe(\.isHidden, options: .initial, changeHandler: { [weak self] (view, _) in
            self?.isHidden = view.isHidden
        })
        isHiddenObservation.attach(to: self)
    }
    
    /// Observe `.isHidden` of `views`, and update `self.isHidden` to `false` ONLY if all of `views` are visible.
    /// - Parameter view: The view to observe.
    func bindVisible(toAllVisible views: [UIView]) {
        views.forEach { view in
            let isHiddenObservation = view.observe(\.isHidden, options: .initial, changeHandler: { [weak self] (_, _) in
                self?.isHidden = views.contains { $0.isHidden }
            })
            isHiddenObservation.attach(to: self)
        }
    }
    
    /// Observe `.isHidden` of `views`, and update `self.isHidden` to `false` if ANY of `views` are visible.
    /// - Parameter view: The view to observe.
    func bindVisible(toAnyVisible views: [UIView]) {
        views.forEach { view in
            let isHiddenObservation = view.observe(\.isHidden, options: .initial, changeHandler: { [weak self] (_, _) in
                self?.isHidden = views.allSatisfy { $0.isHidden }
             })
             isHiddenObservation.attach(to: self)
         }
    }

}

public extension StackableExtension where ExtendedType: UIView {
    
    /// Observe `.isHidden` of `view`, and update `self.isHidden` to match.
    /// - Parameter view: The view to observe.
    func bindVisible(to view: UIView) {
        base.bindVisible(to: view)
    }
    
    /// Observe `.isHidden` of `views`, and update `self.isHidden` to `false` ONLY if all of `views` are visible.
    /// - Parameter view: The view to observe.
    func bindVisible(toAllVisible views: [UIView]) {
        base.bindVisible(toAllVisible: views)
    }
    
    /// Observe `.isHidden` of `views`, and update `self.isHidden` to `false` if ANY of `views` are visible.
    /// - Parameter view: The view to observe.
    func bindVisible(toAnyVisible views: [UIView]) {
        base.bindVisible(toAnyVisible: views)
    }

}
