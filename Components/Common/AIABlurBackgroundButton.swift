//
//  AIABlurBackgroundButton.swift
//  Components
//
//  Created by Duck Sern on 20/1/26.
//  Copyright © 2026 Torilab. All rights reserved.
//

import UIKit
import SnapKit

final public class AIABlurBackgroundButton: UIView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private lazy var label = {
        let v = UILabel()
        v.font = .appFont(\.body2SBUpCase)
        v.textColor = .appColor(\.white)
        return v
    }()
    
    private lazy var imgView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    public let button = UIButton()
    
    private func setup() {
        let stackView = {
            let v = UIStackView(arrangedSubviews: [imgView, label])
            v.axis = .horizontal
            v.alignment = .center
            v.spacing = 8
            return v
        }()
        imgView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
        backgroundColor = .appColor(\.black30)
        let blurView = AIABlurBackgroundView(style: .background(color: .appColor(\.black30), alpha: 0))
        addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.directionalVerticalEdges.equalToSuperview().inset(6)
        }
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    public func bind(image: UIImage?, text: String) {
        imgView.image = image
        label.text = text
    }
}
