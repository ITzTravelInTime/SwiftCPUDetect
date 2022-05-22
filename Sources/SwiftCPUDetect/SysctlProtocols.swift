/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

#if !os(Linux)
public protocol SysctlCPUInfo: SysctlFetch{}

public extension SysctlCPUInfo{
    ///The ammount of cores assinged
    static var physicalcpu: UInt?{
        return Self.getInteger("physicalcpu")
    }
    
    ///The max ammount of cores
    static var physicalcpu_max: UInt?{
        return Self.getInteger("physicalcpu_max")
    }
    
    ///The ammount of threads
    static var logicalcpu: UInt?{
        return Self.getInteger("logicalcpu")
    }
    
    ///The max ammount of threads
    static var logicalcpu_max: UInt?{
        return Self.getInteger("logicalcpu_max")
    }
    
    ///The ammount of L1 instruction
    static var l1icachesize: UInt?{
        return Self.getInteger("l1icachesize")
    }
    
    ///The ammount of L1 data cache
    static var l1dcachesize: UInt?{
        return Self.getInteger("l1dcachesize")
    }
    
    ///The ammount of L2 cache
    static var l2cachesize: UInt?{
        return Self.getInteger("l2cachesize")
    }
    
    #if arch(x86_64) || arch(i386)
    ///The ammount of L3 cache
    static var l3cachesize: UInt?{
        return Self.getInteger("l3cachesize")
    }
    #endif
}

public protocol SysctlPerflevel: SysctlCPUInfo {
    static var index: UInt8 {get}
}

public extension SysctlPerflevel{
    static var namePrefix: String{
        return Sysctl.HW.namePrefix + "perflevel" + String(Self.index) + "."
    }
    
    ///The ammount of cores per L2 cache assinged to this governor
    static var cpusperl2: UInt?{
        return Self.getInteger("cpusperl2")
    }
    
    #if arch(x86_64) || arch(i386)
    ///The ammount of cores per L2 cache assinged to this governor
    static var cpusperl3: UInt?{
        return Self.getInteger("cpusperl3")
    }
    #endif
}

#endif

public protocol SysctlKernel: SysctlFetch{}

public extension SysctlKernel{
    ///The os kernel version string
    static var version: String?{
        return Self.getString("version")
    }
    
    ///The current hostname or device name
    static var hostname: String?{
        return Self.getString("hostname")
    }
    
    ///The os kernel name
    static var ostype: String?{
        return Self.getString("ostype")
    }
    
    ///The os kernel version number
    static var osrelease: String?{
        return Self.getString("osrelease")
    }
    
    
}


