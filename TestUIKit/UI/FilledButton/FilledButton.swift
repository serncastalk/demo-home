//
//  FilledButton.swift
//  TestUIKit
//
//  Created by Duck Sern on 2/4/25.
//

import UIKit

class FilledButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .black : .init(hex: 0x181818).withAlphaComponent(0.2)
        }
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
        titleLabel?.textColor = .white
        backgroundColor = .black
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = layer.bounds.height / 2
    }
}
