import UIKit
import Metal
import MetalKit

class MetalGlassOverlay: MTKView {
    private var pipelineState: MTLRenderPipelineState!
    private var commandQueue: MTLCommandQueue!
    private var samplerState: MTLSamplerState!
    private var backgroundTexture: MTLTexture?
    private var mousePosition = simd_float4(0, 0, 0, 0)

    struct Uniforms {
        var u_resolution: simd_float2
        var u_time: Float
        var _padding: Float
        var u_mouse: simd_float4
    }

    override init(frame: CGRect, device: MTLDevice?) {
        super.init(frame: frame, device: device ?? MTLCreateSystemDefaultDevice())
        setup()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.device = MTLCreateSystemDefaultDevice()
        setup()
    }

    private func setup() {
        self.isOpaque = false
        self.backgroundColor = .clear
        self.delegate = self
        
        // Setup Alpha Blending so transparent areas stay transparent
        commandQueue = device?.makeCommandQueue()
        let library = device?.makeDefaultLibrary()
        let desc = MTLRenderPipelineDescriptor()
        desc.vertexFunction = library?.makeFunction(name: "vertex_main")
        desc.fragmentFunction = library?.makeFunction(name: "fragment_main")
        desc.colorAttachments[0].pixelFormat = .bgra8Unorm
        desc.colorAttachments[0].isBlendingEnabled = true
        desc.colorAttachments[0].sourceRGBBlendFactor = .one
        desc.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        
        pipelineState = try? device?.makeRenderPipelineState(descriptor: desc)
        
        let sDesc = MTLSamplerDescriptor()
        sDesc.minFilter = .linear; sDesc.magFilter = .linear
        samplerState = device?.makeSamplerState(descriptor: sDesc)
    }

    // This makes the view "Automatic"
    private func updateBackgroundTexture() {
        guard let superview = self.superview else { return }
        
        // Temporarily hide self so we don't capture the glass in the background
        self.isHidden = true
        let renderer = UIGraphicsImageRenderer(size: superview.bounds.size)
        let image = renderer.image { _ in
            superview.drawHierarchy(in: superview.bounds, afterScreenUpdates: false)
        }
        self.isHidden = false
        
        let loader = MTKTextureLoader(device: device!)
        backgroundTexture = try? loader.newTexture(cgImage: image.cgImage!, options: [.SRGB: false])
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let loc = touches.first?.location(in: self) {
            let s = UIScreen.main.scale
            mousePosition = simd_float4(Float(loc.x * s), Float(loc.y * s), 0, 0)
            // Update the background on touch to keep it feeling "live"
            updateBackgroundTexture()
        }
    }
}

extension MetalGlassOverlay: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let pass = view.currentRenderPassDescriptor,
              let bg = backgroundTexture else { return }
        
        let buffer = commandQueue.makeCommandBuffer()!
        let encoder = buffer.makeRenderCommandEncoder(descriptor: pass)!
        
        var uniforms = Uniforms(
            u_resolution: simd_float2(Float(view.drawableSize.width), Float(view.drawableSize.height)),
            u_time: 0, _padding: 0, u_mouse: mousePosition
        )
        
        encoder.setRenderPipelineState(pipelineState)
        encoder.setFragmentBytes(&uniforms, length: MemoryLayout<Uniforms>.size, index: 0)
        encoder.setFragmentTexture(bg, index: 0)
        encoder.setFragmentSamplerState(samplerState, index: 0)
        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        
        encoder.endEncoding()
        buffer.present(drawable)
        buffer.commit()
    }
}
