import Alloy
import Metal

final class ContrastProcessor {
    let context: MTLContext
    let pipelineState: MTLComputePipelineState
    
    public init(context: MTLContext) throws {
        self.context = context
        let library = try context.library(for: Self.self)
        self.pipelineState = try library.computePipelineState(function: "myKernel")
    }
    
    func process(texture: MTLTexture, intensity: Float) throws -> MTLTexture {
        let outputTexture = try texture.matchingTexture(usage: [.shaderRead, .shaderWrite])
        
        try self.context.scheduleAndWait { buffer in
            buffer.compute { encoder in
                encoder.set(textures: [texture, outputTexture])
                encoder.set(intensity, at: 0)
                encoder.dispatch2d(state: self.pipelineState, exactly: outputTexture.size)
            }
            
            #if os(macOS) || targetEnvironment(macCatalyst)
            buffer.blit { encoder in
                encoder.synchronize(resource: outputTexture)
            }
            #endif
        }
        
        return outputTexture
    }
}
