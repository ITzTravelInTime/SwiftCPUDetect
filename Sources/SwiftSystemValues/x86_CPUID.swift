//
//  File.swift
//  
//
//  Created by Pietro Caruso on 26/07/22.
//

import Foundation

#if (arch(x86_64) || arch(i386))
import _Builtin_intrinsics.intel
import _Builtin_intrinsics.intel.cpuid
#endif

import SwiftPackagesBase

public final class CPUID{
    public struct Registers: Copying, Codable, Equatable{
        
        public static var queryCache: [Self] = []
        
        public func copy() -> Self {
            return .init(eax: eax, ebx: ebx, ecx: ecx, edx: edx, queryLevel1: queryLevel1, queryLevel2: queryLevel2)
        }
        
        ///The contents of the EAX register after the CPUID instruction
        public let eax: UInt32
        ///The contents of the EBX register after the CPUID instruction
        public let ebx: UInt32
        ///The contents of the ECX register after the CPUID instruction
        public let ecx: UInt32
        ///The contents of the EDX register after the CPUID instruction
        public let edx: UInt32
        
        ///The contents of the EAX register before the CPUID instruction
        public let queryLevel1: UInt32
        
        ///The contents of the ECX register before the CPUID instruction
        public let queryLevel2: UInt32?
        
        #if (arch(x86_64) || arch(i386))
        ///Regulates if queries must be stored in cache
        public static var storeQueryInCache: Bool = true
        
        ///Regulates if the queries shuld be taken from cache instead of being taken frm the system each time
        public static var recoverFromCache: Bool = false
        #endif
        
        ///Returns the current registers state after performing the cpuid function for the specified levels
        public static func from(level: UInt32, extendedLevel: UInt32? = nil, doNotRecoverFromCache: Bool = false ) -> Self?{
            
            #if (arch(x86_64) || arch(i386))
            let recover = recoverFromCache && !doNotRecoverFromCache
            #else
            let recover = !doNotRecoverFromCache
            #endif
            
            if recover {
                var ret: Self? = nil
                
                for data in queryCache where data.queryLevel1 == level && data.queryLevel2 == extendedLevel {
                    ret = data
                }
                
                if let data = ret{
                    return data
                }
            }
            
            #if (arch(x86_64) || arch(i386))
            var eax: UInt32 = 0
            var ebx: UInt32 = 0
            var ecx: UInt32 = 0
            var edx: UInt32 = 0
            
            if let extended = extendedLevel{
                
                if __get_cpuid_count(level, extended, &eax, &ebx, &ecx, &edx) == 0{
                    return nil
                }
                
            } else if __get_cpuid(level, &eax, &ebx, &ecx, &edx) == 0{
                return nil
            }
            
            let ret = Self.init(eax: eax, ebx: ebx, ecx: ecx, edx: edx, queryLevel1: level, queryLevel2: extendedLevel)
            
            if storeQueryInCache{
                queryCache.append(ret)
            }
            
            return ret
            #else
            return nil
            #endif
        }
    }
    
    
}

