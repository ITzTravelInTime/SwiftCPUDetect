/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation
///Generic protocol to allow methods to fetch values out of `sysctl`
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

public protocol SysctlCPUInfo: SysctlFetch{
    
}

public extension SysctlCPUInfo{
    ///The ammount of cores assinged
    static var physicalcpu: UInt?{
        return Self.getInteger("physicalcpu")
    }
    
    ///The max ammount of cores
    static var physicalcpu_max: UInt?{
        return Self.getInteger("physicalcpu_max")
    }
    
    ///The ammount of threads
    static var logicalcpu: UInt?{
        return Self.getInteger("logicalcpu")
    }
    
    ///The max ammount of threads
    static var logicalcpu_max: UInt?{
        return Self.getInteger("logicalcpu_max")
    }
    
    ///The ammount of L1 instruction
    static var l1icachesize: UInt?{
        return Self.getInteger("l1icachesize")
    }
    
    ///The ammount of L1 data cache
    static var l1dcachesize: UInt?{
        return Self.getInteger("l1dcachesize")
    }
    
    ///The ammount of L2 cache
    static var l2cachesize: UInt?{
        return Self.getInteger("l2cachesize")
    }
    
    #if arch(x86_64) || arch(i386)
    ///The ammount of L3 cache
    static var l3cachesize: UInt?{
        return Self.getInteger("l3cachesize")
    }
    #endif
}

public protocol SysctlPerflevel: SysctlCPUInfo {
    static var index: UInt8 {get}
}

public extension SysctlPerflevel{
    static var namePrefix: String{
        return Sysctl.HW.namePrefix + "perflevel" + String(Self.index) + "."
    }
    
    ///The ammount of cores per L2 cache assinged to this governor
    static var cpusperl2: UInt?{
        return Self.getInteger("cpusperl2")
    }
    
    #if arch(x86_64) || arch(i386)
    ///The ammount of cores per L2 cache assinged to this governor
    static var cpusperl3: UInt?{
        return Self.getInteger("cpusperl3")
    }
    #endif
}

///Object to read `sysctl` entries
public final class Sysctl: SysctlFetch{
    public static let namePrefix: String = ""
    
    #if os(macOS)
    ///Object to read `sysctl sysctl` entries
    public final class Sysctl: SysctlFetch{
        public static let namePrefix: String = "sysctl."
        
        ///Gets is the current process is running as a native process for the current hw
        public static var proc_native: Bool? {
            return Self.getBool("proc_native")
        }
        
        ///gets if the current process is running as translated via rosetta or similar
        public static var proc_translated: Bool? {
            return Self.getBool("proc_translated")
        }
    }
    #endif
    
    ///Object to read `sysctl machdep.kern` entries
    public final class Kern: SysctlFetch{
        public static let namePrefix: String = "kern."
        
        ///The os kernel name
        public static var ostype: String?{
            return Self.getString("ostype")
        }
        
        ///The os kernel version number
        public static var osrelease: String?{
            return Self.getString("osrelease")
        }
        
        ///The os kernel build number
        public static var osrevision: String?{
            return Self.getString("osrevision")
        }
        
        ///The os kernel version string
        public static var version: String?{
            return Self.getString("version")
        }
        
        ///The current hostname or device name
        public static var hostname: String?{
            return Self.getString("hostname")
        }
        
        ///The os legacy version number
        public static var osproductversioncompat: String?{
            return Self.getString("osproductversioncompat")
        }
        
        ///The os version number
        public static var osproductversion: String?{
            return Self.getString("osproductversion")
        }
        
        ///The os release type
        public static var osreleasetype: String?{
            return Self.getString("osreleasetype")
        }
        
        #if os(macOS)
        ///the current version number for the macOS support for ios software
        public static var iossupportversion: String?{
            return Self.getString("iossupportversion")
        }
        #endif
        
        ///the current system boot args
        public static var bootargs: String?{
            return Self.getString("bootargs")
        }
    }
    
    ///Object to read `sysctl user` entries
    public final class User: SysctlFetch{
        public static let namePrefix: String = "user."
    }
    
    ///Object to read `sysctl vm` entries
    public final class VM: SysctlFetch{
        public static let namePrefix: String = "vm."
    }
    
    ///Object to read `sysctl vm` entries
    public final class VFS: SysctlFetch{
        public static let namePrefix: String = "vfs."
    }
    
    ///Object to read `sysctl debug` entries
    public final class Debug: SysctlFetch{
        public static let namePrefix: String = "debug."
    }
    
    ///Object to read `sysctl net` entries
    public final class Net: SysctlFetch{
        public static let namePrefix: String = "net."
    }
    
    ///Object to read `sysctl hw` entries
    public final class HW: SysctlCPUInfo{
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
    
    ///Object to read `sysctl machdep` entries
    public final class Machdep: SysctlFetch{
        public static let namePrefix: String = "machdep."
        
        #if os(macOS)
        
        ///Object to read `sysctl machdep.cpu` entries
        ///NOTE: Some entries are available on intel only
        public final class CPU: SysctlFetch{
            public static let namePrefix: String = Machdep.namePrefix + "cpu."
            
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
            
            ///Gets the number of cores for each CPU package in the system
            public static var cores_per_package: UInt?{
                return Self.getInteger("cores_per_package")
            }
            
            ///Gets the number of cpu threads for each CPU package in the system
            public static var logical_per_package: UInt?{
                return Self.getInteger("logical_per_package")
            }
            
            #if (arch(x86_64) || arch(i386))
            
            ///Gets a string containing all the features supported by the current CPU
            ///NOTE: This information is only available on intel Macs.
            public static var features: String?{
                //return sysctlMachdepCpuString("features", bufferSize: 512)
                return Self.getString("features")
            }
            
            ///Object to read `sysctl machdep.cpu.address_bits entries
            ///NOTE: It might be available only on intel macs
            public final class Address_bits: SysctlFetch{
                public static let namePrefix: String = Machdep.CPU.namePrefix + "address_bits."
            }
            
            #endif
        }
        
        #endif
        
        #if (arch(x86_64) || arch(i386))
        ///Object to read `sysctl machdep.pmap` entries
        public final class Pmap: SysctlFetch{
            public static let namePrefix: String = Machdep.namePrefix + "pmap."
        }
        
        ///Object to read `sysctl machdep.vectors` entries
        public final class Vectors: SysctlFetch{
            public static let namePrefix: String = Machdep.namePrefix + "vectors."
        }
        
        ///Object to read `sysctl machdep.memmap` entries
        public final class Memmap: SysctlFetch{
            public static let namePrefix: String = Machdep.namePrefix + "memmap."
        }
        
        ///Object to read `sysctl machdep.misc` entries
        public final class Misc: SysctlFetch{
            public static let namePrefix: String = Machdep.namePrefix + "misc."
        }
        
        ///Object to read `sysctl machdep.xcpm` entries
        public final class XCPM: SysctlFetch{
            public static let namePrefix: String = Machdep.namePrefix + "xcpm."
        }
        #endif
    }
    
}
