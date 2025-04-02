//
//  TextField.swift
//  TestUIKit
//
//  Created by Duck Sern on 2/4/25.
//

import UIKit
import SnapKit

class TextField: UIView {
    
    struct Config {
        var title: String = ""
    }
    
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
        v.font = .systemFont(ofSize: 15, weight: .medium)
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
        let containerView = UIView()
        containerView.layer.cornerRadius = 14
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(hex: 0x181818).withAlphaComponent(0.4).cgColor
        containerView.clipsToBounds = true
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.edges.equalToSuperview()
        }
        containerView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(22)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(20)
            make.top.equalToSuperview().inset(8).priority(999)
            titleLabelCenterConstaint = make.centerY.equalToSuperview().constraint
        }
        titleLabelCenterConstaint?.activate()
        textField.alpha = 0
        textField.delegate = self
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self._onTap))
        addGestureRecognizer(tapGR)
        
        titleLabel.text = "Name (*)"
        
    }
    
    @objc private func _onTap() {
        textField.becomeFirstResponder()
    }
}

extension TextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25) {
            textField.alpha = 1
            self.titleLabelCenterConstaint?.deactivate()
            self.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25) {
            textField.alpha = 0
            self.titleLabelCenterConstaint?.activate()
            self.layoutIfNeeded()
        }
    }
}
