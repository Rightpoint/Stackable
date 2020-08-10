//
//  UIView+BindVisible.swift
//  Stackable
//
//  Created by Jason Clark on 8/3/20.
//

import Foundation

// MARK: Bind Visible
extension NSKeyValueObservation: Attachable {}
internal extension UIView {
    
    func bindVisible(to view: UIView) {
        let isHiddenObservation = view.observe(\.isHidden, options: .initial, changeHandler: { [weak self] (view, _) in
            self?.isHidden = view.isHidden
        })
        isHiddenObservation.attach(to: self)
    }
    
    func bindVisible(toAllVisible views: [UIView]) {
        views.forEach { view in
            let isHiddenObservation = view.observe(\.isHidden, options: .initial, changeHandler: { [weak self] (_, _) in
                self?.isHidden = views.contains { $0.isHidden }
            })
            isHiddenObservation.attach(to: self)
        }
    }
    
    func bindVisible(toAnyVisible views: [UIView]) {
        views.forEach { view in
            let isHiddenObservation = view.observe(\.isHidden, options: .initial, changeHandler: { [weak self] (_, _) in
                self?.isHidden = views.allSatisfy { $0.isHidden }
             })
             isHiddenObservation.attach(to: self)
         }
    }

}
