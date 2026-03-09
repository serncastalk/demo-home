//
//  AIASeparator.swift
//  Components
//
//  Created by Sonny on 10/4/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit.UIView
import SnapKit

public final class AIASeparator: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        self.backgroundColor = .appColor(\.black10)
    }
}
