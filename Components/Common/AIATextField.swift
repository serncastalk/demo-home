//
//  AIATextField.swift
//  Components
//
//  Created by Duck Sern on 2/4/25.
//

import UIKit
import SnapKit

public protocol AIATextFieldDelegate: AnyObject {
    func textField(_ view: AIATextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
}

public final class AIATextField: UIView, UITextFieldDelegate {
    
    public struct Configuration {
        var title: String = ""
        var placeholder: String = ""
        var rightView: UIView?
        
        public init(
            title: String,
            placeholder: String,
            image: UIImage? = nil,
            imageTransform: CGAffineTransform = .identity) {
                self.title = title
                self.placeholder = placeholder
                if let image {
                    let imgView = UIImageView(image: image)
                    imgView.snp.makeConstraints { make in
                        make.size.equalTo(24)
                    }
                    imgView.transform = imageTransform
                    self.rightView = imgView
                }
            }
        
        public init(
            title: String,
            placeholder: String,
            rightView: UIView) {
                self.title = title
                self.placeholder = placeholder
                self.rightView = rightView
            }
        
        public init() {}
    }
    
    public enum State {
        case focused
        case unFocused
        case normal
        case error(_ text: String)
        case disabled
    }
    
    private let containerView = {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        v.layer.cornerRadius = 14
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.appColor(\.black40).cgColor
        v.clipsToBounds = true
        return v
    }()
    
    private let _textField = {
        let v = UITextField()
        v.font = .appFont(\.body1M)
        v.textColor = UIColor(hexString: "2E2E2E")
        return v
    }()
    
    private let titleLabel = {
        let v = UILabel()
        v.textColor = .appColor(\.black50)
        v.font = .appFont(\.body2M)
        return v
    }()
    
    private let errorLabel = {
        let v = UILabel()
        v.textColor = .appColor(\.primary1)
        v.font = .appFont(\.body2R)
        v.numberOfLines = 0
        return v
    }()
    
    private lazy var imgView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    public var textField: UITextField { _textField }
    public var maxLength = 100
    public var onTap: (() -> Void)?
    public weak var delegate: AIATextFieldDelegate?

    private var titleLabelCenterConstaint: Constraint?
    private var configuration: Configuration = .init()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public init(configuration: Configuration) {
        super.init(frame: .zero)
        self.configuration = configuration
        setup()
    }
    
    public func bind(config: Configuration) {
        self.configuration = config
        setup()
    }
    
    public func disable() {
        self.containerView.backgroundColor = .appColor(\.lightGray)
        self.containerView.layer.borderColor = UIColor.appColor(\.black40).cgColor
        self.textField.textColor = .appColor(\.inactiveGray2)
        self.textField.isUserInteractionEnabled = false
    }
    
    private func setup() {
        setupUI()
        setupEvents()
    }
    
    private func setupUI() {
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
                
        let innerStackViewContainer = {
            let v = UIStackView()
            v.axis = .horizontal
            v.spacing = 4
            v.alignment = .center
            return v
        }()
        stackViewContainer.addArrangedSubview(containerView)
        containerView.addSubview(innerStackViewContainer)
        innerStackViewContainer.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.verticalEdges.equalToSuperview()
        }
        let textFieldContainerView = UIView()
        innerStackViewContainer.addArrangedSubview(textFieldContainerView)
        textFieldContainerView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
        }
        _textField.attributedPlaceholder = NSAttributedString(
            string: configuration.placeholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.appColor(\.black20), NSAttributedString.Key.font: UIFont.appFont(\.body1M)
            ]
        )
        let topDummyTitleLabel = {
            let v = UILabel()
            v.isHidden = true
            v.font = .appFont(\.body2M)
            v.text = configuration.title
            return v
        }()
        textFieldContainerView.addSubview(topDummyTitleLabel)
        textFieldContainerView.addSubview(_textField)
        _textField.snp.makeConstraints { make in
            make.top.equalTo(topDummyTitleLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
        }
        
        if let rightView = configuration.rightView {
            innerStackViewContainer.addArrangedSubview(rightView)
        }
        
        titleLabel.text = configuration.title
        textFieldContainerView.addSubview(titleLabel)
        topDummyTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().inset(8)
        }
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().inset(8).priority(999)
            titleLabelCenterConstaint = make.centerY.equalToSuperview().constraint
        }
        stackViewContainer.addArrangedSubview(errorLabel)
        setText("")
        setState(.normal)
        textField.delegate = self
    }
    
    private func setupEvents() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self._onTap))
        addGestureRecognizer(tapGR)
        textField.addTarget(self, action: #selector(self._onEditingBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(self._onEditingEnd), for: .editingDidEnd)
    }
    
    @objc private func _onTap() {
        if let onTap = self.onTap {
            onTap()
        } else {
            textField.becomeFirstResponder()
        }
    }
    
    @objc private func _onEditingBegin() {
        UIView.animate(withDuration: 0.25) {
            self.setupUIWhenTextFieldFocusOrTextNotEmpty()
            self.layoutIfNeeded()
        }
    }
    
    @objc private func _onEditingEnd() {
        UIView.animate(withDuration: 0.25) {
            if (self.textField.text ?? "").isEmpty {
                self.setupUIWhenTextFieldNotFocusOrTextEmpty()
            } else {
                self.setupUIWhenTextFieldFocusOrTextNotEmpty()
            }
            self.layoutIfNeeded()
        }
    }
    
    private func setupUIWhenTextFieldFocusOrTextNotEmpty() {
        textField.alpha = 1
        titleLabelCenterConstaint?.deactivate()
    }
    
    private func setupUIWhenTextFieldNotFocusOrTextEmpty() {
        textField.alpha = 0
        titleLabelCenterConstaint?.activate()
    }
    
    public func setText(_ text: String) {
        textField.text = String(text.prefix(maxLength))
        if text.isEmpty && !textField.isEditing {
            setupUIWhenTextFieldNotFocusOrTextEmpty()
        } else {
            setupUIWhenTextFieldFocusOrTextNotEmpty()
        }
    }
    
    public func setKeyboardType(_ type: UIKeyboardType) {
        textField.keyboardType = type
    }
    
    public func setSecureTextEntry(_ isSecure: Bool) {
        textField.isSecureTextEntry = isSecure
    }
    
    public func setState(_ state: State) {
        switch state {
        case .focused:
            containerView.layer.borderColor = UIColor.appColor(\.black40).cgColor
            errorLabel.isHidden = true
            textField.becomeFirstResponder()
        case .unFocused:
            textField.resignFirstResponder()
        case .normal:
            containerView.layer.borderColor = UIColor.appColor(\.black40).cgColor
            errorLabel.isHidden = true
        case let .error(errorText):
            containerView.layer.borderColor = UIColor(hexString: "E93E21").cgColor
            errorLabel.text = errorText
            errorLabel.isHidden = false
        case .disabled:
            containerView.layer.borderColor = UIColor.appColor(\.inactiveGray1).cgColor
        }
        
        switch state {
        case .disabled:
            textField.isEnabled = false
            titleLabel.textColor = .appColor(\.inactiveGray1)
            textField.textColor = .appColor(\.inactiveGray1)
        default:
            textField.isEnabled = true
            titleLabel.textColor = .appColor(\.black50)
            textField.textColor = .appColor(\.darkGray)
        }
    }
    
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        let delegateHandover = delegate?.textField(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
        
        return updatedText.count <= maxLength && delegateHandover
    }
    
}
