/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022-2023 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation
import SwiftPackagesBase

#if !os(Linux)
public typealias SysctlBaseProtocol = FetchProtocolBoolFromInt

public final class SysctlQueryStorage{
    public static var enabled = true
    public static var recoverEveryQueryFromStorage = false
    public static var records: [String: String] = [:]
}

public extension SysctlFetch{
    
    ///Gets a `String` from the `sysctlbyname` function
    static func getString(_ valueName: String) -> String?{
        
        let name = namePrefix + valueName
        
        if SysctlQueryStorage.recoverEveryQueryFromStorage && SysctlQueryStorage.enabled{
            if let record = SysctlQueryStorage.records[name]{
                return record
            }
        }
        
        var size: size_t = 0
        
        var res = Darwin.sysctlbyname(name, nil, &size, nil, 0)
        
        if res != 0 {
            return nil
        }
        
        var ret = [CChar].init(repeating: 0, count: size + 1)
        
        res = Darwin.sysctlbyname(name, &ret, &size, nil, 0)
        
        let returnVal = res == 0 ? String(cString: ret) : nil
        
        if SysctlQueryStorage.enabled{
            SysctlQueryStorage.records[name] = returnVal
        }
        
        return returnVal
    }
    
    ///Gets an Integer value from the `sysctlbyname` function
    static func getInteger<T: FixedWidthInteger>(_ valueName: String) -> T?{
        
        let name = namePrefix + valueName
        
        if SysctlQueryStorage.recoverEveryQueryFromStorage && SysctlQueryStorage.enabled{
            if let record = SysctlQueryStorage.records[name], let converted = T(record){
                return converted
            }
        }
        
        var ret = T()
        
        var size = MemoryLayout.size(ofValue: ret)
        
        let res = Darwin.sysctlbyname(name, &ret, &size, nil, 0)
        
        let returnVal = res == 0 ? ret : nil
        
        if SysctlQueryStorage.enabled, let returnV = returnVal{
            SysctlQueryStorage.records[name] = "\(returnV)"
        }
        
        return returnVal
    }
    
}
#endif
