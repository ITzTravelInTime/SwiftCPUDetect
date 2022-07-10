/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation
import SwiftSystemValues

#if !os(Linux)

///Protocol used to make the implementation of the cpu info simpler
public protocol CPUInfo{
    #if !os(Linux)
    associatedtype Reference: SysctlCPUInfo
    #endif
}

public extension CPUInfo{
    ///Gets the number of threads
    static func threadsCount() -> UInt?{
        #if !os(Linux)
        return Reference.logicalcpu
        #else
        #warning("implement me!")
        #endif
    }
    
    ///Gets the number of cores
    static func coresCount() -> UInt?{
        #if !os(Linux)
        return Reference.physicalcpu
        #else
        #warning("implement me!")
        #endif
    }
    
    #if !os(Linux) || arch(x86_64) || arch(i386)
    ///The ammount L1 Data cache
    static func l1DataCacheAmmount() -> UInt?{
        #if !os(Linux)
        return Reference.l1dcachesize
        #else
        #warning("implement me")
        #endif
    }
    
    ///The ammount L1 Instruction cache
    static func l1InstructionCacheAmmount() -> UInt?{
        #if !os(Linux)
        return Reference.l1icachesize
        #else
        #warning("implement me")
        #endif
    }
    
    ///The ammount L2 cache
    static func l2CacheAmmount() -> UInt?{
        #if !os(Linux)
        return Reference.l2cachesize
        #else
        #warning("implement me")
        #endif
    }
    #endif
    
    #if arch(x86_64) || arch(i386)
    ///The ammount L3 cache
    static func l3CacheAmmount() -> UInt?{
        #if !os(Linux)
        return Reference.l3cachesize
        #else
        #warning("implement me")
        #endif
    }
    #endif
}

///Class used to get info about the current cpu inside the system
public final class HWInfo{
    
    ///Class used to gather CPU Info
    public final class CPU: CPUInfo{
        #if !os(Linux)
        public typealias Reference = Sysctl.HW
        
        ///Returns informations about the performance cores
        public final class PerformanceCores: CPUInfo{
            public typealias Reference = Sysctl.HW.Perflevel0
        }
        
        ///Returns informations about the efficiency cores
        public final class EfficiencyCores: CPUInfo{
            public typealias Reference = Sysctl.HW.Perflevel1
        }
        #endif
        
        //Info functions
        
        #if os(macOS) || os(Linux)
        
        #if arch(x86_64) || arch(i386) //TODO: cpu features list is available for arm targets in linux
        ///Gets a string containing all the features supported by the current CPU
        ///NOTE: This information is only available on intel Macs.
        public static func features() -> String?{
            //return sysctlMachdepCpuString("features", bufferSize: 512)
            #if !os(Linux)
            return Sysctl.Machdep.CPU.features
            #else
            #warning("implement me")
            #endif
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
            #if !os(Linux)
            return Sysctl.HW.packages
            #else
            #warning("implement me")
            #endif
        }
        
        ///Gets the nominal cpu frequency in Hz
        ///NOTE: This information is only available on intel Macs.
        public static func cpuFrequency() -> UInt64?{
            #if !os(Linux)
            return Sysctl.HW.cpufrequency
            #else
            #warning("implement me")
            #endif
        }
        
        ///Gets the nominal cpu bus frequency in Hz
        ///NOTE: This information is only available on intel Macs.
        public static func busFrequency() -> UInt64?{
            #if !os(Linux)
            return Sysctl.HW.busfrequency
            #else
            #warning("implement me")
            #endif
        }
        
        #endif
        
        ///Gets the number of cores for each CPU package in the system
        public static func coresPerPackage() -> UInt?{
            #if !os(Linux)
            return Sysctl.Machdep.CPU.cores_per_package
            #else
            #warning("implement me")
            #endif
        }
        
        ///Gets the number of cpu threads for each CPU package in the system
        public static func threadsPerPackage() -> UInt?{
            #if !os(Linux)
            return Sysctl.Machdep.CPU.logical_per_package
            #else
            #warning("implement me")
            #endif
        }
        
        ///Gets the brand name for the current CPU
        public static func brandString() -> String?{
            #if !os(Linux)
            //return sysctlMachdepCpuString("brand_string", bufferSize: 256)
            return Sysctl.Machdep.CPU.brand_string
            #else
            #warning("implement me")
            #endif
            
        }
        
        #endif
        
        ///Gets if the current CPU is a 64 bit cpu
        public static func is64Bit() -> Bool{
            #if !os(Linux)
            return Sysctl.HW.cpu64bit_capable ?? CpuArchitecture.machineCurrent()?.is64Bit() ?? CpuArchitecture.binaryCurrent().is64Bit()
            #else
            #warning("implement me")
            #endif
        }
        
    }
    
    ///Gets the current ammount of RAM inside the system
    public static func ramAmmount() -> UInt?{
        #if !os(Linux)
        return Sysctl.HW.memsize
        #else
        #warning("implement me")
        #endif
    }
    
}

#endif
