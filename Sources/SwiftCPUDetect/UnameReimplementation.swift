/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

///Namespace reimplementing the uname feature in a Swift-friendly way
public final class UnameReimplemented{
        
    ///Structure containing the uname information
    public struct UTSNameReimplemented{
        let sysname: String
        let nodename: String
        let release: String
        let version: String
        let machine: String
        
        ///Fetches and returns the uname data, the data is cached to save time on re-fetching, since it remains constant trought the lifetime of a program while running
        public static func fromSysctl(_ forceNewFetch: Bool = false) -> Self?{
            struct Mem{
                static var content: UTSNameReimplemented? = nil
            }
            
            var ret: Self? = forceNewFetch ? nil : Mem.content
            
            if ret == nil{
                
                guard let sysname = Sysctl.Kern.ostype else{
                    Printer.print("Can't get the sysname data for uname")
                    return nil
                }
                
                guard let nodename = Sysctl.Kern.hostname else{
                    Printer.print("Can't get the nodename data for uname")
                    return nil
                }
                
                guard let release = Sysctl.Kern.osrelease else{
                    Printer.print("Can't get the release data for uname")
                    return nil
                }
                
                guard let version = Sysctl.Kern.version else{
                    Printer.print("Can't get the version data for uname")
                    return nil
                }
                
                guard let machine = Sysctl.HW.machine else{
                    Printer.print("Can't get the machine data for uname")
                    return nil
                }
                
                /*
                 guard let sysname = Sysctl.Kern.ostype, let nodename = Sysctl.Kern.hostname, let release = Sysctl.Kern.osrelease, let version = Sysctl.Kern.version, let machine = Sysctl.HW.machine else{
                     Printer.print("Can't get all the data for uname")
                     return nil
                 }
                 */
            
                Mem.content = Self.init(sysname: sysname, nodename: nodename, release: release, version: version, machine: machine)
                ret = Mem.content
                
                Printer.print("uname data is: \(ret!)") //should never be nil
            }
                
            return ret
        }
    }
    
    ///The code equivalent of all the command line args for the uname command
    public enum UnameCommandLineArgs: UInt8, Hashable{
        
        //All
        
        ///Returns all uname categories
        case a
        ///Returns all uname categories
        public static var All: Self { .a }
        
        //machine hardware name
        
        ///Returns the device model or the device architecture (for macs)
        case m
        ///Returns the device model or the device architecture (for macs)
        public static var machineHardwareName: Self { .m }
        
        //node name aka hostname
        
        ///Returns the device hostname
        case n
        ///Returns the device hostname
        public static var nodeName: Self { .n }
        
        //processor architecture
        
        ///Returns the generic processor type
        case p
        ///Returns the generic processor type
        public static var genericProcessorType: Self { .p }
        
        //os name, also the default arg
        
        ///Returns the os kernel name
        case s
        ///Returns the os kernel name
        public static var operatingSystemName: Self { .s }
        ///The default arg which returns the os kernel name
        public static var defaultArg: Self { .s }
        
        //os kernel version number
        
        ///Returns the os kernel release number
        case r
        ///Returns the os kernel release number
        public static var operatingSystemKernelReleaseNumber: Self { .r }
        
        //os kernel version string
        
        ///Returns the os kernel version string
        case v
        ///Returns the os kernel version string
        public static var operatingSystemKernelVersionString: Self { .v }
        
        ///Returns the equivalent args for the all arg
        public static var allEquivalent: [Self]{
            return [.s, .n, .r, .v, .m]
        }
    }
    
    ///Fetches information from the uname reimplementation and returns them as a `[UnameCommandLineArgs: String]` dictionary, the args names and roles matches the behavious of the `uname` command line tool on macOS
    ///- Returns: a `[UnameCommandLineArgs: String]` dictionary conaining uname info like the `uname` command line tool organised by the relative arg. If the values can't be fetched nil is returned.
    ///
    ///See the `UnameCommandLineArgs` to learn more about available args and their role.
    ///This function is designed to not produce replicates.
    ///
    ///NOTE: that the `p` argument is omitted when using the `a` arguments matching the behavior of the real command line tool.
    public static func uname(withCommandLineArgs args: [UnameCommandLineArgs] = [.defaultArg], forceNewFetch: Bool = false) -> [UnameCommandLineArgs: String]?{
        guard let info = Self.uname(forceNewFetch) else{
            return nil
        }
        
        var ret = [UnameCommandLineArgs: String]()
        
        for i in args.workingCopy{
            switch i {
            case .a:
                //return [.s: info.sysname, .n: info.nodename, .r: info.release, .v: info.version, .m: info.machine]
                continue
            case .m:
                ret[.m] = info.machine
            case .n:
                ret[.n] = info.nodename
            case .p:
                ret[.p] = (CpuArchitecture.current()?.genericProcessorType().rawValue ?? info.machine)
            case .s:
                ret[.s] = info.sysname
            case .r:
                ret[.r] = info.release
            case .v:
                ret[.v] = info.version
            }
        }
        
        Printer.print("Obtained uname dictionary: \(ret)")
        
        return ret
    }
    
    ///Fetches information from the uname reimplementation and returns them as a `String` the args names and roles matches the behavious of the `uname` command line tool on macOS
    ///- Returns: a `String` dictionary conaining uname info like the `uname` command line tool. If the values can't be fetched nil is returned.
    ///
    ///See the `UnameCommandLineArgs` to learn more about available args and their role.
    ///This function is designed to not produce replicates.
    ///
    ///NOTE: that the `p` argument is omitted when using the `a` arguments matching the behavior of the real command line tool.
    public static func uname(withCommandLineArgs args: [UnameCommandLineArgs] = [.defaultArg], forceNewFetch: Bool = false) -> String?{
        guard let res: [UnameCommandLineArgs: String] = uname(withCommandLineArgs: args, forceNewFetch: forceNewFetch) else{
            return nil
        }
        
        var ret = ""
        
        for val in args.workingCopy{
            guard let fetch = res[val] else { continue }
            
            ret += fetch + " "
        }
        
        if let last = ret.last, last == " "{
            ret.removeLast()
        }
        
        return ret
    }
    
    ///The uname implementation returning an `UTSNameReimplemented` struct
    public static func uname(_ forceNewFetch: Bool = false) -> UTSNameReimplemented?{
        return UTSNameReimplemented.fromSysctl(forceNewFetch)
    }
    
}

fileprivate extension Array where Element == UnameReimplemented.UnameCommandLineArgs{
    var workingCopy: Self{
        return self.contains(.a) ? UnameReimplemented.UnameCommandLineArgs.allEquivalent : self.removingDuplicates()
    }
}
