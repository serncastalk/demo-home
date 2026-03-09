//
//  File.metal
//  TestUIKit
//
//  Created by Duck Sern on 29/12/25.
//

#include <metal_stdlib>
using namespace metal;

/*
// Structure to match your uniforms
struct Uniforms {
    float2 u_resolution;
    float u_time;
    float4 u_mouse;
};

// Rounded Rectangle SDF
float sdf_rounded_box(float2 p, float2 b, float r) {
    float2 d = abs(p) - b + float2(r);
    return min(max(d.x, d.y), 0.0) + length(max(d, 0.0)) - r;
}

fragment float4 fragment_main(float2 uv [[stage_in]],
                               constant Uniforms &u [[buffer(0)]])
{
    float2 fragCoord = uv * u.u_resolution;
    float2 glassSize = float2(120.0, 80.0);
    float2 glassCenter = u.u_mouse.xy;
    float2 glassCoord = fragCoord - glassCenter;

    float size = min(glassSize.x, glassSize.y);
    float inversedSDF = -sdf_rounded_box(glassCoord, glassSize * 0.5, 16.0) / size;

    if (inversedSDF < 0.0) {
        // OUTSIDE: Return transparent black
        // The blending setup will ensure the UI underneath is visible here.
        return float4(0.0, 0.0, 0.0, 0.0);
    }

    // INSIDE: Semi-transparent black tint (50% opacity)
    // You don't need the background texture anymore if you want to see through to the UI
    float3 tintColor = float3(0.0, 0.0, 0.0);
    float alpha = 0.5;
    
    return float4(tintColor, alpha);
}

struct VertexOut {
    float4 position [[position]];
    float2 uv;
};

vertex VertexOut vertex_main(uint vid [[vertex_id]]) {
    // Standard full-screen quad vertices
    float2 texCoords[] = { float2(0, 1), float2(1, 1), float2(0, 0), float2(1, 0) };
    float4 positions[] = { float4(-1, -1, 0, 1), float4(1, -1, 0, 1), float4(-1, 1, 0, 1), float4(1, 1, 0, 1) };
    
    VertexOut out;
    out.position = positions[vid];
    out.uv = texCoords[vid];
    return out;
}


struct Uniforms {
    float2 u_resolution;
    float u_time;
    float4 u_mouse;
};

// Helper: SDF for Rounded Rectangle
float sdf_rounded_box(float2 p, float2 b, float r) {
    float2 d = abs(p) - b + float2(r);
    return min(max(d.x, d.y), 0.0) + length(max(d, 0.0)) - r;
}

// Helper: Sampling logic (Converts pixel coords to normalized UV)
float3 getTextureColorAt(texture2d<float> tex, sampler s, float2 pixelCoord, float2 res) {
    float2 uv = pixelCoord / res;
    return tex.sample(s, uv).rgb;
}

// Helper: Gaussian Blur
float3 getBlurredColor(texture2d<float> tex, sampler s, float2 pixelCoord, float2 res, float blurRadius) {
    float3 color = float3(0.0);
    float totalWeight = 0.0;
    
    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            float2 offset = float2(float(x), float(y)) * blurRadius;
            float weight = exp(-0.5 * (float(x*x + y*y)) / 2.0);
            
            color += getTextureColorAt(tex, s, pixelCoord + offset, res) * weight;
            totalWeight += weight;
        }
    }
    return color / totalWeight;
}

fragment float4 fragment_main(float2 uv [[stage_in]],
                               constant Uniforms &u [[buffer(0)]],
                               texture2d<float> backgroundTexture [[texture(0)]],
                               sampler s [[sampler(0)]])
{
    float2 res = u.u_resolution;
    float2 fragCoord = uv * res;
    
    float2 glassSize = float2(120.0, 80.0);
    float2 glassCenter = u.u_mouse.xy;
    float2 glassCoord = fragCoord - glassCenter;
  
    float size = min(glassSize.x, glassSize.y);
    float inversedSDF = -sdf_rounded_box(glassCoord, glassSize * 0.5, 16.0) / size;
  
    // Area outside the glass
    if (inversedSDF < 0.0) {
        return float4(getTextureColorAt(backgroundTexture, s, fragCoord, res), 1.0);
    }
    
    // 1. Refraction / Distortion Calculation
    float2 normalizedGlassCoord = normalize(glassCoord);
    float distFromCenter = 1.0 - clamp(inversedSDF / 0.3, 0.0, 1.0);
    float distortion = 1.0 - sqrt(1.0 - pow(distFromCenter, 2.0)); // Spherical lens math
    float2 offset = distortion * normalizedGlassCoord * glassSize * 0.5;
    float2 glassColorCoord = fragCoord - offset;

    // 2. Blur settings
    float blurIntensity = 1.2;
    float blurRadius = blurIntensity * (1.0 - distFromCenter * 0.5);
    
    // 3. Chromatic Aberration (RGB Shift)
    float edge = smoothstep(0.0, 0.02, inversedSDF);
    float2 shift = normalizedGlassCoord * edge * 3.0;
    
    float3 glassColor = float3(
      getBlurredColor(backgroundTexture, s, glassColorCoord - shift, res, blurRadius).r,
      getBlurredColor(backgroundTexture, s, glassColorCoord,         res, blurRadius).g,
      getBlurredColor(backgroundTexture, s, glassColorCoord + shift, res, blurRadius).b
    );

    // 4. Final Tint
    glassColor *= 0.90;
    
    return float4(glassColor, 1.0);
}

struct VertexOut {
    float4 position [[position]];
    float2 uv;
};

vertex VertexOut vertex_main(uint vid [[vertex_id]]) {
    // Standard full-screen quad vertices
    float2 texCoords[] = { float2(0, 1), float2(1, 1), float2(0, 0), float2(1, 0) };
    float4 positions[] = { float4(-1, -1, 0, 1), float4(1, -1, 0, 1), float4(-1, 1, 0, 1), float4(1, 1, 0, 1) };
    
    VertexOut out;
    out.position = positions[vid];
    out.uv = texCoords[vid];
    return out;
}
*/


