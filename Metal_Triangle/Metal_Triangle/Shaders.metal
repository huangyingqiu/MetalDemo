//
//  Shaders.metal
//  Metal_Triangle
//
//  Created by hyq on 2021/3/10.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 shader_vertex(const device packed_float3 *vertex_array [[ buffer(0) ]],
                           unsigned int vid [[ vertex_id ]]) {
    return float4(vertex_array[vid], 1.0);
}

fragment half4 shader_fragment() {
    return half4(1.0);
}


