/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

///Object to read `sysctl` entries
public final class Sysctl: SysctlFetch{
    public static let namePrefix: String = ""
    
    #if os(macOS)
    ///Object to read `sysctl sysctl` entries
    public final class Sysctl: SysctlFetch{
        public static let namePrefix: String = "sysctl."
        
        ///Gets is the current process is running as a native process for the current hw
        public static var proc_native: Bool? {
            return Self.getBool("proc_native")
        }
        
        ///gets if the current process is running as translated via rosetta or similar
        public static var proc_translated: Bool? {
            return Self.getBool("proc_translated")
        }
    }
    #endif
    
    #if !os(Linux)
    
    ///Object to read `sysctl vfs` entries
    final class VFS: SysctlFetch{
        public static let namePrefix: String = "vfs."
    }
    
    #endif
    
    ///Object to read `sysctl user` entries
    final class User: SysctlFetch{
        public static let namePrefix: String = "user."
    }
    
    ///Object to read `sysctl vm` entries
    final class VM: SysctlFetch{
        public static let namePrefix: String = "vm."
    }
    
    ///Object to read `sysctl debug` entries
    final class Debug: SysctlFetch{
        public static let namePrefix: String = "debug."
    }
    
    ///Object to read `sysctl net` entries
    final class Net: SysctlFetch{
        public static let namePrefix: String = "net."
    }
    
}
