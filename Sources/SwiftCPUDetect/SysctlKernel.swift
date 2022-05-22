/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

public extension Sysctl{
    #if os(Linux)
    
    final class Kernel: SysctlKernel{
        public static let namePrefix: String = "kernel."
    }
    
    typealias Kern = Kernel
    
    #else
    
    ///Object to read `sysctl kern` entries
    final class Kern: SysctlKernel{
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
        
        #if os(macOS)
        ///the current version number for the macOS support for ios software
        public static var iossupportversion: String?{
            return Self.getString("iossupportversion")
        }
        
        #endif
        
        ///the current system boot args
        public static var bootargs: String?{
            return Self.getString("bootargs")
        }
    }
    
    typealias Kernel = Kern
    
    #endif
}
