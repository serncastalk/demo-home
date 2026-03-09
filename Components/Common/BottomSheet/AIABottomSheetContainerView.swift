//
//  AIABottomSheetContainerView.swift
//  Components
//
//  Created by Duck Sern on 8/4/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit
import SnapKit

public class AIABottomSheetContainerView<Content: UIView>: UIView {
    public enum BackgroundStyle {
        case blur
        case white
    }
    private let grabView = {
        let v = UIView()
        v.backgroundColor = .appColor(\.lightGray)
        v.makeRoundedCorner(radius: 3.0)
        return v
    }()
    private var _contentView: Content!
    private var backgroundStyle: BackgroundStyle = .blur
    private var prevHeight: CGFloat?
    
    public var contentView: Content { _contentView }
    
    private var bgView: UIView?
    
    public init(contentView: Content, backgroundStyle: BackgroundStyle = .blur) {
        super.init(frame: .zero)
        self._contentView = contentView
        self.backgroundStyle = backgroundStyle
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        layer.cornerRadius = 32
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setupBgView()
        
        addSubview(grabView)
        grabView.snp.makeConstraints { make in
            make.height.equalTo(6)
            make.width.equalTo(48)
            make.top.equalToSuperview().inset(4)
            make.centerX.equalToSuperview()
        }
        
        addSubview(_contentView)
        _contentView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if transform.ty > 0,
           prevHeight != nil,
           bounds.height != prevHeight {
            //SERN: Workaround Fix View resize when being hide using .transform then its size change
            transform = .identity.translatedBy(x: 0, y: bounds.height)
        }
        prevHeight = bounds.height
    }
    
    public func setBackgroundStyle(_ style: BackgroundStyle) {
        backgroundStyle = style
        setupBgView()
    }
    
    private func setupBgView() {
        if bgView != nil {
            self.bgView?.removeFromSuperview()
            self.bgView = nil
        }
        
        let background: UIView = {
            switch backgroundStyle {
            case .blur:
                return AIABlurBackgroundView(style: .gradient)
            case .white:
                let v = UIView()
                v.backgroundColor = .appColor(\.white)
                return v
            }
        }()
        addSubview(background)
        sendSubviewToBack(background)
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bgView = background
    }
}
