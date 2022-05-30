/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation
import SwiftSystemValues

//#if !os(Linux)

///This enum is used to make more conveniente the detection of the actual cpu architecture
public enum CpuArchitecture: String, Hashable, DetectProtocol  {
    case ppc     = "ppc"   //belive it or not but there are swift compilers for ppc out there, so a bunch of PPC targets are included, if one is missing feel free to add it using a pull request.
    case ppcG3   = "ppc750"
    case ppcG4   = "ppc7450"
    case ppcG5   = "ppc970"
    case ppc64   = "ppc64"
    case ppc64le = "ppc64le"
    case intel32 = "i386"   //fist gens of intel macs
    case intel64 = "x86_64" //most intel macs from 2008 on
    case arm     = "arm"
    case arm64   = "arm64"
    
    public typealias AppArchitectures = [Self]
    
    ///Gets the cpu architecture used by the current process
    public static func current() -> Self?{
        //stores the obtained value so useless re-detections are avoided since this value isn't supposed to change at execution time
        struct MEM{
            static var state: CpuArchitecture? = nil
        }
        
        
        if MEM.state == nil{
            
            var ret: CpuArchitecture?
            
            #if !os(Linux)
            
            guard let type = Sysctl.HW.cputype else {
                Printer.errorPrint("Can't get the cpu type value")
                return nil
            }
            
            Printer.print("Detected CPU type number: \(type)")
            
            guard let subtype = Sysctl.HW.cpusubtype else{
                Printer.errorPrint("Can't get the cpu subtype value")
                return nil
            }
            
            Printer.print("Detected CPU subtype number: \(subtype)")
            
            guard let family = Sysctl.HW.cpufamily else{
                Printer.errorPrint("ERROR: Can't get the cpu family value")
                return nil
            }
            
            Printer.print("Detected CPU family number: \(family)")
                  
            /*
             var size = size_t()
             
             var type = cpu_type_t()
             var subtype = cpu_subtype_t()
             var family = UInt32()
             
            size = MemoryLayout.size(ofValue: type)
            sysctlbyname("hw.cputype", &type, &size, nil, 0);
            
            Printer.print("Detected CPU type number: \(type)")

            size = MemoryLayout.size(ofValue: subtype)
            sysctlbyname("hw.cpusubtype", &subtype, &size, nil, 0);
            
            Printer.print("Detected CPU subtype number: \(subtype)")
            
            size = MemoryLayout.size(ofValue: family)
            sysctlbyname("hw.cpufamily", &family, &size, nil, 0);
            
            Printer.print("Detected CPU family number: \(family)")
            */
            
            if type & CPU_TYPE_X86_64 != 0{
                ret = .intel64;
            }else if type & CPU_TYPE_X86 != 0 || type & CPU_TYPE_I386 != 0{
                if subtype & CPU_SUBTYPE_X86_64_ALL != 0 || HWInfo.CPU.is64Bit(){
                    ret = .intel64;
                }else{
                    ret = .intel32
                }
            }else if type & CPU_TYPE_ARM64 != 0{
                ret = .arm64
            }else if type & CPU_TYPE_ARM != 0{
                if subtype & CPU_SUBTYPE_ARM64_ALL != 0{
                    ret = .arm64
                }else{
                    ret = .arm
                }
            }else if type & CPU_TYPE_POWERPC64 != 0{
                if subtype & CPU_SUBTYPE_POWERPC_970 != 0 || family & UInt32(CPUFAMILY_POWERPC_G5) != 0{
                    ret = .ppcG5
                }else if subtype & CPU_SUBTYPE_LITTLE_ENDIAN != 0 {
                    ret = .ppc64le
                }else{
                    ret = .ppc64
                }
            }else if type & CPU_TYPE_POWERPC != 0{
                if subtype & CPU_SUBTYPE_POWERPC_750 != 0 || family & UInt32(CPUFAMILY_POWERPC_G3) != 0 {
                    ret = .ppcG3
                }else if subtype & CPU_SUBTYPE_POWERPC_7450 != 0 || family & UInt32(CPUFAMILY_POWERPC_G4) != 0 || subtype & CPU_SUBTYPE_POWERPC_7400 != 0{
                    ret = .ppcG4
                }else if subtype & CPU_SUBTYPE_POWERPC_970 != 0 || family & UInt32(CPUFAMILY_POWERPC_G5) != 0{
                    ret = .ppcG5
                }else{
                    ret = .ppc
                }
            }
            
            #else
            ret = binaryCurrent()
            #endif
            
            
            Printer.print("Detected cpu architecture of the current process is: \(ret?.rawValue ?? "[Arch not detected]")")
            
            MEM.state = ret
        }
        
        return MEM.state
    }
    
