//
//  Stackable+Extended.swift
//  Stackable
//
//  Created by Jason Clark on 7/31/20.
//

import Foundation

/// Type that acts as a generic extension point for all `StackableExtended` types.
public struct StackableExtension<ExtendedType> {
    /// Stores the type or meta-type of any extended type.
    public private(set) var type: ExtendedType

    /// Create an instance from the provided value.
    ///
    /// - Parameter type: Instance being extended.
    public init(_ type: ExtendedType) {
        self.type = type
    }
}

/// Protocol describing the `stackable` extension points for Stackable extended types.
public protocol StackableExtended {
    /// Type being extended.
    associatedtype ExtendedType

    /// Static Stackable extension point.
    static var stackable: StackableExtension<ExtendedType>.Type { get set }
    /// Instance Stackable extension point.
    var stackable: StackableExtension<ExtendedType> { get set }
}

public extension StackableExtended {
    /// Static Stackable extension point.
    static var stackable: StackableExtension<Self>.Type {
        get { StackableExtension<Self>.self }
        set {}
    }

    /// Instance Stackable extension point.
    var stackable: StackableExtension<Self> {
        get { StackableExtension(self) }
        set {}
    }
}
