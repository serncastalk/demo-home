//
//  R10StageView.swift
//  TestUIKit
//
//  Created by Duck Sern on 26/8/25.
//

import UIKit
import SnapKit

final class R10StageView: UIView {
    enum Position {
        case left
        case mid
        case right
    }
    
    var position: Position = .mid
    var title: String = ""
    let circleView: UIView = {
        let v = R10CircleView()
        v.clipsToBounds = false
        return v
    }()
    private let contentView = UIView()
    private let glowView = R10GlowView()
    private let ballView = UIImageView(image: .icFootball)
    private lazy var label = {
        let v = UILabel()
        v.text = title
        v.textAlignment = .center
        v.textColor = .white
        return v
    }()
    
    init(position: Position, title: String) {
        self.position = position
        self.title = title
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        clipsToBounds = false
        addSubview(contentView)
        contentView.addSubview(circleView)
        contentView.addSubview(ballView)
        contentView.addSubview(glowView)
        contentView.addSubview(label)
        circleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(36)
            make.top.equalToSuperview()
        }
        ballView.snp.makeConstraints { make in
            make.bottom.equalTo(circleView).offset(-12)
            make.centerX.equalTo(circleView)
            make.size.equalTo(48)
        }
        glowView.snp.makeConstraints { make in
            make.leading.equalTo(circleView).offset(-8)
            make.trailing.equalTo(circleView).offset(8)
            make.height.equalTo(70)
            make.bottom.equalTo(circleView)
        }
        glowView.horizontalOffset = 8
        glowView.bottomOffset = 18
        label.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.top.equalTo(circleView.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            switch position {
            case .left:
                make.leading.equalToSuperview()
            case .mid:
                make.centerX.equalToSuperview()
            case .right:
                make.trailing.equalToSuperview()
            }
            
            make.width.greaterThanOrEqualToSuperview().multipliedBy(0.4).priority(999)
            make.bottom.top.equalToSuperview()
        }
    }
}

final class R10CircleView: UIView {
    
    let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(shapeLayer)
        layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
        shapeLayer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: 3, dy: 3)).cgPath
        shapeLayer.strokeColor = UIColor.yellow.cgColor
        shapeLayer.lineWidth = 3
        
        shapeLayer.shadowPath = UIBezierPath(ovalIn: bounds.insetBy(dx: -6, dy: -6)).cgPath
        shapeLayer.shadowOffset = .zero
        shapeLayer.shadowColor = UIColor.orange.cgColor
        shapeLayer.shadowRadius = 12
        shapeLayer.shadowOpacity = 1
    }
}

final class R10GlowView: UIView {
    
    let shapeLayer = CAShapeLayer()
    var bigGradientLayer: CAGradientLayer!
    var smallGradientLayer: CAGradientLayer!
    
    let smallShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bigGradientLayer = makeGradientLayer(colours: [.yellow.withAlphaComponent(0), .yellow.withAlphaComponent(0.5)], locations: nil, direction: .topToBottom)
        bigGradientLayer.mask = shapeLayer
        layer.addSublayer(bigGradientLayer)
        
        smallGradientLayer = makeGradientLayer(colours: [.yellow.withAlphaComponent(0), .yellow.withAlphaComponent(1)], locations: [0.5,1], direction: .topToBottom)
        smallGradientLayer.mask = smallShapeLayer
        layer.addSublayer(smallGradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var horizontalOffset: CGFloat = 8
    var bottomOffset: CGFloat = 16
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bigGradientLayer.frame = bounds
        smallGradientLayer.frame = bounds
        shapeLayer.path = genPath().cgPath
        smallShapeLayer.path = genPath().cgPath
    }
    
    private func genPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: .init(x: horizontalOffset, y: bounds.maxY - bottomOffset))
        path.addCurve(
            to:
                    .init(x: bounds.maxX - horizontalOffset, y: bounds.maxY - bottomOffset),
            controlPoint1: .init(x: horizontalOffset + 10, y: bounds.maxY),
            controlPoint2: .init(x: bounds.maxX - horizontalOffset - 10, y: bounds.maxY))
        path.addLine(to: .init(x: bounds.maxX, y: 0))
        path.close()
        return path
    }
}
