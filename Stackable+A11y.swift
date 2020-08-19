//
//  Stackable+A11y.swift
//  Stackable
//
//  Created by Jason Clark on 8/18/20.
//

import Foundation

public enum StackableAccessibilityID {
    public static let space = "com.rightpoint.stackable.space"
    public static let hairline = "com.rightpoint.stackable.hairline"
    
    internal typealias debug = DebugAccessibilityID
}

internal enum DebugAccessibilityID {
    public static let outline = "com.rightpoint.stackable.debug.outline"
    public static let space = "com.rightpoint.stackable.debug.space"
    public static let margin = "com.rightpoint.stackable.debug.margin"
}

public extension StackableExtension where ExtendedType == UIStackView {

    typealias axID = StackableAccessibilityID
    
}
