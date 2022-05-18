/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation
import Darwin.sys

public protocol SysctlFetch: FetchProtocol{
    static var namePrefix: String {get}
}

public extension SysctlFetch{
    
    ///Gets a `String` from the `sysctlbyname` function
    static func getString(_ valueName: String) -> String?{
        
        var size: size_t = 0
        
        var res = sysctlbyname(namePrefix + valueName, nil, &size, nil, 0)
        
        if res != 0 {
            return nil
        }
        
        var ret = [CChar].init(repeating: 0, count: size)
        
        res = sysctlbyname(namePrefix + valueName, &ret, &size, nil, 0)
        
        return res == 0 ? String(utf8String: ret) : nil
    }
    
    ///Gets an Integer value from the `sysctlbyname` function
    static func getInteger<T: FixedWidthInteger>(_ valueName: String) -> T?{
        var ret = T()
        
        var size = MemoryLayout.size(ofValue: ret)
        
        let res = sysctlbyname(namePrefix + valueName, &ret, &size, nil, 0)
        
        return res == 0 ? ret : nil
    }
    
    ///Gets a `Bool` value from the `sysctlbyname` function
    static func getBool(_ valueName: String) -> Bool?{
        guard let res: Int32 = getInteger(valueName) else{
            return nil
        }
        
        return res == 1
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
    
    public final class Kern: SysctlFetch{
        public static let namePrefix: String = "kern"
        
        public static var ostype: String?{
            return Self.getString("ostype")
        }
        
        public static var osrelease: String?{
            return Self.getString("osrelease")
        }
        
        public static var osrevision: String?{
            return Self.getString("osrevision")
        }
        
        public static var version: String?{
            return Self.getString("version")
        }
        
        public static var hostname: String?{
            return Self.getString("hostname")
        }
        
        public static var osproductversioncompat: String?{
            return Self.getString("osproductversioncompat")
        }
        
        public static var osproductversion: String?{
            return Self.getString("osproductversion")
        }
        
        public static var osreleasetype: String?{
            return Self.getString("osreleasetype")
        }
        
        #if os(macOS)
        public static var iossupportversion: String?{
            return Self.getString("iossupportversion")
        }
        #endif
        
        public static var bootargs: String?{
            return Self.getString("bootargs")
        }
    }
    
    public final class User: SysctlFetch{
        public static let namePrefix: String = "user."
    }
    
    public final class VM: SysctlFetch{
        public static let namePrefix: String = "vm."
    }
    
    public final class HW: SysctlFetch{
        public static let namePrefix: String = "hw."
        
        public static var machine: String?{
            return Self.getString("machine")
        }
        
        public static var cputype: cpu_type_t?{
            return Self.getInteger("cputype")
        }
        
        public static var cpusubtype: cpu_subtype_t?{
            return Self.getInteger("cpusubtype")
        }
        
        public static var cpufamily: UInt32?{
            return Self.getInteger("cpufamily")
        }
        
        ///Gets the number of threads of the current CPU
        public static var logicalcpu: UInt64?{
            return Self.getInteger("logicalcpu")
        }
        
        ///Gets the number of cores of the current CPU
        public static var physicalcpu: UInt?{
            return Self.getInteger("physicalcpu")
        }
        
        ///Gets if the current CPU is a 64 bit cpu
        public static var cpu64bit_capable: Bool?{
            return Self.getBool("cpu64bit_capable")
        }
        
        ///Gets the current ammount of RAM inside the system
        public static var memsize: UInt?{
            return Self.getInteger("memsize")
        }
        
        #if os(macOS)
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
    
    public final class Machdep: SysctlFetch{
        public static let namePrefix: String = "machdep."
        
        public final class CPU: SysctlFetch{
            public static let namePrefix: String = Machdep.namePrefix + "cpu."
            
            #if os(macOS)
            ///Gets the number of threads of the current CPU
            public static var threads_count: UInt?{
                return Self.getInteger("thread_count")
            }
            
            ///Gets the number of cores of the current CPU
            public static var cores_count: UInt?{
                return Self.getInteger("core_count")
            }
            
            ///Gets the brand name for the current CPU
            public static var brand_string: String?{
                return Self.getString("brand_string")
            }
            
            ///Gets a string containing all the features supported by the current CPU
            ///NOTE: This information is only available on intel Macs.
            public static var features: String?{
                //return sysctlMachdepCpuString("features", bufferSize: 512)
                return Self.getString("features")
            }
            
            ///Gets the number of cores for each CPU package in the system
            public static var cores_per_package: UInt?{
                return Self.getInteger("cores_per_package")
            }
            
            ///Gets the number of cpu threads for each CPU package in the system
            public static var logical_per_package: UInt?{
                return Self.getInteger("logical_per_package")
            }
            
            #endif
            
            
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
    
}
