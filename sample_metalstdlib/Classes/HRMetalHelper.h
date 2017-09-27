#ifndef HRMetalHelper_h
#define HRMetalHelper_h

using namespace metal;

#pragma mark - Uniform Declaration
struct HRMVPUniform {
  float4x4 modelMatrix;
  float4x4 modelViewMatrix;
  float4x4 modelViewProjectionMatrix;
  float3x3 normalMatrix;
  float3x3 normalViewMatrix;
};

struct HRLightingUniform {
  float3 color;
};

enum ParallaxType {
  None = 0,
  Aabb,
  Hemisphere,
  Mesh
};

struct HREnvironmentUniform {
  float saturation;
  float gamma;
  
  float diffuseColoration;
  float diffuseExposure;
  
  float specularExposure;
  
  float backgroundAltitude;
  float backgroundExposure;
  
  int parallaxType;
  float3 aabbMin;
  float3 aabbMax;
  float3 hemisphereCenter;
  float  hemisphereRadius;
};

struct HREnvironmentOrientationUniform {
  float3x3 worldToLocalRotationMatrix;
  float3 worldToLocalTranslation;
  float3 environmentPosition;
};

struct HRClippingPlaneUniform {
  bool enabled;
  
  float3 n;
  float q;
  
  float3 color;
  float thickness;
};

#pragma mark - Function Declaration
half  ColorLinearTosRGB(half v);
half3 ColorLinearTosRGB(half3 c);
half3 ColorRenderToLinear(half3 c);
half3 ColorRenderTosRGB(half3 c);
half  ColorsRGBToLinear(half c);
half3 ColorsRGBToLinear(half3 c);
half3 ColorLinearToRender(half3 c);
half3 ColorsRGBToRender(half3 c);
half3 ColorLightmapToRender(half3 c);

half  ColorLuminance(half3 c);
half  ColorLuminance(half4 c);

half4 ColorCorrection(half4 color, half saturation, half exposure);

#pragma mark - Sample Texture
half4  SampleTexture(sampler s, texture2d<float> t, float2 uv);
half4  SampleTexture(sampler s, texture1d<float> t, float u);

float3 SampleBump(sampler s, texture2d<float> t, float2 uv);
half3 SampleVideo(sampler s, texture2d<float> t, float2 uv);

#pragma mark - TBN
float3 TBNMakeTangent(float3 normal_OS, float3 tangent_OS, float3x3 tbnRotationMatrix, float3x3 normalMatrix);
float3 TBNMakeNormal(float3 bumpedNormal_TS, float3 normal_WS, float3 tangent_WS, float scale);

#pragma mark - Clipping Plane
half4  ClipWithPlane(constant HRClippingPlaneUniform& plane, float3 position_WS, half4 color);
float4 ClipWithPlane(constant HRClippingPlaneUniform& plane, float3 position_WS, float4 color);

#pragma mark - Petzl special dedicace for LAN
float3 Petzl(float3 position_ES);
float3 PetzlSpecular(float3 petzl_ES, float3 normal_ES);
float3 PetzlDiffuse(float3 petzl_ES, float3 normal_ES);

#endif /* HRMetalHelper_h */
