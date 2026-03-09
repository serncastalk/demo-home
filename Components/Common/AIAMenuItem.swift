//
//  AIAMenuItem.swift
//  Components
//
//  Created by Duck Sern on 4/4/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit
import SnapKit

public final class AIAMenuItem: UIView {
    private static let MIN_HEIGHT: CGFloat = 24.0
    public struct Configuration {
        public var image: UIImage? = nil
        public var title: String = ""
        public var desc: String = ""
        public var hasToogle: Bool = true
        
        public init(image: UIImage? = nil, title: String, hasToggle: Bool) {
            self.image = image
            self.title = title
            self.hasToogle = hasToggle
        }
        
        public init(image: UIImage? = nil, title: String, desc: String, hasToggle: Bool) {
            self.image = image
            self.title = title
            self.desc = desc
            self.hasToogle = hasToggle
        }
        
        public init() {}
    }
    
    private lazy var toggleView = AIAToggle(configuration: .defaultConfiguration)
    private let imgView = UIImageView()
    private let titleLabel = {
        let v = UILabel()
        v.font = .appFont(\.body1M)
        v.numberOfLines = 0
        v.textColor = .appColor(\.black)
        return v
    }()
    private let dummyTitleLabel = {
        let v = UILabel()
        v.font = .appFont(\.body1M)
        v.numberOfLines = 1
        v.alpha = 0
        v.textColor = .appColor(\.black)
        return v
    }()
    private let descLabel = {
        let v = UILabel()
        v.font = .appFont(\.subText2M)
        v.numberOfLines = 0
        v.textColor = .appColor(\.inactiveGray2)
        return v
    }()
    private var configuration: Configuration = .init()
    public var onIsOnChange: ((Bool) -> Void)? {
        didSet {
            toggleView.onInOnChange = onIsOnChange
        }
    }
    
    public init(configuration: Configuration) {
        super.init(frame: .zero)
        self.configuration = configuration
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let stackView = {
            let v = UIStackView()
            v.axis = .horizontal
            v.alignment = .top
            v.spacing = 12
            return v
        }()
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(Self.MIN_HEIGHT)
            make.edges.equalToSuperview()
        }
        imgView.image = configuration.image
        let imgViewContainer = UIView()
        imgViewContainer.addSubview(imgView)
        stackView.addArrangedSubview(imgViewContainer)
        imgView.snp.makeConstraints { make in
            make.width.height.equalTo(Self.MIN_HEIGHT)
        }
        titleLabel.text = configuration.title
        dummyTitleLabel.text = configuration.title
        descLabel.text = configuration.desc
        
        let titleContainerView = {
            let v = UIView()
            v.addSubview(dummyTitleLabel)
            v.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            dummyTitleLabel.snp.makeConstraints { make in
                make.top.directionalHorizontalEdges.equalToSuperview()
            }
            return v
        }()
        let textStackView = {
            let v = UIStackView(arrangedSubviews: [titleContainerView, descLabel])
            v.axis = .vertical
            return v
        }()
        titleContainerView.isHidden = configuration.title.isEmpty
        descLabel.isHidden = configuration.desc.isEmpty
        stackView.addArrangedSubview(textStackView)
        textStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
        imgView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.bottom.equalToSuperview()
            make.centerY.equalTo(dummyTitleLabel)
        }
        if configuration.hasToogle {
            let containerToogleView = UIView()
            containerToogleView.addSubview(toggleView)
            stackView.addArrangedSubview(containerToogleView)
            toggleView.snp.makeConstraints { make in
                make.height.equalTo(Self.MIN_HEIGHT)
                make.directionalHorizontalEdges.bottom.equalToSuperview()
                make.centerY.equalTo(dummyTitleLabel)
                make.width.equalTo(40)
            }
        }
    }
    
    public func setIsOn(_ value: Bool) {
        guard configuration.hasToogle else { return }
        toggleView.setIsOn(value)
    }
    
    public func setConfiguration(_ configuration: Configuration) {
        self.configuration = configuration
        imgView.image = configuration.image
        titleLabel.text = configuration.title
        toggleView.isHidden = !configuration.hasToogle
    }
    
    public func toggle() {
        toggleView.toggle()
    }
}

