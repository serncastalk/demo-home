//
//  AIAViewWithCornerRadiusAndShadow.swift
//  Components
//
//  Created by Duck Sern on 13/1/26.
//  Copyright © 2026 Torilab. All rights reserved.
//

import UIKit
import SnapKit

/// Add UI, cornerRadius to `contentView`, setup shadow at `self`
open class AIAViewWithCornerRadiusAndShadow: UIView {
    public let contentView = UIView()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(contentView)
        contentView.clipsToBounds = true
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        setupView()
    }
    
    open func setupView() {
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}
