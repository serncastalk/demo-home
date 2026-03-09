//
//  AIAScanBusinessCardCornerView.swift
//  AIAVATAR
//
//  Created by Duck Sern on 15/4/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit

final public class AIAScanBusinessCardCornerView: UIView {
    public static let width: CGFloat = 6.0
    
    public var fillColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        let width = Self.width
        let bottomLeft: CGPoint = .init(x: 0, y: rect.height)
        let topLeft: CGPoint = .zero
        let topRight: CGPoint = .init(x: rect.width, y: 0)
        path.move(to: bottomLeft)
        path.addQuadCurve(to: topRight, controlPoint: topLeft)
        
        path.addLine(to: .init(x: rect.width, y: width))
        path.addQuadCurve(to: .init(x: width, y: rect.height), controlPoint: .init(x: width, y: width))
        path.addLine(to: bottomLeft)
        path.close()
        
        fillColor.setFill()
        path.fill()
    }
}
