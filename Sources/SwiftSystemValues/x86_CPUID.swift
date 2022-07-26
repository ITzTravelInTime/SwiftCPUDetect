//
//  File.swift
//  
//
//  Created by Pietro Caruso on 26/07/22.
//

import Foundation

#if (arch(x86_64) || arch(i386)) && !(os(Linux) || os(Windows))
import _Builtin_intrinsics.intel
import _Builtin_intrinsics.intel.cpuid
import SwiftPackagesBase

public final class CPUID{
    public struct Registers: Copying{
        public func copy() -> Self {
            return .init(eax: eax, ebx: ebx, ecx: ecx, edx: edx)
        }
        
        var eax: UInt32 = 0
        var ebx: UInt32 = 0
        var ecx: UInt32 = 0
        var edx: UInt32 = 0
        
        public mutating func performCPUIDData(_ leaf: UInt32) -> Int32{
            return __get_cpuid(leaf, &eax, &ebx, &ecx, &edx)
        }
        
        public func performingCPUIDData(_ leaf: UInt32, returnValue retVal: UnsafeMutablePointer<Int32>! = nil) -> Self{
            var ret = copy()
            
            let val = ret.performCPUIDData(leaf)
            
            if retVal != nil{
                retVal?.pointee = val
            }
            
            return ret
        }
    }
    
    
}

#endif
