//
//  File.swift
//  
//
//  Created by Pietro Caruso on 15/07/21.
//

import Foundation

///Class used to get info about the current cpu inside the system
public final class HWInfo{
    
    ///Gets a `String` from the `sysctlbyname` command
    public static func sysctlString(_ valueName: String, bufferSize: size_t) -> String?{
        var ret = [CChar].init(repeating: 0, count: bufferSize)
        
        var size = bufferSize
        
        let res = sysctlbyname(valueName, &ret, &size, nil, 0)
        
        return res == 0 ? String(utf8String: ret) : nil
    }
    
    ///Gets a `UInt64` from the `sysctlbyname` command
    public static func sysctlUInt64(_ valueName: String) -> UInt64?{
        var ret = UInt64()
        
        var size = MemoryLayout.size(ofValue: ret)
        
        let res = sysctlbyname(valueName, &ret, &size, nil, 0)
        
        return res == 0 ? ret : nil
    }
    
    ///Gets a `String` from the sysctl hw
    public static func sysctlHwString(_ valueName: String, bufferSize: size_t) -> String?{
        return sysctlString("hw." + valueName, bufferSize: bufferSize)
    }
    
    ///Gets a `UInt64` from the sysctl hw
    public static func sysctlHwUInt64(_ valueName: String) -> UInt64?{
        return sysctlUInt64("hw." + valueName)
    }
    
    ///Class used to gather CPU Info
    public final class CPU{
        
        //String getting functions
        #if os(macOS)
        ///Gets a `String` from the sysctl machdep.cpu
        public static func sysctlMachdepCpuString(_ valueName: String, bufferSize: size_t) -> String?{
            return sysctlString("machdep.cpu." + valueName, bufferSize: bufferSize)
        }
        
        ///Gets a `UInt64` from the sysctl machdep.cpu
        public static func sysctlMachdepCpuUInt64(_ valueName: String) -> UInt64?{
            return sysctlUInt64("machdep.cpu." + valueName)
        }
        #endif
        
        //Info functions
        
        #if os(macOS)
        
        ///Gets the number of threads of the current CPU
        public static func threadsCount() -> UInt64?{
            return sysctlMachdepCpuUInt64("thread_count")
        }
        ///Gets the number of cores of the current CPU
        public static func coresCount() -> UInt64?{
            return sysctlMachdepCpuUInt64("core_count")
        }
        ///Gets the stepping of the current CPU
        public static func stepping() -> UInt64?{
            return sysctlMachdepCpuUInt64("stepping")
        }
        ///Gets the brand name for the current CPU
        public static func brandString() -> String?{
            return sysctlMachdepCpuString("brand_string", bufferSize: 256)
        }
        ///Gets a string containing all the features supported by the current CPU
        public static func features() -> String?{
            return sysctlMachdepCpuString("features", bufferSize: 512)
        }
        ///Gets an array of strings with the names of all the features supported by the current CPU
        public static func featuresList() -> [String]?{
            guard let features = features() else { return nil }
            var ret = [String]()
            
            for f in features.split(separator: " "){
                ret.append(String(f))
            }
            
            return ret
        }
        ///Gets the nuber of cores for each CPU package in the system
        public static func coresPerPackage() -> UInt64?{
            return sysctlMachdepCpuUInt64("cores_per_package")
        }
        ///Gets the number of CPU packages inside the current system
        public static func packagesCount() -> UInt64?{
            return sysctlHwUInt64("packages")
        }
        
        #else
        
        ///Gets the number of threads of the current CPU
        public static func threadsCount() -> UInt64?{
            return sysctlHwUInt64("logicalcpu")
        }
        ///Gets the number of cores of the current CPU
        public static func coresCount() -> UInt64?{
            return sysctlHwUInt64("physicalcpu")
        }
        
        #endif
        
        ///Gets if the current CPU is a 64 bit cpu
        public static func is64Bit() -> Bool{
            return sysctlHwUInt64("cpu64bit_capable") == 1
        }
        
    }
    
    ///Gets the current ammount of RAM inside the system
    public static func ramAmmount() -> UInt64?{
        return sysctlHwUInt64("memsize")
    }
    
}
