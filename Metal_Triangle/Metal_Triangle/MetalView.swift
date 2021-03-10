//
//  MetalView.swift
//  Metal_Triangle
//
//  Created by hyq on 2021/3/10.
//

import UIKit
import Metal

class MetalView: UIView {
    // Properties
    var device: MTLDevice! = nil
    var metalLayer: CAMetalLayer! = nil
    var vertexBuffer: MTLBuffer! = nil
    var metalPipeline: MTLRenderPipelineState! = nil
    var commandQueue: MTLCommandQueue! = nil
    var timer: CADisplayLink! = nil
    
    let vertexData: [Float] = [
        0.0, 0.5, 0.0,
        -1.0, -0.5, 0.0,
        1.0, -0.5, 0.0
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    private func config() {
        device = MTLCreateSystemDefaultDevice()
        
        // Set the CAMetalLayer
        metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.pixelFormat = .bgra8Unorm
        metalLayer.framebufferOnly = true
        metalLayer.frame = layer.frame
        layer.addSublayer(metalLayer)
        
        // Set the  Vertex Buffer
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: [])
        
        // Set the Rendering Pipeline
        let defaultLibrary = device.makeDefaultLibrary()
        let fragmentProgram = defaultLibrary?.makeFunction(name: "shader_fragment")
        let vertexProgram = defaultLibrary?.makeFunction(name: "shader_vertex")
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            try metalPipeline = device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch let error {
            print("Fail to create pipiline stata, error \(error)")
        }
        
        // Set the Command Queue
        commandQueue = device.makeCommandQueue()
        
        render()
        
    }
    
    private func render() {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        let drawable = metalLayer.nextDrawable()
        renderPassDescriptor.colorAttachments[0].texture = drawable?.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        
        // Create Command Buffer
        let commandBuffer = commandQueue.makeCommandBuffer()
        
        // Create Render Command Encoder
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder?.setRenderPipelineState(metalPipeline)
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        renderEncoder?.endEncoding()
        
        // Commit the Command Buffer
        commandBuffer?.present(drawable!)
        commandBuffer?.commit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

