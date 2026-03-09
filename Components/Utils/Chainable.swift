//
//  Chainable.swift
//  Components
//
//  Created by Duc Nguyen on 18/4/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit

@objc public protocol Chainable { }

public extension Chainable where Self: AnyObject {
    @discardableResult
    func with<T>(_ property: ReferenceWritableKeyPath<Self, T>, setTo value: T) -> Self {
        self[keyPath: property] = value
        return self
    }
    
    @discardableResult
    func customized(_ configuration: (Self) -> Void) -> Self {
        configuration(self)
        return self
    }
}

extension NSAttributedString: Chainable { }
extension UIView: Chainable { }
