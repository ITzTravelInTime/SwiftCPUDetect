//
//  File.swift
//  
//
//  Created by Pietro Caruso on 25/05/22.
//

import Foundation

#if !os(Linux)
public typealias SysctlBaseProtocol = FetchProtocolBoolFromInt

public extension SysctlFetch{
    
    ///Gets a `String` from the `sysctlbyname` function
    static func getString(_ valueName: String) -> String?{
        
        var size: size_t = 0
        
        let name = namePrefix + valueName
        
        var res = Darwin.sysctlbyname(name, nil, &size, nil, 0)
        
        if res != 0 {
            return nil
        }
        
        var ret = [CChar].init(repeating: 0, count: size + 1)
        
        res = Darwin.sysctlbyname(name, &ret, &size, nil, 0)
        
        return res == 0 ? String(cString: ret) : nil
    }
    
    ///Gets an Integer value from the `sysctlbyname` function
    static func getInteger<T: FixedWidthInteger>(_ valueName: String) -> T?{
        var ret = T()
        
        var size = MemoryLayout.size(ofValue: ret)
        
        let res = Darwin.sysctlbyname(namePrefix + valueName, &ret, &size, nil, 0)
        
        return res == 0 ? ret : nil
    }
    
}
#endif
