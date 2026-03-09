//
//  AIABusinessCardView.swift
//  AIAVATAR
//
//  Created by Janus (Tham Nguyen) - IOS engineer - VN on 02/04/2025.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit
import SnapKit

final public class AIABusinessCardView: UIView {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icn_logo_business_card")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(\.body1SB)
        label.textColor = .appColor(\.black)
        label.numberOfLines = 0
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(\.subText1M)
        label.textColor = .appColor(\.darkGray)
        label.numberOfLines = 0
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(\.subText2M)
        label.textColor = .appColor(\.darkGray)
        label.numberOfLines = 0
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(\.subText2M)
        label.textColor = .appColor(\.darkGray)
        label.numberOfLines = 0
        return label
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_background_business_card")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let shadowLayer = {
        let layer = CALayer()
        layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 40
        return layer
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        shadowLayer.frame = bounds
        shadowLayer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 15).cgPath
    }
    
    private func setupView() {
        let containerView = {
            let v = UIView()
            v.backgroundColor = .white
            v.layer.cornerRadius = 15
            v.layer.masksToBounds = true
            return v
        }()
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        containerView.addSubview(logoImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(phoneLabel)
        containerView.addSubview(emailLabel)
        containerView.addSubview(backgroundImageView)
        containerView.addSubview(qrImageView)

        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.leading.equalToSuperview().inset(22)
            make.height.equalTo(24)
        }
        
        qrImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(24)
            make.width.height.equalTo(73)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(48)
            make.leading.equalToSuperview().inset(22)
            make.trailing.equalTo(qrImageView.snp.leading).offset(-12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalToSuperview().inset(22)
            make.trailing.equalTo(qrImageView.snp.leading).offset(-12)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(22)
            make.trailing.equalTo(qrImageView.snp.leading).offset(-12)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom)
            make.leading.equalToSuperview().inset(22)
            make.bottom.equalToSuperview().inset(24)
            make.trailing.equalTo(qrImageView.snp.leading).offset(-12)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    public func setUpData(name: String, title: String, phone: String, email: String, qrCodeImage: String) {
        self.nameLabel.text = name
        self.titleLabel.text = title
        self.phoneLabel.text = phone
        self.emailLabel.text = email
//        self.qrImageView.load(url: qrCodeImage, placeHolder: nil)
    }
}
