//
//  AIAGradientView.swift
//  Components
//
//  Created by Duck Sern on 23/7/25.
//  Copyright © 2025 Torilab. All rights reserved.
//

import UIKit

public class AIAGradientView: UIView {
    
    public struct Config {
        public var colours: [UIColor] = []
        public var locations: [NSNumber]?
        public var direction: AIAGradientDirection = .bottomToTop
        
        public static let primary: Self = .init(
            colours: [.appColor(\.primary1), .appColor(\.primary2)],
            locations: [0.3, 1.0],
            direction: .custom(start: .init(x: 0.2, y: 0.5), end: .init(x: 1, y: 1))
        )
        
        public init(colours: [UIColor], locations: [NSNumber]? = nil, direction: AIAGradientDirection) {
            self.colours = colours
            self.locations = locations
            self.direction = direction
        }
        
        init() {}
    }
    
    private var config = Config()
    
    public init(config: Config) {
        self.config = config
        super.init(frame: .zero)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private var gradientLayer: CAGradientLayer!
    
    private func setup() {
        gradientLayer = makeGradientLayer(
            colours: config.colours,
            locations: config.locations,
            direction: config.direction)
        layer.addSublayer(gradientLayer)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
