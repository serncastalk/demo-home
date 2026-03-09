//
//  AIASingleLineRow.swift
//  Components
//
//  Created by Sonny on 10/4/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit.UIView
import SnapKit

public class AIASingleLineRow: UIView, ThemeObservable {
    fileprivate lazy var boundIcon: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(rowIcon)
        view.snp.makeConstraints { $0.size.equalTo(48) }
        rowIcon.snp.makeConstraints { $0.center.equalToSuperview() }
        view.clipsToBounds = true
        return view
    }()
    
    private let rowIcon: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    fileprivate let leadingText: UILabel = {
        let label = UILabel()
        label.font = .appFont(\.body1M)
        label.textColor = .appColor(\.darkGray)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var contentStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [boundIcon, leadingText])
        view.axis = .horizontal
        view.spacing = 0
        view.alignment = .center
        view.distribution = .fill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    fileprivate func setup() {
        addSubview(contentStack)
        contentStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    public func themeDidUpdated() {
        leadingText.font = .appFont(\.body1M)
    }
}

extension AIASingleLineRow {
    public func bind(_ model: Model) {
        rowIcon.image = model.icon
        boundIcon.isHidden = model.icon == nil
        leadingText.text = model.title
    }
}

extension AIASingleLineRow {
    public struct Model {
        let icon: UIImage?
        let title: String
        
        public init(icon: UIImage?, title: String) {
            self.icon = icon
            self.title = title
        }
    }
}

//MARK: - AIASingleLineRow with backgroundColor & rounded
public final class AIARoundedSingleLineRow: AIASingleLineRow {
    override func setup() {
        super.setup()
        boundIcon.backgroundColor = .appColor(\.lightGray)
        leadingText.font = .appFont(\.body2M)
        contentStack.spacing = 12
        makeBorder(width: 1,
                   color: .appColor(\.lightGray),
                   radius: .appRadius(\.l))
        clipsToBounds = true
    }
    
    public func bind(model: AIASingleLineRow.Model) {
        super.bind(model)
    }
    
    public func configLeadingText(configuration: @escaping ((UILabel) -> Void)) {
        configuration(leadingText)
    }
}

//MARK: - Single line with leading and trailing text
public final class AIASingleLineDualTextsView: AIASingleLineRow {
    private let trailingLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(\.body1R)
        label.textColor = .appColor(\.inactiveGray2)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        return label
    }()
    
    override func setup() {
        super.setup()
        contentStack.addArrangedSubview(trailingLabel)
    }
    
    public func bind(model: AIASingleLineRow.Model, subTitle: String, subTitleColor: UIColor) {
        super.bind(model)
        trailingLabel.text = subTitle
        trailingLabel.textColor = subTitleColor
    }
    
    public override func themeDidUpdated() {
        super.themeDidUpdated()
        trailingLabel.font = .appFont(\.body1R)
    }
}

//MARK: - Specific language view
public final class AIASingleLineLanguageView: AIASingleLineRow {
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(\.body1R)
        label.textColor = .appColor(\.inactiveGray2)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    override func setup() {
        super.setup()
        contentStack.addArrangedSubview(languageLabel)
    }
    
    public func bind(model: AIASingleLineRow.Model, language: String) {
        super.bind(model)
        languageLabel.text = language
    }
    
    public override func themeDidUpdated() {
        super.themeDidUpdated()
        languageLabel.font = .appFont(\.body1R)
    }
}

//MARK: - Specific biometric view
public final class AIASingleLineBiometricView: AIASingleLineRow {
    private let toggle: AIAToggle = .init(configuration: .defaultConfiguration)
    
    override func setup() {
        super.setup()
        contentStack.addArrangedSubview(UIView()) //Spacing
        contentStack.addArrangedSubview(toggle)
        toggle.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(40)
        }
    }
    
    public func bind(model: AIASingleLineRow.Model, isOn: Bool, onChange: ((Bool) -> Void)?) {
        super.bind(model)
        toggle.setIsOn(isOn)
        toggle.onInOnChange = onChange
    }
}
