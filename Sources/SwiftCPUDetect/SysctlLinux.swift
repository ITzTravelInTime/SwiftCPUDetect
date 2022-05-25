/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

#if os(Linux)

public extension SysctlFetch{
    
    fileprivate static var pathPrefix: String { "/proc/sys/" }
    
    ///Gets a `String` from the `sysctlbyname` function
    static func getString(_ valueName: String) -> String?{
        
        let path = (pathPrefix + (namePrefix + valueName).replacingOccurrences(of: ".", with: "/"))
        var contents = ""
        
        Printer.print("Fetching value for linux sysctl pseudofile path: \(path)")
        Printer.print("Fetching value ...")
        
        do{
            contents = try String(contentsOfFile: path)
        }catch let err{
            Printer.print("Value fetching failed \(err.localizedDescription)")
            return nil
        }
        
        if contents.last == "\n"{
            contents.removeLast()
        }
        
        Printer.print("Fetched value: \(contents)")
        
        return contents
    }
    
    ///Gets an Integer value from the `sysctlbyname` function
    static func getInteger<T: FixedWidthInteger>(_ valueName: String) -> T?{
        guard let str = getString(valueName) else { return nil }
        return T(str)
    }
    
}
#endif
