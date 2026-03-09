//
//  UIView++.swift
//  Components
//
//  Created by Sonny on 12/3/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit

extension UIView {
    /// Apply border to the view
    /// - parameter width: Border width
    /// - parameter color: Border color
    /// - parameter radius: The corder radius value applied to view. Default value: .small (4)
    /// - parameter borderEdges: The edges was cornered
    public func makeBorder(width: CGFloat = 1,
                           color: UIColor = .appColor(\.lightGray),
                           radius: CGFloat = .appRadius(\.s),
                           borderEdges: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.cornerRadius = radius
        layer.maskedCorners = borderEdges
        layer.masksToBounds = true
    }
    
    public func makeRoundedCorner(radius: CGFloat = .appRadius(\.s)) {
        makeBorder(color: .clear, radius: radius)
    }
    
    /// Apply shadow to the view
    /// - parameter color: Shadow color
    /// - parameter radius: The blur radius in points
    /// - parameter opacity: The opacity of the shadow, from 0-1
    /// - parameter offSet: The CGSize to determine shadow offSet
    public func makeShadow(_ color: UIColor = .black, radius: CGFloat = 4, opacity: Float = 1, offSet: CGSize = .init(width: 0, height: 0)) {
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.masksToBounds = false
    }
    
    public static func animateAlongKeyboard(notification: Notification, animations: @escaping () -> Void) {
        let duration: TimeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
        let options: UIView.AnimationOptions = {
            if let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
                return UIView.AnimationOptions(rawValue: curve)
            } else {
                return []
            }
        }()
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            options: options,
            animations: animations
        )
    }
    
    public var nonDuplicateSetHidden: Bool {
        get {
            isHidden
        }
        set {
            guard isHidden != newValue else { return }
            isHidden = newValue
        }
    }
}

extension UIView {
    public enum AIAGradientDirection {
        case topToBottom
        case leftToRight
        case bottomToTop
        case rightToLeft
        case custom(start: CGPoint, end: CGPoint)
        
        public static var defautDir: Self = .custom(start: .init(x: 0.2, y: 0.5), end: .init(x: 1, y: 1))
        
        var startPoint: CGPoint {
            switch self {
            case .topToBottom:
                return .zero
            case .leftToRight:
                return .zero
            case .bottomToTop:
                return .init(x: 0, y: 1)
            case .rightToLeft:
                return .init(x: 1, y: 0)
            case let .custom(start, _):
                return start
            }
        }
        
        var endPoint: CGPoint {
            switch self {
            case .topToBottom:
                return .init(x: 0, y: 1)
            case .leftToRight:
                return .init(x: 1, y: 0)
            case .bottomToTop:
                return .zero
            case .rightToLeft:
                return .zero
            case let .custom(_, end):
                return end
            }
        }
    }
    @discardableResult
    func makeGradientLayer(colours: [UIColor]) -> CAGradientLayer {
        return self.makeGradientLayer(colours: colours, locations: nil, direction: .defautDir)
    }
    
    @discardableResult
    public func makeGradientLayer(colours: [UIColor], locations: [NSNumber]?, direction: AIAGradientDirection) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = direction.startPoint
        gradient.endPoint = direction.endPoint
        gradient.locations = locations
        return gradient
    }
}

