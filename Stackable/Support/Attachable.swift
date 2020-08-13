//
//  Attachable.swift
//  Stackable
//
//  Created by Jason Clark on 8/3/20.
//

import Foundation

/// `Attachable` is a pattern to force some object to hold a strong reference to another object.
/// In general, this is a bad idea. Proceed with caution.
/// The pattern is useful for executing some very-messy ownership situations that occur in Swift development.
/// Example: attaching a `Coordinator` or `Controller` to a `ViewController` so that the Coordinator lives and dies with the  view hierarchy.
/// Example: attaching a  KVO observation to some view you are observing so that the observation itself dies alongside the view.
protocol Attachable {

    func attach(to child: AnyObject)
    func detatch(from child: AnyObject)

}

private var strongKey = "com.rightpoint.attachable.strong"
private var weakKey = "com.rightpoint.attachable.weak"

extension Attachable where Self: NSObject {

    /// Force another object to hold a strong reference to `self`.
    /// - Parameter child: The object that should be forced to hold a strong reference to `self.`
    func attach(to child: AnyObject) {
        addStrongReference(from: child, to: self)
        addWeakReference(from: self, to: child)
    }

    /// Release another object from holding a strong reference to self.
    /// - Parameter child: The object that should remove self as a strong  reference.
    func detatch(from child: AnyObject) {
        strongReferences(from: child)?.remove(self)
        weakReferences(from: self)?.remove(child)
    }

    /// A list of objects that `self` has `attached` to.
    var attached: [AnyObject] {
        return (weakReferences(from: self) as NSHashTable<AnyObject>?)?.allObjects ?? []
    }

    
    /// Fetches the array holding the strong `Attachable` relationships held by `object`
    private func strongReferences(from object: AnyObject) -> NSMutableArray? {
        return objc_getAssociatedObject(object, &strongKey) as? NSMutableArray
    }

    /// Fetches the hash map holding the weak `Attachable` relationships from `self` to objects it has `attach`ed  to.
    private func weakReferences(from object: AnyObject) -> NSHashTable<AnyObject>? {
        return objc_getAssociatedObject(object, &weakKey) as? NSHashTable<AnyObject>
    }

    /// Creates Strong object storage if necessary, associates it with `source`, and adds `destination` as a retained object.
    private func addStrongReference(from source: AnyObject, to destination: AnyObject) {
        let attached = strongReferences(from: source) ?? {
            let array = NSMutableArray()
            objc_setAssociatedObject(source, &strongKey, array, .OBJC_ASSOCIATION_RETAIN)
            return array
        }()
        attached.add(destination)
    }

    /// Creates Weak object storage if necessary, associates it with `source`, and adds `destination` as a weak reference.
    private func addWeakReference(from source: AnyObject, to destination: AnyObject) {
        let attached = weakReferences(from: source) ?? {
            let table = NSHashTable<AnyObject>.weakObjects()
            objc_setAssociatedObject(source, &weakKey, table, .OBJC_ASSOCIATION_RETAIN)
            return table
        }()
        attached.add(destination)
    }

}
