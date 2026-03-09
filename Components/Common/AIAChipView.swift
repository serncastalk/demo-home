//
//  AIAChipView.swift
//  Components
//
//  Created by Duck Sern on 4/4/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit
import SnapKit

public final class AIAChipView: UIView {
    public enum Style {
        case filled
        case normal
    }
    public enum State {
        case selected
        case normal
        case disable
    }
    
    private var style: Style = .filled
    private var text: String = ""
    public private(set) var state: State = .normal {
        didSet {
            onStateChange()
        }
    }
    private let label = UILabel()
    private lazy var gradientBorderView = GradientBorderView()
    
    public init(text: String, style: Style) {
        super.init(frame: .zero)
        self.style = style
        self.text = text
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(label)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(6)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        addSubview(gradientBorderView)
        gradientBorderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        layer.cornerRadius = 8
        gradientBorderView.layer.cornerRadius = 8
        clipsToBounds = true
        switch style {
        case .filled:
            label.font = .appFont(\.body1M)
        case .normal:
            label.font = .appFont(\.body1M)
        }
        label.text = text
        setState(.normal)
    }
    
    private func onStateChange() {
        switch (style, state) {
        case (.normal, .normal):
            backgroundColor = .appColor(\.white)
            label.textColor = .appColor(\.darkGray)
            layer.borderWidth = 1
            layer.borderColor = UIColor.appColor(\.middleGray).cgColor
            gradientBorderView.isHidden = true
        case (.normal, .selected):
            gradientBorderView.isHidden = false
            layer.borderWidth = 0
        case (.normal, .disable):
            backgroundColor = .appColor(\.lightGray)
            label.textColor = .appColor(\.darkGray).withAlphaComponent(0.2)
            layer.borderWidth = 1
            layer.borderColor = UIColor.appColor(\.middleGray).cgColor
            gradientBorderView.isHidden = true
        case (.filled, .normal):
            backgroundColor = .appColor(\.black)
            label.textColor = .appColor(\.lightGray)
            gradientBorderView.isHidden = true
        case (.filled, .selected):
            break
        case (.filled, .disable):
            break
        }
    }
    
    public func setState(_ state: State) {
        self.state = state
    }
}

private class GradientBorderView: UIView {
    private var gradientLayer: CAGradientLayer!
    private let maskLayer = CAShapeLayer()
    private var borderWidth:CGFloat = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        gradientLayer = makeGradientLayer(
            colours: [.appColor(\.primary1), .appColor(\.primary2)],
            locations: [0.3, 1.0],
            direction: .custom(start: .init(x: 0.2, y: 0.5), end: .init(x: 1, y: 1)))
        layer.mask = maskLayer
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        maskLayer.frame = bounds
        let outterPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
        let innerPath = UIBezierPath(roundedRect: bounds.insetBy(dx: borderWidth, dy: borderWidth), cornerRadius: layer.cornerRadius)
        outterPath.append(innerPath)
        maskLayer.path = outterPath.cgPath
        maskLayer.fillRule = .evenOdd
    }
}
