//
//  UIControl+.swift
//  Components
//
//  Created by Duc Nguyen on 18/4/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit

public extension UIControl {
    private static let actionIDs = ObjectAssociation<StructWrapper<[(UIControl.Event, String)]>>()
    
    var actionIDs: [(UIControl.Event, String)] {
        get { Self.actionIDs[self]?() ?? [] }
        set { Self.actionIDs[self] = .init(value: newValue) }
    }
    
    /// Add action with out caring about selector and version compatible
    /// - Parameters:
    ///   - controlEvent: Control event for action to be triggered
    ///   - closure: Things happen
    @discardableResult
    func addAction(for controlEvent: UIControl.Event, _ closure: @escaping() -> Void) -> String {
        var identifier: String
        if #available(iOS 14.0, *) {
            let action = UIAction { (_: UIAction) in closure() }
            addAction(action, for: controlEvent)
            identifier = action.identifier.rawValue
        } else {
            let sleeve = ClosureSleeve(closure)
            identifier = UUID().uuidString
            addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvent)
            objc_setAssociatedObject(self, identifier, sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        actionIDs.append((controlEvent, identifier))
        return identifier
    }
}

@objc public class ClosureSleeve: NSObject {
    public let closure: () -> Void
    
    public init(_ closure: @escaping() -> Void) { self.closure = closure }
    
    @objc public func invoke() { closure() }
    
    public func callAsFunction() { invoke() }
}
