//
//  AIADropDownView.swift
//  Components
//
//  Created by Duck Sern on 17/9/25.
//  Copyright © 2025 Torilab. All rights reserved.
//

import UIKit
import SnapKit

final public class AIADropDownView: UIView {
    
    private let title: String
    
    public init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setup()
    }
    
    private lazy var textField = {
        let v = AIATextField(configuration: .init(
            title: title,
            placeholder: "",
            image: .icOvalArrow,
            imageTransform: .init(rotationAngle: .pi / 2)))
        return v
    }()
    
    private lazy var _button: UIButton = {
        let b = UIButton()
        return b
    }()
    
    public var button: UIButton { _button }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        addSubview(textField)
        addSubview(_button)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        _button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func setContent(_ text: String) {
        textField.setText(text)
    }
}
