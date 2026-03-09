//
//  ObjectAssociation.swift
//  Components
//
//  Created by Duc Nguyen on 18/4/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import Foundation

public class StructWrapper<T>: NSObject {
    public var value: T
    
    public init(value: T) { self.value = value }
    
    public func callAsFunction() -> T { value }
}

public final class ObjectAssociation<T: AnyObject> {
    private let policy: objc_AssociationPolicy
    
    /// - Parameter policy: An association policy that will be used when linking objects.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        self.policy = policy
    }
    
    /// Accesses associated object.
    /// - Parameter index: An object whose associated object is to be accessed.
    public subscript(index: AnyObject) -> T? {
        get { objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as? T }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}
