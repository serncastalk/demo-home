//
//  HoleViewWithInteractionInHole.swift
//  AIAVATAR
//
//  Created by Duck Sern on 10/11/25.
//  Copyright © 2025 Torilab. All rights reserved.
//

import UIKit
import SnapKit

class HoleViewWithInteractionInHole: UIView {
    
    private lazy var holeMaskLayer = CAShapeLayer()
    private let focusImageMaxDimension: CGFloat = 58
    
    private(set) var holeViewFrame: CGRect = .zero {
        didSet {
            updateMask()
        }
    }
    private(set) var holeViewRadius: CGFloat = .zero {
        didSet {
            updateMask()
        }
    }
    private(set) var holeViewInset: UIEdgeInsets = .zero {
        didSet {
            updateMask()
        }
    }
    
    struct Config {
        var holeViewFrame: CGRect
        var holeViewRadius: CGFloat
        var holeViewInset: UIEdgeInsets
    }
    
    func config(config: Config) {
        self.holeViewFrame = config.holeViewFrame
        self.holeViewRadius = config.holeViewRadius
        self.holeViewInset = config.holeViewInset
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private let fakeView = UIView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black.withAlphaComponent(0.8)
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backgroundView.layer.mask = holeMaskLayer
        addSubview(fakeView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateMask()
    }
    
    private func updateMask() {
        holeMaskLayer.frame = bounds
        let outerPath = UIBezierPath(rect: bounds)
        let holeRect = holeViewFrame.inset(by: holeViewInset)
        let innerPath = UIBezierPath(roundedRect: holeRect, cornerRadius: holeViewRadius)
        outerPath.append(innerPath)
        holeMaskLayer.path = outerPath.cgPath
        holeMaskLayer.fillRule = .evenOdd
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let convert = self.convert(point, to: self)
        if holeViewFrame.contains(convert) {
            return nil
        } else {
            return self
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("SERN :: ", gestureRecognizer)
        return false
    }
}
