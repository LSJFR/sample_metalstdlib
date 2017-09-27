import Foundation
import Metal
import simd

import HMKit

public final class HRAabb {
  public let vertexBuffer: MTLBuffer
  public let vertexCount: Int
  
  public init(device: MTLDevice) {
    let lines = HMLines()
    
    let p0 = float3(-0.5,  -0.5,  0.5)
    let p1 = float3(-0.5,   0.5,  0.5)
    let p2 = float3( 0.5,   0.5,  0.5)
    let p3 = float3( 0.5,  -0.5,  0.5)
    let p4 = float3(-0.5,  -0.5, -0.5)
    let p5 = float3(-0.5,   0.5, -0.5)
    let p6 = float3( 0.5,   0.5, -0.5)
    let p7 = float3( 0.5,  -0.5, -0.5)
    
    lines.add(startPoint: p0, endPoint: p1)
    lines.add(startPoint: p1, endPoint: p2)
    lines.add(startPoint: p2, endPoint: p3)
    lines.add(startPoint: p3, endPoint: p0)
    
    lines.add(startPoint: p4, endPoint: p5)
    lines.add(startPoint: p5, endPoint: p6)
    lines.add(startPoint: p6, endPoint: p7)
    lines.add(startPoint: p7, endPoint: p4)
    
    lines.add(startPoint: p0, endPoint: p4)
    lines.add(startPoint: p1, endPoint: p5)
    lines.add(startPoint: p2, endPoint: p6)
    lines.add(startPoint: p3, endPoint: p7)
    
    let length = MemoryLayout<HMLine>.stride * lines.lines.count
    self.vertexBuffer = device.makeBuffer(bytes: lines.lines, length: length, options: MTLResourceOptions())
    self.vertexCount = 24
  }
}

// MARK: - Render
extension HRAabb {
  
  private struct InstanceUniform {
    var modelMatrix: float4x4
    var color: float3
  }
  
  private enum VertexBuffer: Int {
    case mpv = 0
    case instances
    case vertices
  }
  
  public static func render(surfaces: [HRSceneSurface], context: HRRenderContext) {
    let encoder = context.encoder
    let resources = context.resources
    let vertexStream = resources.vertexStreams.stream
    
    // Pipeline
    encoder.setRenderPipelineState(resources.aabbPipelineState)
    
    // Vertex
    var mvpu = HRMVPUniform(modelMatrix: float4x4.identity, viewMatrix: context.viewMatrix, viewProjectionMatrix: context.viewProjectionMatrix)
    vertexStream.setVertexBufferOffset(index: VertexBuffer.mpv.rawValue, uniform: &mvpu, length: MemoryLayout<HRMVPUniform>.stride, encoder: encoder)
    
    let instanceStream = resources.vertexInstanceStreams.stream
    instanceStream.setVertexBufferOffset(index: VertexBuffer.instances.rawValue, encoder: encoder)
    
    var instanceCount = 0
    for surface in surfaces where context.isVisible(surface: surface) {
      var iu = InstanceUniform(modelMatrix: surface.aabbMatrix, color: surface.color)
      instanceStream.copy(uniform: &iu, length: MemoryLayout<InstanceUniform>.stride)
      
      instanceCount += 1
    }
    
    if instanceCount > 0 {
      // Mesh
      encoder.setVertexBuffer(resources.aabb.vertexBuffer, offset: 0,  at: VertexBuffer.vertices.rawValue)
      // Draw
      encoder.drawPrimitives(type: .line, vertexStart: 0, vertexCount: resources.aabb.vertexCount, instanceCount: instanceCount)
    }
  }
  
  public static func render(aabb: HMAabb3, context: HRRenderContext, color: float3) {
    let encoder = context.encoder
    let resources = context.resources
    let vertexStream = resources.vertexStreams.stream
    
    // Pipeline
    encoder.setRenderPipelineState(resources.aabbPipelineState)
    
    // Vertex
    var mvpu = HRMVPUniform(modelMatrix: float4x4.identity, viewMatrix: context.viewMatrix, viewProjectionMatrix: context.viewProjectionMatrix)
    vertexStream.setVertexBufferOffset(index: VertexBuffer.mpv.rawValue, uniform: &mvpu, length: MemoryLayout<HRMVPUniform>.stride, encoder: encoder)
    
    let instanceStream = resources.vertexInstanceStreams.stream
    instanceStream.setVertexBufferOffset(index: VertexBuffer.instances.rawValue, encoder: encoder)
    
    var iu = InstanceUniform(modelMatrix: aabb.matrix, color: color)
    instanceStream.copy(uniform: &iu, length: MemoryLayout<InstanceUniform>.stride)
    encoder.setVertexBuffer(resources.aabb.vertexBuffer, offset: 0,  at: VertexBuffer.vertices.rawValue)
    encoder.drawPrimitives(type: .line, vertexStart: 0, vertexCount: resources.aabb.vertexCount, instanceCount: 1)
  }
}

extension HMAabb3 {
  public var matrix: float4x4 {
    let center = self.center
    let dimension = self.dimension
    let translationMatrix = float4x4(translation: center)
    let scaleMatrix = float4x4(scaling: dimension)
    
    return translationMatrix * scaleMatrix
  }
}


