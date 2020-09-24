//
//  Stackable.swift
//  Stackable
//
//  Created by Jay Clark on 7/30/20.
//  Copyright © 2020 Rightpoint. All rights reserved.
//

import UIKit

// MARK: - Stackable
/**
 Any object conforming to `Stackable` simply needs to define how it interacts with a `UIStackView`, most often by adding views or spacing.
 
 Objects that simply add a single arranged subview can conform to `StackableView` instead to receive automatic insetting and alignment functionality.
 
 ```
 // example `String` conformance
 extension String: Stackable {
    func configure(stackView: UIStackView) {
        let label = UILabel()
        label.text = self
        stackView.addArrangedSubview(label)
    }
 }
 ```
*/
public protocol Stackable {
    /**
     Any object conforming to `Stackable` simply needs to define how it interacts with a `UIStackView`, most often by adding views or spacing.
     
     Never call this method directly.
     
     Objects that simply add a single arranged subview can conform to `StackableView` instead to receive automatic insetting and alignment functionality.
     
     - Parameters:
        - stackView: The `UIStackView` to be manipulated.
     
     ```
     // example `String` conformance
     extension String: Stackable {
        func configure(stackView: UIStackView) {
            let label = UILabel()
            label.text = self
            stackView.addArrangedSubview(label)
        }
     }
     ```
    */
    func configure(stackView: UIStackView)
}

// MARK: - StackableView
/**
 Conformance to `StackableView` receive automatic conformance to `Stackable`, and inherit functionality for insetting and alignment.
 
 Types that manipulate a stackView further than simply adding a single arranged subview should conform to `Stackable` directly.
 
 ```
 // example `String` conformance
 extension String: Stackable {
    func makeStackableView(for stackView: UIStackView) -> UIView
        let label = UILabel()
        label.text = self
        return label
    }
 }
 ```
 */
public protocol StackableView: Stackable {
    /**
     Conformance to `StackableView` receive automatic conformance to `Stackable`, and inherit functionality for insetting and alignment.
     
     Types that manipulate a stackView further than simply adding a single arranged subview should conform to `Stackable` directly.

     - Parameters:
        - stackView: The `UIStackView` that your view will be added to. Should not be manipulated, but can be queried for  `.axis`, etc.
     
     - Returns: A `UIView` to be added to `stackView`.

     ```
     // example `String` conformance
     extension String: Stackable {
        func makeStackableView(for stackView: UIStackView) -> UIView
            let label = UILabel()
            label.text = self
            return label
        }
     }
     ```
     */
    func makeStackableView(for stackView: UIStackView) -> UIView
}

// Default Stackable conformance for StackableView
extension StackableView {
    public func configure(stackView: UIStackView) {
        let view = makeStackableView(for: stackView)
        stackView.addArrangedSubview(view)
    }
}

// MARK: - UIStackView Public API
extension UIView: StackableExtended {}
extension StackableExtension where ExtendedType == UIStackView {

    /**
     Adds a `Stackable` item to the stackView.

     - Parameters:
        - stackable: Any object conforming to `Stackable`
     
     ```
     let stackView = UIStackView()
     stackView.stackable.add("Hello World!")
     stackView.stackable.add(20)
     stackView.stackable.add(UIStackView.stackable.hairline)
     stackView.stackable.add(UIStackView.stackable.flexibleSpace)
     ```
     */
    public func add(_ stackable: Stackable) {
        add([stackable])
    }

    /**
     Adds `Stackable` items to the stackView.

     - Parameters:
        - stackables: An array of `Stackable` elements. Does not need to be homogenous.
     
     ```
     let stackView = UIStackView()
     let cells: [UIView] = ...
     stackView.stackable.add([
        "Hello World!",
        20,
        UIStackView.stackable.hairline,
        cells,
        UIStackView.stackable.flexibleSpace,
     ])
     ```
     */
    public func add(_ stackables: [Stackable]) {
        stackables.forEach { $0.configure(stackView: base) }
    }

}

// MARK: - Array Conformance
// An Array of Stackable elements is Stackable.
extension Array: Stackable where Element: Stackable {

    public func configure(stackView: UIStackView) {
        forEach { $0.configure(stackView: stackView) }
    }

}

// MARK: - Optional Conformance
extension Optional: Stackable where Wrapped: Stackable {
    
    public func configure(stackView: UIStackView) {
        map { $0.configure(stackView: stackView) }
    }
    
}
