//
//  OutlineButton.swift
//  TestUIKit
//
//  Created by Duck Sern on 2/4/25.
//

import UIKit

class OutlineButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            
        }
    }
    
    override var backgroundColor: UIColor? {
        get { .clear }
        set {}
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel?.textColor = .black
        layer.borderWidth = 1
        layer.borderColor = UIColor(hex: 0xE6E3E3).cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = layer.bounds.height / 2
    }
}
