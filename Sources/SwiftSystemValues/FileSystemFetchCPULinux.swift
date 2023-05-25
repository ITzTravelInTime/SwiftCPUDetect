/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022-2023 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

#if os(Linux)

public class FileSystemFetchCPU: FileSystemFetchInstance{
    
    public class SubfolderItemClass: FileSystemFetchInstance{
        private let baseFolder: String
        
        fileprivate var subfolderName: String{
            return ""
        }
        
        public var subfolder: String {
            return baseFolder + self.subfolderName
        }
        
        fileprivate init(baseFolder: String){
            self.baseFolder = baseFolder
        }
    }
    
    public class TopologyClass: SubfolderItemClass{
        override fileprivate var subfolderName: String{
            return "topology/"
        }
        
        public var core_cpus: UInt?{
            return self.getInteger("core_cpus")
        }
        
        public var core_cpus_list: UInt?{
            return self.getInteger("core_cpus_list")
        }
        
        public var core_id: UInt?{
            return self.getInteger("core_id")
        }
        
        public var core_siblings: UInt?{
            return self.getInteger("core_siblings")
        }
        
        public var core_siblings_list: UInt?{
            return self.getInteger("core_siblings_list")
        }
        
        public var die_cpus: UInt?{
            return self.getInteger("die_cpus")
        }
        
        public var die_cpus_list: UInt?{
            return self.getInteger("die_cpus_list")
        }
        
        public var die_id: UInt?{
            return self.getInteger("die_id")
        }
        
        public var package_cpus: UInt?{
            return self.getInteger("package_cpus")
        }
        
        public var package_cpus_list: UInt?{
            return self.getInteger("package_cpus_list")
        }
        
        public var physical_package_id: UInt?{
            return self.getInteger("physical_package_id")
        }
        
        public var thread_siblings: UInt?{
            return self.getInteger("thread_siblings")
        }
        
        public var thread_siblings_list: UInt?{
            return self.getInteger("thread_siblings_list")
        }
    }
    
    public let cpuNumber: UInt
    
    public private(set) var topology: TopologyClass
    
    public init(cpuNumber: UInt){
        self.cpuNumber = cpuNumber
        
        self.topology = .init(baseFolder: "")
        
        self.topology = .init(baseFolder: subfolder)
    }
    
    public var subfolder: String {
        return FileSystem.Sys.Devices.System.CPU.subfolder + "cpu\(cpuNumber)/"
    }
    
}

#endif
