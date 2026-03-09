//
//  TextField.swift
//  TestUIKit
//
//  Created by Duck Sern on 2/4/25.
//

import UIKit
import SnapKit

class TextField: UIView {
    
    private let textFieldContainerView = {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        v.layer.cornerRadius = 14
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor(hex: 0x181818).withAlphaComponent(0.4).cgColor
        v.clipsToBounds = true
        return v
    }()
    
    private let textField = {
        let v = UITextField()
        v.font = .systemFont(ofSize: 16, weight: .medium)
        v.textColor = UIColor(hex: 0x2E2E2E)
        return v
    }()
    
    private let titleLabel = {
        let v = UILabel()
        v.textColor = UIColor(hex: 0x181818)
        v.alpha = 0.5
        v.font = .systemFont(ofSize: 14, weight: .medium)
        return v
    }()
    
    private let errorLabel = {
        let v = UILabel()
        v.textColor = UIColor(hex: 0xEE3424)
        v.font = .systemFont(ofSize: 14, weight: .medium)
        return v
    }()
    
    private var titleLabelCenterConstaint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let stackViewContainer = {
            let v = UIStackView()
            v.axis = .vertical
            v.spacing = 10
            return v
        }()
        addSubview(stackViewContainer)
        stackViewContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackViewContainer.addArrangedSubview(textFieldContainerView)
        textFieldContainerView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        textFieldContainerView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(22)
        }
        
        textFieldContainerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(20)
            make.top.equalToSuperview().inset(8).priority(999)
            titleLabelCenterConstaint = make.centerY.equalToSuperview().constraint
        }
        textField.delegate = self
        
        stackViewContainer.addArrangedSubview(errorLabel)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self._onTap))
        addGestureRecognizer(tapGR)
        
        setText("")
        setError(nil)
    }
    
    @objc private func _onTap() {
        textField.becomeFirstResponder()
    }
    
    public func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    public func setText(_ text: String) {
        textField.text = text
        if text.isEmpty {
            setupUIWhenTextFieldNotFocusOrTextEmpty()
        } else {
            setupUIWhenTextFieldFocusOrTextNotEmpty()
        }
    }
    
    public func setKeyboardType(_ type: UIKeyboardType) {
        textField.keyboardType = type
    }
    
    public func setError(_ error: Error?) {
        let isError = error != nil
        textFieldContainerView.layer.borderColor = isError ? UIColor(hex: 0xE93E21).cgColor : UIColor(hex: 0x181818).withAlphaComponent(0.4).cgColor
        errorLabel.text = error?.localizedDescription
    }
}

extension TextField: UITextFieldDelegate {
    private func setupUIWhenTextFieldFocusOrTextNotEmpty() {
        textField.alpha = 1
        titleLabelCenterConstaint?.deactivate()
    }
    
    private func setupUIWhenTextFieldNotFocusOrTextEmpty() {
        textField.alpha = 0
        titleLabelCenterConstaint?.activate()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25) {
            self.setupUIWhenTextFieldFocusOrTextNotEmpty()
            self.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25) {
            if (self.textField.text ?? "").isEmpty {
                self.setupUIWhenTextFieldNotFocusOrTextEmpty()
            } else {
                self.setupUIWhenTextFieldFocusOrTextNotEmpty()
            }
            self.layoutIfNeeded()
        }
    }
}
