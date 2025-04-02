//
//  Cell.swift
//  TestUIKit
//
//  Created by Duck Sern on 2/4/25.
//

import UIKit

class Cell: ScrollableSingleSectionItemView {
    
    private let orangeRect = UIView()
    override func showContent() {
        orangeRect.alpha = 1
    }
    
    override func hideContent() {
        orangeRect.alpha = 0
    }
    
    let imgView = UIView()
    let label = UILabel()
    let topSepe = UIView()
    let bottomSepe = UIView()
    static let colors: [UIColor] = [.red, .green, .blue, .yellow, .purple, .brown, .gray, .magenta]
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(label)
        orangeRect.backgroundColor = .orange
        addSubview(orangeRect)
        orangeRect.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(20)
            make.height.width.equalTo(50)
        }
        label.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(20)
        }
        label.textColor = .white
        label.font = .systemFont(ofSize: 26, weight: .semibold)
    }
}
