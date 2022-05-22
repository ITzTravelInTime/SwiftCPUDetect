/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

#if os(Linux)
import Glibc.sys.sysctl
#else
import Darwin.sys.sysctl
#endif

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

///Object to read `sysctl` entries
public final class Sysctl: SysctlFetch{
    public static let namePrefix: String = ""
}

