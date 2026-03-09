//
//  AIABlurBackgroundView.swift
//  Components
//
//  Created by Duck Sern on 4/4/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit
import SnapKit

public final class AIABlurBackgroundView: UIView {
    
    public enum Style {
        case background(color: UIColor, alpha: CGFloat)
        case gradient
        
        public static let blackAlpha10: Self = .background(color: .appColor(\.black), alpha: 0.1)
        
        @available(*, deprecated, message: "-> .black10 to increase visibility")
        public static let whiteAlpha10: Self = .background(color: .appColor(\.white), alpha: 0.1)
        
        public static let whiteAlpha20: Self = .background(color: .appColor(\.white), alpha: 0.2)
    }
    
    private let blurEffectView = VisualEffectView(effect: UIBlurEffect(style: .light))
    private var style: Style = .blackAlpha10
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public init(style: Style) {
        super.init(frame: .zero)
        self.style = style
        setup()
    }
    
    private func setup() {
        addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        sendSubviewToBack(blurEffectView)
        
        switch style {
        case let .background(color, alpha):
            blurEffectView.colorTint = color
            blurEffectView.colorTintAlpha = alpha
            blurEffectView.blurRadius = 2
        case .gradient:
            blurEffectView.blurRadius = 2
            let gradientView = AIABlurBackgroundGradientView()
            blurEffectView.contentView.addSubview(gradientView)
            gradientView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    public func bind(style: Style) {
        self.style = style
        setup()
    }
    
    public func setRadius(_ radius: CGFloat) {
        blurEffectView.blurRadius = radius
    }
}

fileprivate class AIABlurBackgroundGradientView: UIView {
    private var gradientLayer: CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientLayer = makeGradientLayer(
            colours: [.white.withAlphaComponent(0), .white],
            locations: [0, 1],
            direction: .custom(start: .init(x: 0, y: -0.1), end: .init(x: 0, y: 0.4)))
        layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
}

fileprivate class VisualEffectView: UIVisualEffectView {
    
    /// Returns the instance of UIBlurEffect.
    private let blurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()
    
    /**
     Tint color.
     
     The default value is nil.
     */
    open var colorTint: UIColor? {
        get {
            ios14_colorTint
        }
        set {
            ios14_colorTint = newValue
        }
    }
    
    /**
     Tint color alpha.

     Don't use it unless `colorTint` is not nil.
     The default value is 0.0.
     */
    open var colorTintAlpha: CGFloat {
        get { return _value(forKey: .colorTintAlpha) ?? 0.0 }
        set {
            ios14_colorTint = ios14_colorTint?.withAlphaComponent(newValue)
        }
    }
    
    /**
     Blur radius.
     
     The default value is 0.0.
     */
    open var blurRadius: CGFloat {
        get { ios14_blurRadius }
        set { ios14_blurRadius = newValue }
    }
    
    /**
     Scale factor.
     
     The scale factor determines how content in the view is mapped from the logical coordinate space (measured in points) to the device coordinate space (measured in pixels).
     
     The default value is 1.0.
     */
    open var scale: CGFloat {
        get { return _value(forKey: .scale) ?? 1.0 }
        set { _setValue(newValue, forKey: .scale) }
    }
    
    // MARK: - Initialization
    
    public override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        scale = 1
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        scale = 1
    }
    
}

private extension VisualEffectView {
    
    /// Returns the value for the key on the blurEffect.
    func _value<T>(forKey key: Key) -> T? {
        return blurEffect.value(forKeyPath: key.rawValue) as? T
    }
    
    /// Sets the value for the key on the blurEffect.
    func _setValue<T>(_ value: T?, forKey key: Key) {
        blurEffect.setValue(value, forKeyPath: key.rawValue)
    }
    
    enum Key: String {
        case colorTint, colorTintAlpha, blurRadius, scale
    }
    
}

private extension UIVisualEffectView {
    var ios14_blurRadius: CGFloat {
        get {
            return gaussianBlur?.requestedValues?["inputRadius"] as? CGFloat ?? 0
        }
        set {
            prepareForChanges()
            gaussianBlur?.requestedValues?["inputRadius"] = newValue
            applyChanges()
        }
    }
    var ios14_colorTint: UIColor? {
        get {
            return sourceOver?.value(forKeyPath: "color") as? UIColor
        }
        set {
            prepareForChanges()
            sourceOver?.setValue(newValue, forKeyPath: "color")
            sourceOver?.perform(Selector(("applyRequestedEffectToView:")), with: overlayView)
            applyChanges()
            overlayView?.backgroundColor = newValue
        }
    }
}

private extension UIVisualEffectView {
    var backdropView: UIView? {
        return subview(of: NSClassFromString("_UIVisualEffectBackdropView"))
    }
    var overlayView: UIView? {
        return subview(of: NSClassFromString("_UIVisualEffectSubview"))
    }
    var gaussianBlur: NSObject? {
        return backdropView?.value(forKey: "filters", withFilterType: "gaussianBlur")
    }
    var sourceOver: NSObject? {
        return overlayView?.value(forKey: "viewEffects", withFilterType: "sourceOver")
    }
    func prepareForChanges() {
        self.effect = UIBlurEffect(style: .light)
        gaussianBlur?.setValue(1.0, forKeyPath: "requestedScaleHint")
    }
    func applyChanges() {
        backdropView?.perform(Selector(("applyRequestedFilterEffects")))
    }
}

private extension NSObject {
    var requestedValues: [String: Any]? {
        get { return value(forKeyPath: "requestedValues") as? [String: Any] }
        set { setValue(newValue, forKeyPath: "requestedValues") }
    }
    func value(forKey key: String, withFilterType filterType: String) -> NSObject? {
        return (value(forKeyPath: key) as? [NSObject])?.first { $0.value(forKeyPath: "filterType") as? String == filterType }
    }
}

private extension UIView {
    func subview(of classType: AnyClass?) -> UIView? {
        return subviews.first { type(of: $0) == classType }
    }
}