    ///Gets the cpu architechure the current binary is using to run
    public static func binaryCurrent() -> Self{
        
        #if os(Linux)
            #if arch(x86_64h)
            return .intel64
            #endif

            #if arch(i686)
            return .intel32
            #endif
        
            #if arch(powerpc)
            return .ppc
            #endif
        #endif
        
        #if arch(x86_64)
        return .intel64
        #endif
        
        #if arch(i386)
        return .intel32
        #endif
        
        #if arch(arm64)
        return .arm64
        #endif
        
        #if arch(arm) || arch(arm64_32)
        return .arm
        #endif
        
        #if arch(powerpc64) && _endian(big)
        return .ppc64
        #endif
        
        #if arch(powerpc64le) && _endian(little)
        return .ppc64le
        #endif
        
    }
    
    ///Gets the cpu architecture used by the current device
    public static func machineCurrent() -> Self?{
        guard let arch = current() else { return nil }
        
        #if os(macOS)
        guard let mode = AppExecutionMode.current() else{
            Printer.errorPrint("Can't get execution mode for the app, defaulting to current architecture")
            return arch
        }
        
        if mode == .emulated{
            //Resetta 2 does not support 32 bit intel apps
            if arch == .intel64{
                Printer.print("The actual cpu architecture of the current machine is: \(arm64.rawValue)")
                return arm64
            }
            
            if arch.isPPC64(){
                Printer.print("The actual cpu architecture of the current machine is: \(intel64.rawValue)")
                return intel64
            }
            
            //May cause bad detections
            if arch.isPPC32(){
                Printer.print("The actual cpu architecture of the current machine is: \(intel32.rawValue)")
                return intel32
            }
        }
        #endif
        
        Printer.print("The actual cpu architecture of the current machine is: \(arch.rawValue)")
        return arch
        
    }
    
    ///Returns the cpu architectures supported by the current program/app
    @available(*, deprecated, renamed: "AppArchitecture.current()") public static func currentExecutableArchitectures() -> AppArchitectures?{
        return AppArchitectures.current()
    }
    
    ///Gets if the current istance is a powerPC cpu
    public func isPPC() -> Bool{
        return self.rawValue.starts(with: "ppc")
    }
    
    ///Gets if the current instance is  a powerPC 64 bits cpu
    public func isPPC64() -> Bool{
        return self == .ppc64 || self == .ppcG5 || self == .ppc64le
    }
    
    ///Gets if the current istance is a powerPC 32 bits cpu
    public func isPPC32() -> Bool{
        return isPPC() && !isPPC64()
    }
    
    ///Gets if the current istance is an Apple Silicon cpu
    public func isAppleSilicon() -> Bool{
        return self == .arm64
    }
    
    ///Gets if the current istance is an Arm cpu
    public func isArm() -> Bool{
        return self.rawValue.starts(with: "arm")
    }
    
    ///Gets if the current instance is an intel cpu
    public func isIntel() -> Bool{
        return self == .intel32 || self == .intel64
    }
    
    ///Gets if the current instance is a 64 bit cpu
    public func is64Bit() -> Bool{
        switch self {
        case .ppc64, .ppc64le, .intel64, .arm64:
            return true
        default:
            return false
        }
    }
    
    ///Gets the generic processor family for the current cpu
    public func genericProcessorType() -> Self{
        if self.isPPC(){
            return .ppc
        }
        
        if self.isIntel(){
            return .intel32
        }
        
        if self.isArm(){
            return .arm
        }
        
        return self
    }
}

extension CpuArchitecture.AppArchitectures: DetectProtocol{
    
    private struct MEM{
        static var status: [CpuArchitecture]! = nil
    }
    
    ///Returns the cpu architectures supported by the current program/app
    public static func current() -> Self?{
        //stores the obtained value so useless re-detections are avoided since this value isn't supposed to change at execution time
        
        if MEM.status == nil{
            #if !os(Linux)
            var supportedArchs = [NSBundleExecutableArchitectureX86_64: CpuArchitecture.intel64, NSBundleExecutableArchitectureI386: CpuArchitecture.intel32, NSBundleExecutableArchitecturePPC: CpuArchitecture.ppc, NSBundleExecutableArchitecturePPC64: CpuArchitecture.ppc64, 12: CpuArchitecture.arm]
            
            if #available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *) {
                supportedArchs[NSBundleExecutableArchitectureARM64] = CpuArchitecture.arm64
            }else{
                supportedArchs[16777228] = CpuArchitecture.arm64
            }
            
            let raw = Bundle.main.executableArchitectures ?? [NSNumber]()
            
            if raw.isEmpty{
                Printer.errorPrint("Support for the executable's arch feature is usable only on bundle types! \n    An empry list will be returned")
            }else{
                Printer.print("Listing cpu architectures supported by the current bundle/app: ")
            }
            
            MEM.status = []
            
            for arch in supportedArchs{
                if raw.contains(NSNumber(value: arch.key)){
                    MEM.status!.append(arch.value)
                    Printer.print("    \(arch.value.rawValue)")
                }
            }
            
            #else
            MEM.status = [.binaryCurrent()]
            #endif
        }
        
        return MEM.status
    }
}

//#endif
