//
//  AIAMainButton.swift
//  Components
//
//  Created by Sonny on 12/3/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit

public final class AIAMainButton: UIButton {
    public override var isEnabled: Bool {
        didSet {
            _state = isEnabled ? .enable : .disable
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            guard _state != .loading else { return }
            applyHighlightEffect(apply: isHighlighted)
        }
    }
    
    private var _state: State = .enable {
        willSet {
            restoreFromLoadingStateIfNeeded()
        }
        didSet {
            updateForState()
        }
    }
    private var needRestore: Bool = false
    
    private var _image: UIImage?
    private var _title: String?
    private var _attributedTitle: NSAttributedString?
    
    private var style: Style = .gradient
    private var gradientLayer: CAGradientLayer?
    
    public convenience init(style: AIAMainButton.Style) {
        self.init(type: .custom)
        self.style = style
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        switch style {
        case .filled, .secondaryFilled, .stroke, .transparent, .roundIcon:
            layer.cornerRadius = bounds.height / 2
        case .gradient:
            layer.cornerRadius = bounds.height / 2
            gradientLayer?.frame = bounds
            gradientLayer?.cornerRadius = bounds.height / 2
        }
    }
    
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        titleLabel?.font = .appFont(\.body1M)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.3
        titleLabel?.lineBreakMode = .byClipping
        titleLabel?.numberOfLines = 1
        switch style {
        case .filled, .gradient, .transparent:
            setTitleColor(.appColor(\.white), for: .normal)
        case .secondaryFilled:
            setTitleColor(.appColor(\.darkGray), for: .normal)
        case .stroke:
            setTitleColor(.appColor(\.black), for: .normal)
        case .roundIcon:
            break
        }
    }
    
    public override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
    }
    
    private func setup() {
        titleEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 8)
        if style == .gradient, gradientLayer == nil {
            gradientLayer = makeGradientLayer(
                colours: [.appColor(\.primary1), .appColor(\.primary2)],
                locations: [0.3, 1.0],
                direction: .custom(start: .init(x: 0.2, y: 0.5), end: .init(x: 1, y: 1)))
            layer.insertSublayer(gradientLayer!, at: 0)
            gradientLayer?.zPosition = -1
        }
        
        // Add touch targets to implement a brief highlight on touchUpInside
        addTarget(self, action: #selector(touchUpInsideAction), for: .touchUpInside)
        addTarget(self, action: #selector(touchCancelAction), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        
        updateForState()
    }
    
    public func bind(style: Style) {
        self.style = style
        setup()
        setTitle(self.titleLabel?.text, for: .normal)
    }
    
    public func bind(state: State) {
        switch state {
        case .enable:
            self.isEnabled = true
        case .disable:
            self.isEnabled = false
        case .loading:
            self.isEnabled = false
            _state = state
        }
    }
    
    public func hideGradient() {
        gradientLayer?.isHidden = true
        backgroundColor = .appColor(\.white)
    }
    
    private func updateForState() {
        switch _state {
        case .enable:
            updateForEnableState()
        case .disable:
            updateForDisableState()
        case .loading:
            updateForLoadingState()
        }
    }
    
    private func updateForEnableState() {
        layer.borderWidth = 0
        backgroundColor = .clear
        transform = .identity
        alpha = 1.0
        switch style {
        case .filled:
            backgroundColor = .appColor(\.black)
        case .secondaryFilled:
            backgroundColor = .appColor(\.white)
        case .gradient:
            gradientLayer?.opacity = 1.0
            backgroundColor = .clear
        case .stroke:
            backgroundColor = .appColor(\.white)
            layer.borderWidth = 1
            layer.borderColor = UIColor.appColor(\.middleGray).cgColor
            alpha = 1
        case .transparent:
            backgroundColor = .clear
        case .roundIcon:
            backgroundColor = .appColor(\.black)
        }
        gradientLayer?.isHidden = style != .gradient
    }
    
    private func updateForDisableState() {
        transform = .identity
        switch style {
        case .filled:
            backgroundColor = .appColor(\.middleGray)
            setTitleColor(.appColor(\.white), for: .disabled)
        case .secondaryFilled:
            backgroundColor = .appColor(\.middleGray)
            setTitleColor(.appColor(\.white), for: .disabled)
        case .stroke:
            alpha = 0.4
        case .gradient:
            gradientLayer?.isHidden = true
            backgroundColor = .appColor(\.inactiveGray1)
        case .transparent:
            break
        case .roundIcon:
            break
        }
    }
    
    private func updateForLoadingState() {
        _image = currentImage
        _title = currentTitle
        _attributedTitle = attributedTitle(for: .normal)
        
        self.isEnabled = false
        self.needRestore = true
        self.setTitle(nil, for: .normal)
        self.setAttributedTitle(nil, for: .normal)
        
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        indicator.tag = 999
        addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func restoreFromLoadingStateIfNeeded() {
        if case .loading = _state {
            return
        }
        if !needRestore {
            return
        }
        self.needRestore = false
        setImage(_image, for: .normal)
        setTitle(_title, for: .normal)
        setAttributedTitle(_attributedTitle, for: .normal)
        
        if let indicator = self.viewWithTag(999) as? UIActivityIndicatorView {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
        }
    }
    
    private func applyHighlightEffect(apply: Bool) {
        // Do not apply highlight in loading or disabled states
        guard _state == .enable else { return }
        
        let scale: CGFloat = apply ? 0.98 : 1.0
        let duration: TimeInterval = 0.12
        
        switch style {
        case .filled, .roundIcon:
            UIView.animate(withDuration: duration) {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
                self.alpha = apply ? 0.9 : 1.0
            }
        case .gradient:
            UIView.animate(withDuration: duration) {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
                self.gradientLayer?.opacity = apply ? 0.9 : 1.0
            }
        case .stroke, .transparent, .secondaryFilled:
            UIView.animate(withDuration: duration) {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
                self.alpha = apply ? 0.7 : 1.0
            }
        }
    }
    
    private func animateHighlightPulse() {
        // Quick pulse on touchUpInside
        guard _state == .enable else { return }
        let downScale: CGFloat = 0.85
        let upScale: CGFloat = 1.0
        
        UIView.animate(withDuration: 0.08, animations: {
            switch self.style {
            case .gradient:
                self.transform = CGAffineTransform(scaleX: downScale, y: downScale)
                self.gradientLayer?.opacity = 0.6
            case .filled, .roundIcon:
                self.transform = CGAffineTransform(scaleX: downScale, y: downScale)
                self.alpha = 0.6
            case .stroke, .transparent, .secondaryFilled:
                self.transform = CGAffineTransform(scaleX: downScale, y: downScale)
                self.alpha = 0.6
            }
        }, completion: { _ in
            UIView.animate(withDuration: 0.12, animations: {
                self.transform = CGAffineTransform(scaleX: upScale, y: upScale)
                switch self.style {
                case .gradient:
                    self.gradientLayer?.opacity = 1.0
                case .filled, .roundIcon, .stroke, .transparent, .secondaryFilled:
                    self.alpha = 1.0
                }
            }, completion: { _ in
                self.updateForState()
            })
        })
    }
    
    @objc private func touchUpInsideAction() {
        guard _state != .loading else { return }
        animateHighlightPulse()
    }
    
    @objc private func touchCancelAction() {
        guard _state != .loading else { return }
        UIView.animate(withDuration: 0.12) {
            self.transform = .identity
            self.alpha = 1.0
            self.gradientLayer?.opacity = 1.0
        }
        updateForState()
    }
}

public extension AIAMainButton {
    enum Style {
        case filled
        case secondaryFilled
        case gradient
        case stroke
        case transparent
        case roundIcon
    }
    
    enum State {
        case enable
        case disable
        case loading
    }
}

public extension UIButton {
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        let isRTL = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft
        if isRTL {
           imageEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
           titleEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
           contentEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: -insetAmount)
        } else {
           imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
           titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
           contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
    }
}
