//
//  R10CountryVC.swift
//  TestUIKit
//
//  Created by Duck Sern on 27/8/25.
//

import UIKit
import SnapKit

final class CountryPath: UIView {
    
    enum Direction {
        case leftToRight
        case rightToLeft
    }
    
    let shapeLayer = CAShapeLayer()
    
    var direction: Direction = .leftToRight
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        layer.addSublayer(shapeLayer)
        shapeLayer.strokeColor = UIColor.orange.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.shadowOffset = .init(width: 0, height: 2)
        shapeLayer.shadowRadius = 8
        shapeLayer.shadowColor = UIColor.green.cgColor
        shapeLayer.shadowOpacity = 1
//        shapeLayer.strokeEnd = 0
        shapeLayer.isOpaque = false
        shapeLayer.backgroundColor = UIColor.clear.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shapeLayer.frame = bounds
        
        shapeLayer.path = genPath().cgPath
        shapeLayer.shadowPath = genPath().cgPath.copy(strokingWithWidth: 3, lineCap: .square, lineJoin: .miter, miterLimit: 0)
    }
    
    private func genPath() -> UIBezierPath {
        switch direction {
        case .rightToLeft:
            let path = UIBezierPath()
            path.move(to: bounds.bottomLeft)
            path.addCurve(
                to: bounds.topRight,
                controlPoint1: .init(x: 10, y: bounds.midY),
                controlPoint2: .init(x: bounds.midX, y: -bounds.midY))
            return path
        case .leftToRight:
            let path = UIBezierPath()
            path.move(to: bounds.bottomRight)
            path.addCurve(
                to: bounds.topLeft,
                controlPoint1: .init(x: bounds.maxX - 10, y: bounds.midY),
                controlPoint2: .init(x: bounds.midX, y: -bounds.maxY))
            return path
        }
    }
}

final class R10CountryVC: UIViewController {
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countryViews = [
            //CountryView(position: .mid, img: .icNigeria),
            CountryView(position: .right, img: .icJapan),
            CountryView(position: .left, img: .icEngland),
            //CountryView(position: .right, img: .icArgentina),
            CountryView(position: .left, img: .icBrazil),
        ]
        
        let image = UIImageView(image: .icFootball)
        
        let stackView = {
            let v = UIStackView(arrangedSubviews: countryViews)
            v.axis = .vertical
            return v
        }()
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        for i in 0...countryViews.count - 2 {
            let curr = countryViews[i]
            let next = countryViews[i + 1]
            let shapeView = CountryPath()
            let direction: CountryPath.Direction = {
                switch next.position {
                case .right:
                    return .leftToRight
                case .mid:
                    if curr.position == .right {
                        return .rightToLeft
                    } else {
                        return .leftToRight
                    }
                case .left:
                    return .rightToLeft
                }
            }()
            shapeView.direction = direction
            view.addSubview(shapeView)
            switch direction {
            case .leftToRight:
                shapeView.snp.makeConstraints { make in
                    make.top.leading.equalTo(curr.pinPoint)
                    make.bottom.trailing.equalTo(next.pinPoint)
                }
            case .rightToLeft:
                shapeView.snp.makeConstraints { make in
                    make.top.trailing.equalTo(curr.pinPoint)
                    make.bottom.leading.equalTo(next.pinPoint)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

final class CountryView: UIView {
    enum Position {
        case left
        case mid
        case right
    }
    
    var position: Position = .left
    var img: UIImage? = nil
    var pinPoint = UIView()
    
    
    init(position: Position, img: UIImage?) {
        self.position = position
        self.img = img
        super.init(frame: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
