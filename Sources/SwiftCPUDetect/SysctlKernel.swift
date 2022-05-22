//
//  File.swift
//  
//
//  Created by Pietro Caruso on 22/05/22.
//

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
