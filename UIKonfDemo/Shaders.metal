//
//  Shaders.metal
//  UIKonfDemo
//
//  Created by Andrey Volodin on 14.05.2020.
//  Copyright © 2020 Andrey Volodin. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void myKernel(texture2d<half, access::read> input [[ texture(0) ]],
                     texture2d<half, access::write> output [[ texture(1) ]],
                     constant float& intensity [[ buffer(0) ]],
                     uint2 threadPosition [[ thread_position_in_grid ]]) {
    half4 inputColor = input.read(threadPosition);
    
    inputColor *= intensity;
    
    output.write(inputColor, threadPosition);
}
