#include <metal_stdlib>

#include "HRMetalHelper.h"

using namespace metal;

struct InstanceUniform {
  float4x4 modelMatrix;
  float3 color;
};

struct ProjectedVertex {
  float4 position_CS [[ position ]];
  half3 color;
};

typedef enum {
  ViewProjection = 0,
  Instances,
  Vertices
} VertexBuffer;

vertex ProjectedVertex aabbVertex(constant HRMVPUniform &mvp [[ buffer(VertexBuffer::ViewProjection) ]],
                                  device const InstanceUniform *instanceUniforms [[ buffer(VertexBuffer::Instances) ]],
                                  device const float3 *vertices [[ buffer(VertexBuffer::Vertices) ]],
                                  uint vid [[ vertex_id ]],
                                  uint iid [[instance_id]]) {
  ProjectedVertex pv;
  
  float4x4 modelMatrix = instanceUniforms[iid].modelMatrix;
  half3 color = half3(instanceUniforms[iid].color);
  float4 v = float4(vertices[vid], 1.0f);
  
  pv.position_CS = mvp.modelViewProjectionMatrix * modelMatrix * v;
  pv.color = color;
  
  return pv;
}

fragment half4 aabbFragment(ProjectedVertex pv [[ stage_in ]]) {
  return half4(pv.color, 1.0h);
}
