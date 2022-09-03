/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

#if !os(Linux)

public extension Sysctl{
    
    ///Object to read `sysctl hw` entries
    final class HW: SysctlCPUInfo{
        public static let namePrefix: String = "hw."
        
        ///Gets the ammunt of perf levels of the current system
        public static var nperflevels: UInt?{
            return getInteger("nperflevels")
        }
        
        ///Gets the ammount of currently active cpu threads
        public static var activecpu: UInt?{
            return getInteger("activecpu")
        }
        
        ///Gets the ammount of cpu threads
        public static var ncpu: UInt?{
            return getInteger("ncpu")
        }
        
        ///Return the size of a memory page
        public static var pagesize: UInt?{
            return getInteger("pagesize")
        }
        
        ///gets the kenel cpu architecture (on macOS) or the current device model id (for the other platforms)
        public static var machine: String?{
            return getString("machine")
        }
        
        ///gets the current cpu type integer
        public static var cputype: cpu_type_t?{
            return getInteger("cputype")
        }
        
        ///gets the current cpu subtype integer
        public static var cpusubtype: cpu_subtype_t?{
            return getInteger("cpusubtype")
        }
        
        ///gets the current cpu family integer
        public static var cpufamily: UInt32?{
            return getInteger("cpufamily")
        }
        
        ///gets the current cpu subfamily integer
        public static var cpusubfamily: UInt32?{
            return getInteger("cpusubfamily")
        }
        
        ///Gets if the current CPU is a 64 bit cpu
        public static var cpu64bit_capable: Bool?{
            return getBool("cpu64bit_capable")
        }
        
        ///Gets the current ammount of RAM inside the system
        public static var memsize: UInt?{
            return getInteger("memsize")
        }
        
        ///Gets the current model identifier for the system
        public static var model: UInt?{
            return getInteger("model")
        }
        
        #if (os(macOS) || targetEnvironment(macCatalyst)) && (arch(x86_64) || arch(i386))
        ///Gets the number of CPU packages inside the current system
        ///NOTE: This information is only available on intel Macs.
        public static var packages: UInt?{
            return getInteger("packages")
        }
        
        ///Gets the nominal cpu frequency in Hz
        ///NOTE: This information is only available on intel Macs.
        public static var cpufrequency: UInt64?{
            return getInteger("cpufrequency")
        }
        
        ///Gets the nominal cpu bus frequency in Hz
        ///NOTE: This information is only available on intel Macs.
        public static var busfrequency: UInt64?{
            return getInteger("busfrequency")
        }
        
        ///Gets the nominal max cpu frequency in Hz
        ///NOTE: This information is only available on intel Macs.
        public static var cpufrequency_max: UInt64?{
            return getInteger("cpufrequency_max")
        }
        
        ///Gets the nominal max cpu bus frequency in Hz
        ///NOTE: This information is only available on intel Macs.
        public static var busfrequency_max: UInt64?{
            return getInteger("busfrequency_max")
        }
        
        ///Gets the nominal min cpu frequency in Hz
        ///NOTE: This information is only available on intel Macs.
        public static var cpufrequency_min: UInt64?{
            return getInteger("cpufrequency_min")
        }
        
        ///Gets the nominal min cpu bus frequency in Hz
        ///NOTE: This information is only available on intel Macs.
        public static var busfrequency_min: UInt64?{
            return getInteger("busfrequency_min")
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
            public static let index: UInt8 = 0
        }
        
        ///Object to read `sysctl hw.preflevel1` entries
        public final class Perflevel1: SysctlPerflevel{
            public static let index: UInt8 = 1
        }
        
        ///Object to read `sysctl hw.preflevel[x]` entries
        public final class PerflevelGeneralPurpose: SysctlPerflevel{
            public static var index: UInt8 = 0
        }
    }
}

#endif
