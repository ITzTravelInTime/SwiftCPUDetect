//
//  File.swift
//  
//
//  Created by Pietro Caruso on 25/05/22.
//

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
