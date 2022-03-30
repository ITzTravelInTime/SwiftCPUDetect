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
    ///Gets a `String` and the fetch score from the `sysctlbyname` command
     static func getStringWithFetchScore(_ valueName: String, bufferSize: size_t) -> (value: String?, score: Int32){
        var ret = [CChar].init(repeating: 0, count: bufferSize)
        
        var size = bufferSize
        
        let res = sysctlbyname(namePrefix + valueName, &ret, &size, nil, 0)
        
        return (value: res == 0 ? String(utf8String: ret) : nil, score: res)
    }
    
    ///Gets an Integer value and the fetch score from the `sysctlbyname` command
    static func getIntegerWithFetchScore<T: FixedWidthInteger>(_ valueName: String) -> (value: T?, score: Int32){
        var ret = T()
        
        var size = MemoryLayout.size(ofValue: ret)
        
        let res = sysctlbyname(namePrefix + valueName, &ret, &size, nil, 0)
        
        return (value: res == 0 ? ret : nil, score: res)
    }
    
    ///Gets a `String` from the `sysctlbyname` command
     static func getString(_ valueName: String, bufferSize: size_t) -> String?{
         return getStringWithFetchScore(valueName, bufferSize: bufferSize).value
    }
    
    ///Gets an Integer value from the `sysctlbyname` command
    static func getInteger<T: FixedWidthInteger>(_ valueName: String) -> T?{
        let ret: T? = getIntegerWithFetchScore(valueName).value
        return ret
    }
    
}

public final class Sysctl: SysctlFetch{
    public static let namePrefix: String = ""
    
    public final class Sysctl: SysctlFetch{
        public static let namePrefix: String = "sysctl"
    }
    
    public final class HW: SysctlFetch{
        public static let namePrefix: String = "hw."
    }
    
    #if os(macOS)
    public final class Machdep: SysctlFetch{
        public static let namePrefix: String = "machdep."
        
        public final class CPU: SysctlFetch{
            public static let namePrefix: String = "machdep.cpu."
        }
    }
    #endif
    
}
