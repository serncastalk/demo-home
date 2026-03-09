//
//  TestLiquidGlassVC.swift
//  TestUIKit
//
//  Created by Duck Sern on 29/12/25.
//

import UIKit
import MetalKit
import SnapKit

class GlassOverlayViewController: UIViewController {

    var mtkView: MTKView!
    var renderer: GlassRenderer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. Initialize the Metal View
        mtkView = MTKView(frame: self.view.bounds)
        mtkView.device = MTLCreateSystemDefaultDevice()
        
        // 2. Make the view transparent for overlay use
        mtkView.isOpaque = false
        mtkView.backgroundColor = .clear
        mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        // 3. Add it to the hierarchy
        let centerView = UIView()
        centerView.backgroundColor = .red
        view.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalToSuperview()
        }
        let glassView = MetalGlassOverlay()
        centerView.addSubview(glassView)
        glassView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        //mtkView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // 4. Initialize the Renderer
//        renderer = GlassRenderer(metalKitView: mtkView)
//        mtkView.delegate = renderer
    }

//    // 5. Pass touch events to the renderer
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first, let renderer = renderer else { return }
//        
//        let location = touch.location(in: mtkView)
//        let scale = UIScreen.main.scale
//        
//        // Update the renderer's mouse position (scaled for Retina displays)
//        renderer.mousePosition = simd_float4(
//            Float(location.x * scale),
//            Float(location.y * scale),
//            0, 0
//        )
//    }
}
