//
//  AIAAppChipView.swift
//  Components
//
//  Created by Sonny on 12/3/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit
import SnapKit

public final class AIAAppChipView: UIView {
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(\.white)
        label.font = .appFont(\.subText2M)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .appColor(\.black)
        makeRoundedCorner(radius: .appRadius(\.s))
        
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(8)
            $0.directionalVerticalEdges.equalToSuperview().inset(2)
        }
    }
    
    public func bind(_ category: Category) {
        contentLabel.text = category.model.title
        contentLabel.textColor = category.model.titleColor
        backgroundColor = category.model.background
    }
}

extension AIAAppChipView {
    public enum Category {
        case celebrity(String)
        case warrior(String)
        case partner(String)
        case personalize(String)
        case custom(Model)
        
        var model: Model {
            switch self {
            case .celebrity(let title):
                return .init(title: title,
                             titleColor: .appColor(\.white),
                             background: .appColor(\.lightYellow))
                
            case .warrior(let title):
                return .init(title: title,
                             titleColor: .appColor(\.white),
                             background: .appColor(\.black80))
                
            case .partner(let title):
                return .init(title: title,
                             titleColor: .appColor(\.black),
                             background: .appColor(\.lightGray))
                
            case .personalize(let title):
                return .init(title: title,
                             titleColor: .appColor(\.white),
                             background: .appColor(\.black40))
                
            case .custom(let model):
                return model
            
            }
        }
    }
    
    public struct Model {
        let title: String
        let titleColor: UIColor
        let background: UIColor
        
        public init(title: String, titleColor: UIColor, background: UIColor) {
            self.title = title
            self.titleColor = titleColor
            self.background = background
        }
    }
}
