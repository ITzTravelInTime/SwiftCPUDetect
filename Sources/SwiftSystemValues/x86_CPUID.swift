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
        
        public let eax: UInt32
        public let ebx: UInt32
        public let ecx: UInt32
        public let edx: UInt32
        
        ///Returns the current registers state after performing the cpuid function for the specified level
        public static func from(level: UInt32) -> Self?{
            
            var eax: UInt32 = 0
            var ebx: UInt32 = 0
            var ecx: UInt32 = 0
            var edx: UInt32 = 0
            
            if __get_cpuid(level, &eax, &ebx, &ecx, &edx) == 0{
                return nil
            }
            
            return .init(eax: eax, ebx: ebx, ecx: ecx, edx: edx)
        }
    }
    
    
}

#endif
