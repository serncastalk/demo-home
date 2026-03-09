//
//  AIABottomSheetWithTitleVC.swift
//  Components
//
//  Created by Duck Sern on 28/1/26.
//  Copyright © 2026 Torilab. All rights reserved.
//

import UIKit
import SnapKit

open class AIABottomSheetWithTitleVC: AIABottomSheetVC {
    public lazy var titleLabel = {
        let v = UILabel()
        v.font = .appFont(\.h5)
        v.text = title?.uppercased()
        v.adjustsFontSizeToFitWidth = true
        v.minimumScaleFactor = 0.5
        v.textColor = .appColor(\.black)
        v.textAlignment = .center
        v.setContentCompressionResistancePriority(.defaultHigh + 2, for: .vertical)
        return v
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(28)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
        }
    }
}
