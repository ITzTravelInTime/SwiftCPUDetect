/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022-2023 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

#if os(Linux)

public final class FileSystem: FileSystemFetch{
    public static let subfolder: String = "/"
    
    public final class Proc: FileSystemFetch{
        public static let subfolder: String = "/proc/"
        
        public typealias Sys = Sysctl
        
        public static var version: String?{
            return getString("version")
        }
        
        public static var cpuinfo: String?{
            return getString("cpuinfo")
        }
        
        public static func cpuinfoItems() -> [[String: Any]]?{
            guard let info = cpuinfo?.split(separator: "\n", omittingEmptySubsequences: false) else{
                Printer.errorPrint("Can't get the cpuinfo data!!")
                return nil
            }
            
            Printer.print("Fetched cpuinfo data array: \(info)")
            
            var ret = [[String: Any]]()
            var toBeAdded = [String: Any]()
            
            for i in info{
                
                Printer.print("Examinating line: \(i)")
                
                if i.isEmpty || i == "\n"{
                    ret.append(toBeAdded)
                    toBeAdded = [String:Any]()
                    continue
                }
                
                let split = i.split(separator: ":")
                
                Printer.print("Examinating line split: \(split)")
                
                let key = "\(split.first!)".replaceFirst(of: " ", with: "_").replacingOccurrences(of: "\t", with: "")
                
                Printer.print("Obtained key: \(key)")
                
                var value = split.count == 2 ? "\(split.last!)".replacingOccurrences(of: "\t", with: "") : ""
                
                if let first = value.first, first == " "{
                    value.removeFirst()
                }
                
                if value.hasSuffix(" KB"){
                    value.removeLast(3)
                }
                
                Printer.print("Obtained value: \(value)")
                
                var val: Any = value
                
                if let intVal = Int(value){
                    val = intVal
                }else if let dVal = Double(value){
                    val = dVal
                }else if value == "yes" || value == "no"{
                    val = value == "yes"
                }
                
                toBeAdded[key] = val
            }
            
            if !toBeAdded.isEmpty{
                ret.append(toBeAdded)
            }
            
            return ret
        }
    }
    
    public final class Sys: FileSystemFetch{
        public static let subfolder: String = "/sys/"
        
        public final class Devices: FileSystemFetch{
            public static let subfolder: String = Sys.subfolder + "devices/"
            
            public final class System: FileSystemFetch{
                public static let subfolder: String = Devices.subfolder + "system/"
                
                public final class CPU: FileSystemFetch{
                    public static let subfolder: String = System.subfolder + "cpu/"
                    
                    //TODO: Implement fetching of cpus
                    
                    public static var online: String?{
                        return getString("online")
                    }
                    
                    public static var offonline: String?{
                        return getString("offonline")
                    }
                    
                    public static var possible: String?{
                        return getString("possibile")
                    }
                    
                    public static var present: String?{
                        return getString("present")
                    }
                    
                    public static var modalias: String?{
                        return getString("modalias")
                    }
                    
                    public final class Caps: FileSystemFetch{
                        public static let subfolder: String = CPU.subfolder + "caps/"
                        
                        public static var pmu_name: String?{
                            return getString("pmu_name")
                        }
                        
                    }
                    
                }
                
                public final class Memory: FileSystemFetch{
                    public static let subfolder: String = System.subfolder + "memory/"
                }
                
            }
        }
    }
    
    
}

#endif
