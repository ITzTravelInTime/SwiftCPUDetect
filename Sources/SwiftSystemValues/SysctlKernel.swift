/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

public extension Sysctl{
    
    ///Object to read `sysctl kern` entries
    final class Kern: SysctlFetch{
        #if os(Linux)
        public static let namePrefix: String = "kernel."
        #else
        public static let namePrefix: String = "kern."
        
        ///The os kernel build number
        public static var osrevision: String?{
            return Self.getString("osrevision")
        }
        
        ///The os legacy version number
        public static var osproductversioncompat: String?{
            return Self.getString("osproductversioncompat")
        }
        
        ///The os version number
        public static var osproductversion: String?{
            return Self.getString("osproductversion")
        }
        
        ///The os release type
        public static var osreleasetype: String?{
            return Self.getString("osreleasetype")
        }
        
        #if os(macOS) || targetEnvironment(macCatalyst)
        ///the current version number for the macOS support for ios software
        public static var iossupportversion: String?{
            return Self.getString("iossupportversion")
        }
        
        #endif
        
        ///the current system boot args
        public static var bootargs: String?{
            return Self.getString("bootargs")
        }
        
        #endif
        
        ///The os kernel version string
        public static var version: String?{
            return Self.getString("version")
        }
        
        ///The current hostname or device name
        public static var hostname: String?{
            return Self.getString("hostname")
        }
        
        ///The os kernel name
        public static var ostype: String?{
            return Self.getString("ostype")
        }
        
        ///The os kernel version number
        public static var osrelease: String?{
            return Self.getString("osrelease")
        }
    }
    
    typealias Kernel = Kern
}
