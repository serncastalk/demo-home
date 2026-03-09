//
//  AnimatablePathView.swift
//  TestUIKit
//
//  Created by Duck Sern on 25/8/25.
//

import UIKit

final class R10AnimateShapeView: UIView {
    let shapeLayer = CAShapeLayer()
    
    var generatePath: ((CGRect) -> CGPath)!
    private var elements: [R10PathElement] = []
    var lineDashPattern: [CGFloat] = [10, 10]
    private var path = CGMutablePath()
    var onCompleted: (() -> Void)?
    var index = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(shapeLayer)
        shapeLayer.lineWidth = 10
//        shapeLayer.masksToBounds = true
        shapeLayer.strokeColor = UIColor.white.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
        let path = generatePath!(bounds)
        
        let copy = path.copy(dashingWithPhase: 0, lengths: lineDashPattern)
        var elements: [R10PathElement] = []
        copy.applyWithBlock { elementsPointer in
            let element = R10PathElement(element: elementsPointer.pointee)
            elements.append(element)
        }
        self.elements = elements
    }
    
    func startAnim(onCompleted: (() -> Void)?) {
        index = 0
        _startAnim()
        self.onCompleted = onCompleted
    }
    
    private func _startAnim() {
        guard index < elements.count else {
            onCompleted?()
            return
        }
        //Assume current is at move stage
        updateCurrentPath(index: index)
        index += 1
        while (index < elements.count && !elements[index].isMove) {
            updateCurrentPath(index: index)
            index += 1
        }
        shapeLayer.path = path
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self._startAnim()
        })
    }
    
    func updateCurrentPath(index: Int) {
        guard index < elements.count else { return }
        let ele = elements[index]
        switch ele {
        case .moveToPoint(let cGPoint):
            path.move(to: cGPoint)
        case .addLineToPoint(let cGPoint):
            path.addLine(to: cGPoint)
        case .addQuadCurveToPoint(let control, let to):
            path.addQuadCurve(to: to, control: control)
        case .addCurveToPoint(let control1, let control2, let to):
            path.addCurve(to: to, control1: control1, control2: control2)
        case .closeSubpath:
            path.closeSubpath()
        }
    }
}

enum R10PathElement {
    case moveToPoint(CGPoint)
    case addLineToPoint(CGPoint)
    case addQuadCurveToPoint(CGPoint, CGPoint)
    case addCurveToPoint(CGPoint, CGPoint, CGPoint)
    case closeSubpath
    
    init(element: CGPathElement) {
        switch element.type {
        case .moveToPoint: self = .moveToPoint(element.points[0])
        case .addLineToPoint: self = .addLineToPoint(element.points[0])
        case .addQuadCurveToPoint: self = .addQuadCurveToPoint(element.points[0], element.points[1])
        case .addCurveToPoint: self = .addCurveToPoint(element.points[0], element.points[1], element.points[2])
        case .closeSubpath: self = .closeSubpath
        @unknown default:
            fatalError("Unknown CGPathElement type")
        }
    }
    
    var isMove: Bool {
        switch self {
        case .moveToPoint:
            true
        default:
            false
        }
    }
    
    var isClose: Bool {
        switch self {
        case .closeSubpath:
            true
        default:
            false
        }
    }
}
