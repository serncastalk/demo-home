import Metal
import MetalKit
import simd

struct Uniforms {
    var u_resolution: simd_float2
    var u_time: Float
    var _padding: Float // Ensures 16-byte alignment for the next member
    var u_mouse: simd_float4
}

class GlassRenderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    var pipelineState: MTLRenderPipelineState!
    var samplerState: MTLSamplerState!
    
    var startTime: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
    var mousePosition = simd_float4(0, 0, 0, 0)

    init?(metalKitView: MTKView) {
        self.device = metalKitView.device!
        self.commandQueue = device.makeCommandQueue()!
        super.init()
        setupPipeline(metalKitView: metalKitView)
        metalKitView.isOpaque = false
        metalKitView.backgroundColor = .clear
        // Set the clear color to fully transparent
        metalKitView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        // Ensure the layer is transparent
        metalKitView.layer.isOpaque = false
    }

    func setupPipeline(metalKitView: MTKView) {
        let library = device.makeDefaultLibrary()
        let vertexFn = library?.makeFunction(name: "vertex_main") // You'll need a basic vertex shader
        let fragmentFn = library?.makeFunction(name: "fragment_main")

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFn
        pipelineDescriptor.fragmentFunction = fragmentFn
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        
        let colorAttachment = pipelineDescriptor.colorAttachments[0]!
        colorAttachment.isBlendingEnabled = true

        // Standard Alpha Blending formula
        colorAttachment.rgbBlendOperation = .add
        colorAttachment.alphaBlendOperation = .add
        colorAttachment.sourceRGBBlendFactor = .sourceAlpha
        colorAttachment.sourceAlphaBlendFactor = .sourceAlpha
        colorAttachment.destinationRGBBlendFactor = .oneMinusSourceAlpha
        colorAttachment.destinationAlphaBlendFactor = .oneMinusSourceAlpha

        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
        // Setup Sampler
        let samplerDesc = MTLSamplerDescriptor()
        samplerDesc.minFilter = .linear
        samplerDesc.magFilter = .linear
        samplerState = device.makeSamplerState(descriptor: samplerDesc)
    }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor else { return }

        let commandBuffer = commandQueue.makeCommandBuffer()!
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!

        let currentTime = Float(CFAbsoluteTimeGetCurrent() - startTime)
        
        var uniforms = Uniforms(
            u_resolution: simd_float2(Float(view.drawableSize.width), Float(view.drawableSize.height)),
            u_time: currentTime,
            _padding: 0,
            u_mouse: mousePosition
        )

        renderEncoder.setRenderPipelineState(pipelineState)
        
        // Pass Uniforms
        renderEncoder.setFragmentBytes(&uniforms, length: MemoryLayout<Uniforms>.size, index: 0)
        
        // Pass Sampler
        renderEncoder.setFragmentSamplerState(samplerState, index: 0)
        
        // Here you would also set your background texture:
        // renderEncoder.setFragmentTexture(yourTexture, index: 0)

        // Draw a full-screen quad (assuming you have a vertex buffer or
        // generate vertices in the vertex shader)
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)

        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
}
