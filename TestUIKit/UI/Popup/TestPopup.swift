//
//  TestPopup.swift
//  TestUIKit
//
//  Created by Duck Sern on 3/3/26.
//

import UIKit

final class TestPopup: AIAPopupVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = UIView()
        v.backgroundColor = .yellow
        view.addSubview(v)
        v.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.edges.equalToSuperview()
        }
    }
}

