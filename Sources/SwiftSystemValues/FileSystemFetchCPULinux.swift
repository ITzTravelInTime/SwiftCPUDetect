import Foundation

#if os(Linux)

public class FileSystemFetchCPU: FileSystemFetchInstance{
    
    public class SubfolderItemClass: FileSystemFetchInstance{
        private let baseFolder: String
        
        fileprivate var subfolderName: String{
            return ""
        }
        
        public var subfolder: String {
            baseFolder + self.subfolderName
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
        FileSystem.Sys.Devices.System.CPU.subfolder + "cpu\(cpuNumber)/"
    }
    
}

#endif
