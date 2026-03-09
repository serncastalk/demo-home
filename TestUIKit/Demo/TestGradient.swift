//
//  TestGradient.swift
//  TestUIKit
//
//  Created by Duck Sern on 13/1/26.
//

import UIKit

final class TestGradient: UIViewController {
    var gra: CAGradientLayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        
        let gradientLayer = UIView().makeGradientLayer(
            colours: [.white, .white, .white.withAlphaComponent(0)],
            locations: [0,0.78,1],
            direction: .bottomToTop)
        view.layer.addSublayer(gradientLayer)
        self.gra = gradientLayer
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gra.frame = view.bounds
    }
}
