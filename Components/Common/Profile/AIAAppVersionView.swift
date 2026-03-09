//
//  AIAAppVersionView.swift
//  Components
//
//  Created by Sonny on 10/4/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit.UIView
import SnapKit

public final class AIAAppVersionView: UIView, ThemeObservable {
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(\.subText2SB)
        label.textColor = .appColor(\.inactiveGray2)
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(versionLabel)
        versionLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    public func bind(version: String) {
        versionLabel.text = version
    }
    
    public func themeDidUpdated() {
        versionLabel.font = .appFont(\.subText2SB)
    }
}
