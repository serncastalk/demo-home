//
//  IconButton.swift
//  TestUIKit
//
//  Created by Duck Sern on 2/4/25.
//

import UIKit
import SnapKit

class IconButton: UIView {
    struct Config {
        var text: String = ""
    }
    
    private let imgViewContainer = GrandientBackgroundView()
    private let imgView = UIImageView()
    private let label: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = .systemFont(ofSize: 11, weight: .medium)
        return lb
    }()
    
    private var config = Config()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let stackView = {
            let v = UIStackView()
            v.axis = .vertical
            v.spacing = 12
            return v
        }()
        
        
        imgViewContainer.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        stackView.addArrangedSubview(imgViewContainer)
        stackView.addArrangedSubview(label)
        label.isHidden = config.text.isEmpty
    }
}

private class GrandientBackgroundView: UIView {
    override class var layerClass: AnyClass { CAGradientLayer.self }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        guard let layer = layer as? CAGradientLayer else { return }
        layer.colors = [UIColor(hex: 0xF12E11), UIColor(hex: 0xF5AA19)]
        layer.startPoint = .init(x: 0.0, y: 0.5)
        layer.endPoint = .init(x: 1.0, y: 0.5)
    }
}
