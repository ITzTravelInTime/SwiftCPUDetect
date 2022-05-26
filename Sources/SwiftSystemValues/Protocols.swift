/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

public protocol FetchProtocol{
    static func getString(_ valueName: String) -> String?
    static func getInteger<T: FixedWidthInteger>(_ valueName: String) -> T?
    static func getBool(_ valueName: String) -> Bool?
}

public protocol FetchProtocolBoolFromInt: FetchProtocol{}

public extension FetchProtocolBoolFromInt{
    
    ///Gets a `Bool` value
    static func getBool(_ valueName: String) -> Bool?{
        let res: Int? = Self.getInteger(valueName)
        return res?.boolValue()
    }
}

///Generic protocol to allow easy fetching of values out of `sysctlbyname`
public protocol SysctlFetch: SysctlBaseProtocol{
    static var namePrefix: String {get}
}

#if !os(Linux)
///Used to gether informations about the cpus preflevels
public protocol SysctlPerflevel: SysctlCPUInfo {
    static var index: UInt8 {get}
}
#endif
