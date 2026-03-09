//
//  AIAIconButton.swift
//  Components
//
//  Created by Duck Sern on 4/4/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit
import SnapKit

public final class AIAIconButton: UIView {
    private let blurBackground = AIABlurBackgroundView(style: .blackAlpha10)
    private let imgView = UIImageView()
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    public private(set) var image: UIImage?
    private var imgSize: CGSize = .zero
    public var isRound: Bool = false
    public var onTap: (() -> ())?
    
    public init(image: UIImage?, imgSize: CGSize, isRound: Bool = false) {
        super.init(frame: .zero)
        self.isRound = isRound
        self.image = image
        self.imgSize = imgSize
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if isRound {
            layer.cornerRadius = bounds.height / 2
        }
    }
    
    private func setup() {
        layer.cornerRadius = 12
        clipsToBounds = true
        
        addSubview(blurBackground)
        blurBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imgView.image = image
        imgView.contentMode = .scaleAspectFill
        addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(imgSize.width)
            make.height.equalTo(imgSize.height)
        }
        
        // Add an UIButton to avoid unexpected behavior within a view that have multiple gestures
        let action = UIButton()
        action.backgroundColor = .clear
        action.tintColor = .clear
        addSubview(action)
        action.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        action.addTarget(self, action: #selector(onTapAction), for: .touchUpInside)
    }
    
    @objc
    private func onTapAction() {
        onTap?()
    }
    
    public func bind(image: UIImage?, imgSize: CGSize) {
        self.image = image
        imgView.image = image
        imgView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(imgSize.width)
            make.height.equalTo(imgSize.height)
        }
    }
    
    public func setBackgroundColor(_ color: UIColor, alpha: CGFloat = 1) {
        blurBackground.bind(style: .background(color: color, alpha: alpha))
    }
    
    public func setShowBlurBackground(_ isShow: Bool) {
        blurBackground.isHidden = !isShow
    }
}
