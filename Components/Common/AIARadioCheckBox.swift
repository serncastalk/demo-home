//
//  AIARadioCheckBox.swift
//  Components
//
//  Created by Duck Sern on 3/4/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit
import SnapKit

public final class AIARadioCheckBox: UIView {
    private let isOnView = {
        let v = UIView()
        v.backgroundColor = .appColor(\.darkGray)
        v.clipsToBounds = true
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        isOnView.layer.cornerRadius = bounds.height / 4
    }
    
    public var isOn: Bool = false {
        didSet {
            isOnView.isHidden = !isOn
            layer.borderColor = UIColor.appColor(isOn ? \.darkGray : \.middleGray).cgColor
        }
    }
    
    private func setup() {
        addSubview(isOnView)
        isOnView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalToSuperview().multipliedBy(0.5)
        }
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.appColor(\.darkGray).cgColor
        
        isOn = false
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self._onTap))
        addGestureRecognizer(tapGR)
    }
    
    @objc private func _onTap() {
        isOn.toggle()
    }
}
