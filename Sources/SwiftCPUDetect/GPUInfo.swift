/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022-2023 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */
import Foundation

#if !os(Linux) && !os(Windows) && !os(watchOS)
import Metal

@available(macOS 11.0, iOS 8.0, *) public extension GPUDetection.GPU{
    init(fromMTLDevice device: MTLDevice){
        
        var unified = false
        
        if #available(iOS 13.0, tvOS 13.0, *){
            unified = device.hasUnifiedMemory
        }else{
            #if os(iOS) || os(tvOS)
            unified = true //guessing since all of the devices on those oses use SOCs
            #endif
        }
        
        var memory: UInt64 = 0
        
        if #available(iOS 12.0, tvOS 13.0, *) {
            memory = max(memory, UInt64(device.maxBufferLength))
        }
        
        if #available(iOS 11.0, tvOS 13.0, *) {
            memory = max(memory, UInt64(device.currentAllocatedSize))
        }
        
        #if os(macOS)
            memory = max(memory, device.recommendedMaxWorkingSetSize)
        #endif
        
        self.init(name: device.name, vram: memory, hasUnifiedMemory: unified)
    }
}

@available(macOS 11.0, iOS 8.0, *) public final class GPUDetection{
    
    public struct GPU{
        let name: String
        let vram: UInt64
        let hasUnifiedMemory: Bool
        
        public func infoString() -> String{
            return name + " " + vram.sizeString() + ((hasUnifiedMemory) ? " (Unified)" : "")
        }
        
    }
    
    #if os(macOS)
    class func allMetalGPUs() -> [GPU]{
        var ret = [GPU]()
        
        for gpu in MTLCopyAllDevices(){
            ret.append(.init(fromMTLDevice: gpu))
        }
        
        return ret
    }
    #endif
    
    class func mainMetalGPU() -> GPU?{
        
        guard let gpu = MTLCreateSystemDefaultDevice() else{
            return nil
        }
        
        return GPU(fromMTLDevice: gpu)
    }
    
}
#endif
