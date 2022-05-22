//
//  File.swift
//  
//
//  Created by Pietro Caruso on 22/05/22.
//

import Foundation

#if !os(Linux)

public extension Sysctl{
    
    ///Object to read `sysctl hw` entries
    final class HW: SysctlCPUInfo{
        public static let namePrefix: String = "hw."
        
        ///Gets the ammount of currently active cpu threads
        public static var activecpu: UInt?{
            return Self.getInteger("activecpu")
        }
        
        ///Gets the ammount of cpu threads
        public static var ncpu: UInt?{
            return Self.getInteger("ncpu")
        }
        
        ///Return the size of a memory page
        public static var pagesize: UInt?{
            return Self.getInteger("pagesize")
        }
        
        ///gets the kenel cpu architecture (on macOS) or the current device model id (for the other platforms)
        public static var machine: String?{
            return Self.getString("machine")
        }
        
        ///gets the current cpu type integer
        public static var cputype: cpu_type_t?{
            return Self.getInteger("cputype")
        }
        
        ///gets the current cpu subtype integer
        public static var cpusubtype: cpu_subtype_t?{
            return Self.getInteger("cpusubtype")
        }
        
        ///gets the current cpu family integer
        public static var cpufamily: UInt32?{
            return Self.getInteger("cpufamily")
        }
        
        ///Gets if the current CPU is a 64 bit cpu
        public static var cpu64bit_capable: Bool?{
            return Self.getBool("cpu64bit_capable")
        }
        
        ///Gets the current ammount of RAM inside the system
        public static var memsize: UInt?{
            return Self.getInteger("memsize")
        }
        
        #if os(macOS) && (arch(x86_64) || arch(i386))
        ///Gets the number of CPU packages inside the current system
        ///NOTE: This information is only available on intel Macs.
        public static var packages: UInt?{
            return Self.getInteger("packages")
        }
        
        ///Gets the nominal cpu frequency in Hz
        ///NOTE: This information is only available on intel Macs.
        public static var cpufrequency: UInt64?{
            return Self.getInteger("cpufrequency")
        }
        
        ///Gets the nominal cpu bus frequency in Hz
        ///NOTE: This information is only available on intel Macs.
        public static var busfrequency: UInt64?{
            return Self.getInteger("busfrequency")
        }
        #endif
        
        ///Object to read `sysctl hw.optional` entries
        public final class Optional: SysctlFetch{
            public static let namePrefix: String = HW.namePrefix + "optional."
        
            #if arch(arm) || arch(arm64)
            ///Object to read `sysctl hw.optional.arm` entries
            public final class ARM: SysctlFetch{
                public static let namePrefix: String = HW.Optional.namePrefix + "arm."
            }
            #endif
        
        }
        
        ///Object to read `sysctl hw.preflevel0` entries
        public final class Perflevel0: SysctlPerflevel{
            public static var index: UInt8 = 0
        }
        
        ///Object to read `sysctl hw.preflevel1` entries
        public final class Perflevel1: SysctlPerflevel{
            public static var index: UInt8 = 1
        }
    }
}

#endif