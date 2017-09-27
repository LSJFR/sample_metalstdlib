#ifndef HRMaterialSeamUniform_h
#define HRMaterialSeamUniform_h

#include <metal_stdlib>
using namespace metal;

struct MVPUniform {
  float3 eye_WS;
  
  float4x4 modelMatrix;
  float4x4 modelViewProjectionMatrix;
  float3x3 normalMatrix;
  
  float4x4 pleatBumpMatrix;
  float3x3 pleatBumpTBNMatrix;
  
  float4x4 seamBumpMatrix;
  float3x3 seamBumpTBNMatrix;
};

struct MaterialUniform {
  float3 ambientColor;
  
  float3 diffuseColor;
  float diffuseIntensity;
  
  bool  diffuseMapEnabled;
  
  float specularRoughness;
  bool  isSpecularFloatRoughness;
  
  float specularIntensity;
  float3 specularFilter;
  float3 specularDiffuseFilter;
  
  bool  bumpDiffuseEnabled;
  float bumpDiffuseScale;
  
  bool  bumpSpecularEnabled;
  float bumpSpecularScale;
  
  bool pleatMapEnabled;
  float pleatMapBumpScale;
  
  bool seamMapEnabled;
  
  float4x4 transformMatrix;
};

typedef enum {
  MVP = 0,
  Position,
  Normal,
  Uv,
  Tangent,
  LightmapUv,
  Directions,
} VertexBuffer;

typedef enum {
  Material = 0,
  Environment,
  EnvironmentOrientation,
  ClippingPlane,
  Lighting
} FragmentBuffer;

typedef enum {
  PleatMap = 0,
  DiffuseMap,
  SeamMap,
  SeamBumpMap,
  SpecularFloorCubeMap,
  SpecularCeilCubeMap,
  DiffuseCubeMap,
  LightMaps
} FragmentTexture;

typedef enum {
  Map = 0
} FragmentSampler;

#endif /* HRMaterialSeamUniform_h */
