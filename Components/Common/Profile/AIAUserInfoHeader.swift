//
//  AIAUserInfoHeader.swift
//  Components
//
//  Created by Sonny on 10/4/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit.UIView
import SnapKit

public final class AIAUserInfoHeader: UIView, ThemeObservable {
    private let avatarView = {
        let v = UIImageView()
        v.layer.cornerRadius = 20
        v.clipsToBounds = true
        return v
    }()
    private let nameLabel = {
        let v = UILabel()
        v.textColor = .appColor(\.darkGray)
        v.font = .appFont(\.body1SB)
        return v
    }()
    private let emailLabel = {
        let v = UILabel()
        v.textColor = .appColor(\.inactiveGray2)
        v.font = .appFont(\.body2M)
        return v
    }()
    private let eyeFlagMemberIcon: UIImageView = {
        let icon = UIImageView(image: .icEyeFlag)
        icon.contentMode = .scaleAspectFit
        icon.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        return icon
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let stackView = {
            let v = UIStackView()
            v.axis = .horizontal
            v.spacing = 12
            v.alignment = .center
            return v
        }()
        stackView.addArrangedSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        let contentStackView = {
            let v = UIStackView()
            v.axis = .vertical
            v.spacing = 8
            return v
        }()
        
        let stackNameAndMemebership = {
            let v = UIStackView()
            v.axis = .horizontal
            v.spacing = 8
            v.alignment = .fill
            return v
        }()
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stackNameAndMemebership.addArrangedSubview(nameLabel)
        stackNameAndMemebership.addArrangedSubview(eyeFlagMemberIcon)
        
        stackView.addArrangedSubview(contentStackView)
        contentStackView.addArrangedSubview(stackNameAndMemebership)
        contentStackView.addArrangedSubview(emailLabel)
        
        let arrowImageView = UIImageView(image: .icOvalArrow)
        stackView.addArrangedSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func bind(avatar: String?, name: String, email: String, isEyeFlagMember: Bool = false) {
        if let avatar, !avatar.isEmpty {
            avatarView.load(url: avatar, placeHolder: .icProfilePlaceholder)
        } else {
            avatarView.image = .icProfilePlaceholder
        }
        nameLabel.text = name
        emailLabel.text = email
        eyeFlagMemberIcon.isHidden = !isEyeFlagMember
    }
    
    public func themeDidUpdated() {
        nameLabel.font = .appFont(\.body1SB)
        emailLabel.font = .appFont(\.body2M)
    }
}
