//
//  ViewController.swift
//  TestUIKit
//
//  Created by Duck Sern on 31/3/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    private let holeView = HoleViewWithInteractionInHole()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(onTap))
        tapGR.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGR)
        
        let button = UIButton()
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        button.addTarget(self, action: #selector(onTapButton), for: .touchUpInside)
        
        print("SERN :: init tapGR = ", tapGR)
        
        view.addSubview(holeView)
        holeView.config(config: .init(
            holeViewFrame: .init(x: 200, y: 200, width: 200, height: 200),
            holeViewRadius: 0,
            holeViewInset: .zero))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = .red
        holeView.frame = view.bounds
    }
    
    @objc func onTap() {
        print("SERN :: ")
    }
    
    @objc func onTapButton() {
        print("SERN :: button")
    }
}

extension CGPath {
    var length: CGFloat {
        var totalLength: CGFloat = 0
        var previousPoint: CGPoint?

        self.applyWithBlock { element in
            let points = element.pointee.points
            guard let prev = previousPoint else {
                return element.pointee.type == .moveToPoint ? previousPoint = points[0] : ()
            }

            switch element.pointee.type {
            case .addLineToPoint:
                totalLength += distance(from: prev, to: points[0])
                previousPoint = points[0]

            case .addQuadCurveToPoint:
                totalLength += quadCurveLength(from: prev, to: points[1], control: points[0])
                previousPoint = points[1]

            case .addCurveToPoint:
                totalLength += cubicCurveLength(from: prev, to: points[2], control1: points[0], control2: points[1])
                previousPoint = points[2]

            default: break
            }
        }
        return totalLength
    }

    private func distance(from p1: CGPoint, to p2: CGPoint) -> CGFloat { hypot(p2.x - p1.x, p2.y - p1.y) }

    // Approximate the quadratic Bezier curve length
    private var subdivisions: Int { 50 }

    private func quadCurveLength(from start: CGPoint, to end: CGPoint, control: CGPoint) -> CGFloat {
        var length: CGFloat = 0.0
        var previousPoint = start

        for i in 1...subdivisions {
            let t = CGFloat(i) / CGFloat(subdivisions)
            let x = (1.0 - t) * (1.0 - t) * start.x + 2.0 * (1.0 - t) * t * control.x + t * t * end.x
            let y = (1.0 - t) * (1.0 - t) * start.y + 2.0 * (1.0 - t) * t * control.y + t * t * end.y
            let currentPoint = CGPoint(x: x, y: y)
            length += distance(from: previousPoint, to: currentPoint)
            previousPoint = currentPoint
        }
        return length
    }

    private func cubicCurveLength(from start: CGPoint, to end: CGPoint, control1: CGPoint, control2: CGPoint) -> CGFloat {
        var length: CGFloat = 0.0
        var previousPoint = start

        for i in 1...subdivisions {
            let t = CGFloat(i) / CGFloat(subdivisions)
            let x = pow(1.0 - t, 3) * start.x + 3.0 * pow(1.0 - t, 2) * t * control1.x + 3.0 * (1.0 - t) * pow(t, 2) * control2.x + pow(t, 3) * end.x
            let y = pow(1.0 - t, 3) * start.y + 3.0 * pow(1.0 - t, 2) * t * control1.y + 3.0 * (1.0 - t) * pow(t, 2) * control2.y + pow(t, 3) * end.y
            let currentPoint = CGPoint(x: x, y: y)
            length += distance(from: previousPoint, to: currentPoint)
            previousPoint = currentPoint
        }
        return length
    }
}

enum PathElement {
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
}
