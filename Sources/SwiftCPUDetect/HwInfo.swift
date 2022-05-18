/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

///Class used to get info about the current cpu inside the system
public final class HWInfo{
    
    ///Class used to gather CPU Info
    public final class CPU{
        
        //Info functions
        
        #if os(macOS)
        
        ///Gets the number of threads of the current CPU
        public static func threadsCount() -> UInt?{
            let ret: UInt? = Sysctl.Machdep.CPU.threads_count
            return ret
        }
        
        ///Gets the number of cores of the current CPU
        public static func coresCount() -> UInt?{
            //return sysctlMachdepCpuUInt64("core_count")
            let ret: UInt? = Sysctl.Machdep.CPU.cores_count
            return ret
        }
        
        ///Gets the brand name for the current CPU
        public static func brandString() -> String?{
            //return sysctlMachdepCpuString("brand_string", bufferSize: 256)
            return Sysctl.Machdep.CPU.brand_string
        }
        
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
        
        ///Gets the number of cores for each CPU package in the system
        public static func coresPerPackage() -> UInt?{
            return Sysctl.Machdep.CPU.cores_per_package
        }
        
        ///Gets the number of cpu threads for each CPU package in the system
        public static func threadsPerPackage() -> UInt?{
            return Sysctl.Machdep.CPU.logical_per_package
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
        
        #else
        
        ///Gets the number of threads of the current CPU
        public static func threadsCount() -> UInt64?{
            return Sysctl.HW.logicalcpu
        }
        
        ///Gets the number of cores of the current CPU
        public static func coresCount() -> UInt?{
            return Sysctl.HW.physicalcpu
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
