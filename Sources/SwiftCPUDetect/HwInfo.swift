/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

///Protocol used to make the implementation of the cpu info simpler
public protocol CPUInfo{
    associatedtype Reference: SysctlCPUInfo
}

public extension CPUInfo{
    ///Gets the number of threads
    static func threadsCount() -> UInt?{
        return Reference.logicalcpu
    }
    
    ///Gets the number of cores
    static func coresCount() -> UInt?{
        return Reference.physicalcpu
    }
    
    ///The ammount L1 Data cache
    static func l1DataCacheAmmount() -> UInt?{
        return Reference.l1dcachesize
    }
    
    ///The ammount L1 Instruction cache
    static func l1InstructionCacheAmmount() -> UInt?{
        return Reference.l1icachesize
    }
    
    ///The ammount L2 cache
    static func l2CacheAmmount() -> UInt?{
        return Reference.l2cachesize
    }
    
    ///The ammount L3 cache
    static func l3CacheAmmount() -> UInt?{
        return Reference.l3cachesize
    }
}

///Class used to get info about the current cpu inside the system
public final class HWInfo{
    
    ///Class used to gather CPU Info
    public final class CPU: CPUInfo{
        public typealias Reference = Sysctl.HW
        
        ///Returns informations about the performance cores
        public final class PerformanceCores: CPUInfo{
            public typealias Reference = Sysctl.HW.Perflevel0
        }
        
        ///Returns informations about the efficiency cores
        public final class EfficiencyCores: CPUInfo{
            public typealias Reference = Sysctl.HW.Perflevel1
        }
        
        //Info functions
        
        #if os(macOS)
        
        #if arch(x86_64) || arch(i386)
        ///Gets a string containing all the features supported by the current CPU
        ///NOTE: This information is only available on intel Macs.
        public static func features() -> String?{
            //return sysctlMachdepCpuString("features", bufferSize: 512)
            return Sysctl.Machdep.CPU.features
        }
        
        ///Gets an array of strings with the names of all the features supported by the current CPU
        ///NOTE: This information is only available on intel Macs.
        public static func featuresList() -> [String]?{
            guard let features = features() else { return nil }
            var ret = [String]()
            
            for f in features.split(separator: " "){
                ret.append(String(f))
            }
            
            return ret
        }
        
        ///Gets the number of CPU packages inside the current system
        ///NOTE: This information is only available on intel Macs.
        public static func packagesCount() -> UInt?{
            return Sysctl.HW.packages
        }
        
        ///Gets the nominal cpu frequency in Hz
        ///NOTE: This information is only available on intel Macs.
        public static func cpuFrequency() -> UInt64?{
            return Sysctl.HW.cpufrequency
        }
        
        ///Gets the nominal cpu bus frequency in Hz
        ///NOTE: This information is only available on intel Macs.
        public static func busFrequency() -> UInt64?{
            return Sysctl.HW.busfrequency
        }
        
        #endif
        
        ///Gets the number of cores for each CPU package in the system
        public static func coresPerPackage() -> UInt?{
            return Sysctl.Machdep.CPU.cores_per_package
        }
        
        ///Gets the number of cpu threads for each CPU package in the system
        public static func threadsPerPackage() -> UInt?{
            return Sysctl.Machdep.CPU.logical_per_package
        }
        
        ///Gets the brand name for the current CPU
        public static func brandString() -> String?{
            //return sysctlMachdepCpuString("brand_string", bufferSize: 256)
            return Sysctl.Machdep.CPU.brand_string
        }
        
        #endif
        
        ///Gets if the current CPU is a 64 bit cpu
        public static func is64Bit() -> Bool{
            var is64 = false
            
            if #available(macOS 10.8, macCatalyst 11, iOS 11, *){
                is64 = true
            }
            
            return Sysctl.HW.cpu64bit_capable ?? is64
        }
        
    }
    
    ///Gets the current ammount of RAM inside the system
    public static func ramAmmount() -> UInt?{
        return Sysctl.HW.memsize
    }
    
}
