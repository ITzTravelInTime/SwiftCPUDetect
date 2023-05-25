/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022-2023 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

#if !os(Linux)

public extension Sysctl{
    
    ///Object to read `sysctl machdep` entries
    final class Machdep: SysctlFetch{
        public static let namePrefix: String = "machdep."
        
        #if os(macOS) || targetEnvironment(macCatalyst) || targetEnvironment(simulator)
        
        ///Object to read `sysctl machdep.cpu` entries
        ///NOTE: Some entries are available on intel only
        public final class CPU: SysctlFetch{
            public static let namePrefix: String = Machdep.namePrefix + "cpu."
            
            ///Gets the number of threads of the current CPU
            public static var threads_count: UInt?{
                return getInteger("thread_count")
            }
            
            ///Gets the number of cores of the current CPU
            public static var cores_count: UInt?{
                return getInteger("core_count")
            }
            
            ///Gets the brand name for the current CPU
            public static var brand_string: String?{
                return getString("brand_string")
            }
            
            ///Gets the number of cores for each CPU package in the system
            public static var cores_per_package: UInt?{
                return getInteger("cores_per_package")
            }
            
            ///Gets the number of cpu threads for each CPU package in the system
            public static var logical_per_package: UInt?{
                return getInteger("logical_per_package")
            }
            
            #if (arch(x86_64) || arch(i386))
            
            ///Gets a string containing the cpu family for the current CPU
            ///NOTE: This information is only available on intel Macs.
            public static var family: UInt?{
                return getInteger("family")
            }
            
            ///Gets a string containing the cpu model for the current CPU
            ///NOTE: This information is only available on intel Macs.
            public static var model: UInt?{
                return getInteger("model")
            }
            
            ///Gets a string containing the cpu stepping for the current CPU
            ///NOTE: This information is only available on intel Macs.
            public static var stepping: UInt?{
                return getInteger("stepping")
            }
            
            ///Gets a string containing the cpu stepping for the current CPU
            ///NOTE: This information is only available on intel Macs.
            public static var extfamily: UInt?{
                return getInteger("extfamily")
            }
            
            ///Gets a string containing the cpu stepping for the current CPU
            ///NOTE: This information is only available on intel Macs.
            public static var extmodel: UInt?{
                return getInteger("extmodel")
            }
            
            ///Gets a string containing all the features supported by the current CPU
            ///NOTE: This information is only available on intel Macs.
            public static var features: String?{
                //return sysctlMachdepCpuString("features", bufferSize: 512)
                return getString("features")
            }
            
            ///Gets a string containing all the extra leaf7 features supported by the current CPU
            ///NOTE: This information is only available on intel Macs.
            public static var leaf7_features: String?{
                //return sysctlMachdepCpuString("features", bufferSize: 512)
                return getString("leaf7_features")
            }
            
            ///Object to read `sysctl machdep.cpu.address_bits entries
            ///NOTE: It might be available only on intel macs
            public final class Address_bits: SysctlFetch{
                public static let namePrefix: String = Machdep.CPU.namePrefix + "address_bits."
            }
            
            #endif
        }
        
        #endif
        
    }
    
}

#endif
