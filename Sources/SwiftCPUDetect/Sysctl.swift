/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

public protocol SysctlFetch{
    static var namePrefix: String {get}
}

public extension SysctlFetch{
    ///Gets a `String` and the fetch score from the `sysctlbyname` function
     static func getStringWithFetchScore(_ valueName: String, bufferSize: size_t) -> (value: String?, score: Int32){
        var ret = [CChar].init(repeating: 0, count: bufferSize)
        
        var size = bufferSize
        
        let res = sysctlbyname(namePrefix + valueName, &ret, &size, nil, 0)
        
        return (value: res == 0 ? String(utf8String: ret) : nil, score: res)
    }
    
    ///Gets an Integer value and the fetch score from the `sysctlbyname` function
    static func getIntegerWithFetchScore<T: FixedWidthInteger>(_ valueName: String) -> (value: T?, score: Int32){
        var ret = T()
        
        var size = MemoryLayout.size(ofValue: ret)
        
        let res = sysctlbyname(namePrefix + valueName, &ret, &size, nil, 0)
        
        return (value: res == 0 ? ret : nil, score: res)
    }
    
    ///Gets a `Bool` value and the fetch score from the `sysctlbyname` function
    static func getBoolWithFetchScore(_ valueName: String) -> (value: Bool?, score: Int32){
        let res: (value: UInt?, score: Int32) = getIntegerWithFetchScore(valueName)
        
        if res.value == nil{
            return (value: nil, score: res.score)
        }
        
        return (value: res.value == 1, score: res.score)
    }
    
    ///Gets a `String` from the `sysctlbyname` function
     static func getString(_ valueName: String, bufferSize: size_t) -> String?{
         return getStringWithFetchScore(valueName, bufferSize: bufferSize).value
    }
    
    ///Gets an Integer value from the `sysctlbyname` function
    static func getInteger<T: FixedWidthInteger>(_ valueName: String) -> T?{
        let ret: T? = getIntegerWithFetchScore(valueName).value
        return ret
    }
    
    ///Gets a `Bool` value from the `sysctlbyname` function
    static func getBool(_ valueName: String) -> Bool?{
        let ret: Bool? = getBoolWithFetchScore(valueName).value
        return ret
    }
    
}

public final class Sysctl: SysctlFetch{
    public static let namePrefix: String = ""
    
    #if os(macOS)
    public final class Sysctl: SysctlFetch{
        public static let namePrefix: String = "sysctl"
        
        public static var proc_native: Bool? {
            return Self.getBool("proc_native")
        }
        
        public static var proc_translated: Bool? {
            return Self.getBool("proc_translated")
        }
    }
    #endif
    
    public final class HW: SysctlFetch{
        public static let namePrefix: String = "hw."
        
        public final class Optional: SysctlFetch{
            public static let namePrefix: String = HW.namePrefix + "optional."
        
            public final class ARM: SysctlFetch{
                public static let namePrefix: String = HW.Optional.namePrefix + "arm."
                
                public final class FEAT_: SysctlFetch{
                    public static let namePrefix: String = HW.Optional.ARM.namePrefix + "FEAT_"
                }
            }
        
        }
        
        public final class Perflevel0: SysctlFetch{
            public static let namePrefix: String = Machdep.CPU.namePrefix + "perflevel0."
        }
        
        public final class Perflevel1: SysctlFetch{
            public static let namePrefix: String = Machdep.CPU.namePrefix + "perflevel1."
        }
    }
    
    #if os(macOS)
    public final class Machdep: SysctlFetch{
        public static let namePrefix: String = "machdep."
        
        public final class CPU: SysctlFetch{
            public static let namePrefix: String = Machdep.namePrefix + "cpu."
            
            public final class Address_bits: SysctlFetch{
                public static let namePrefix: String = Machdep.CPU.namePrefix + "address_bits."
            }
            
            public final class TSC_ccc: SysctlFetch{
                public static let namePrefix: String = Machdep.CPU.namePrefix + "tsc_ccc."
            }
            
            public final class Mwait: SysctlFetch{
                public static let namePrefix: String = Machdep.CPU.namePrefix + "mwait."
            }
            
            public final class Thermal: SysctlFetch{
                public static let namePrefix: String = Machdep.CPU.namePrefix + "thermal."
            }
            
            public final class Xsave: SysctlFetch{
                public static let namePrefix: String = Machdep.CPU.namePrefix + "xsave."
            }
            
            public final class Arch_perf: SysctlFetch{
                public static let namePrefix: String = Machdep.CPU.namePrefix + "arch_perf."
            }
            
            public final class Cache: SysctlFetch{
                public static let namePrefix: String = Machdep.CPU.namePrefix + "cache."
            }
            
            public final class Tlb: SysctlFetch{
                public static let namePrefix: String = Machdep.CPU.namePrefix + "tlb."
            }
        }
        
        public final class Pmap: SysctlFetch{
            public static let namePrefix: String = Machdep.namePrefix + "pmap."
        }
        
        public final class Vectors: SysctlFetch{
            public static let namePrefix: String = Machdep.namePrefix + "vectors."
        }
        
        public final class Memmap: SysctlFetch{
            public static let namePrefix: String = Machdep.namePrefix + "memmap."
        }
        
        public final class TSC: SysctlFetch{
            public static let namePrefix: String = Machdep.namePrefix + "tsc."
            
            public final class Nanotime: SysctlFetch{
                public static let namePrefix: String = Machdep.TSC.namePrefix + "nanotime."
            }
        }
        
        public final class Misc: SysctlFetch{
            public static let namePrefix: String = Machdep.namePrefix + "misc."
        }
        
        public final class XCPM: SysctlFetch{
            public static let namePrefix: String = Machdep.namePrefix + "xcpm."
        }
    }
    #endif
    
}