struct Uniforms {
    float2 u_resolution;
    float u_time;
    float4 u_mouse;
};

float sdf(float2 p, float2 b, float r) {
    float2 d = abs(p) - b + float2(r);
    return min(max(d.x, d.y), 0.0) + length(max(d, 0.0)) - r;
}

float3 getBlurredColor(texture2d<float> tex, sampler s, float2 coord, float2 res, float radius) {
    float3 color = float3(0.0);
    float totalWeight = 0.0;
    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            float2 offset = float2(float(x), float(y)) * radius;
            float weight = exp(-0.5 * (float(x*x + y*y)) / 2.0);
            color += tex.sample(s, (coord + offset) / res).rgb * weight;
            totalWeight += weight;
        }
    }
    return color / totalWeight;
}

fragment float4 fragment_main(float2 uv [[stage_in]],
                               constant Uniforms &u [[buffer(0)]],
                               texture2d<float> u_texture [[texture(0)]],
                               sampler s [[sampler(0)]])
{
    float2 res = u.u_resolution;
    float2 fragCoord = uv * res;
    float2 glassSize = float2(120.0, 80.0);
    float2 glassCenter = u.u_mouse.xy;
    float2 glassCoord = fragCoord - glassCenter;
  
    float size = min(glassSize.x, glassSize.y);
    float inversedSDF = -sdf(glassCoord, glassSize * 0.5, 16.0) / size;
  
    // Outside the glass: Return transparent so the real UI shows through
    if (inversedSDF < 0.0) {
        return float4(0.0, 0.0, 0.0, 0.0);
    }
    
    // Your Refraction / Distortion Logic
    float2 normalizedGlassCoord = normalize(glassCoord);
    float distFromCenter = 1.0 - clamp(inversedSDF / 0.3, 0.0, 1.0);
    float distortion = 1.0 - sqrt(1.0 - pow(distFromCenter, 2.0));
    float2 offset = distortion * normalizedGlassCoord * glassSize * 0.5;
    float2 glassColorCoord = fragCoord - offset;

    float blurRadius = 1.2 * (1.0 - distFromCenter * 0.5);
    float2 shift = normalizedGlassCoord * smoothstep(0.0, 0.02, inversedSDF) * 3.0;
    
    // Sample the background texture captured from the UI
    float3 glassColor = float3(
        getBlurredColor(u_texture, s, glassColorCoord - shift, res, blurRadius).r,
        getBlurredColor(u_texture, s, glassColorCoord,         res, blurRadius).g,
        getBlurredColor(u_texture, s, glassColorCoord + shift, res, blurRadius).b
    );

    return float4(glassColor * 0.9, 1.0);
}

struct VertexOut {
    float4 position [[position]];
    float2 uv;
};

vertex VertexOut vertex_main(uint vid [[vertex_id]]) {
    // Standard full-screen quad vertices
    float2 texCoords[] = { float2(0, 1), float2(1, 1), float2(0, 0), float2(1, 0) };
    float4 positions[] = { float4(-1, -1, 0, 1), float4(1, -1, 0, 1), float4(-1, 1, 0, 1), float4(1, 1, 0, 1) };
    
    VertexOut out;
    out.position = positions[vid];
    out.uv = texCoords[vid];
    return out;
}
