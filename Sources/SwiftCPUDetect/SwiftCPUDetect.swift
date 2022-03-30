/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

///This enum is used to make more conveniente the detection of the actual cpu architecture
public enum CpuArchitecture: String, Codable, Equatable, CaseIterable{
    case ppc     = "ppc"   //belive it or not but there are swift compilers for ppc out there, so a bunch of PPC targets are included, if one is missing feel free to add it using a pull request.
    case ppcG3   = "ppc750"
    case ppcG4   = "ppc7450"
    case ppc64   = "ppc64"
    case ppcG5   = "ppc970"
    case intel32 = "i386"   //fist gens of intel macs
    case intel64 = "x86_64" //most intel macs from 2008 on
    case arm     = "arm"
    case arm64   = "arm64"

    ///Gets the raw value for the current architecture
    public static func currentRaw() -> String? {
        
        var ret: String?
        
        /*#if os(macOS)
        
        //Only works well on  macOS, on other platforms just returns tha device model
        var sysinfo = utsname()
        let result = uname(&sysinfo)
        guard result == EXIT_SUCCESS else { return nil }
        let data = Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN))
        guard let identifier = String(bytes: data, encoding: .ascii) else { return nil }
        
        ret = CpuArchitecture(rawValue: identifier.trimmingCharacters(in: .controlCharacters).lowercased() )
        
        #else*/
        
        ret = current()?.rawValue
        
        //#endif
        
        Printer.print("Detected raw arch is: \(ret ?? "[No arch detected]")")
        
        return ret
    }
    
    ///Gets the cpu architecture used by the current process
    public static func current() -> CpuArchitecture?{
        //stores the obtained value so useless re-detections are avoided since this value isn't supposed to change at execution time
        struct MEM{
            static var state: CpuArchitecture? = nil
        }
        
        if MEM.state == nil{
            
            var ret: CpuArchitecture?
            
            guard let type: cpu_type_t = Sysctl.HW.getInteger("cputype") else {
                Printer.print("ERROR: Can't get the cpu type value")
                return nil
            }
            
            Printer.print("Detected CPU type number: \(type)")
            
            guard let subtype: cpu_subtype_t = Sysctl.HW.getInteger("cpusubtype") else{
                Printer.print("ERROR: Can't get the cpu subtype value")
                return nil
            }
            
            Printer.print("Detected CPU subtype number: \(subtype)")
            
            guard let family: UInt32 = Sysctl.HW.getInteger("cpufamily") else{
                Printer.print("ERROR: Can't get the cpu family value")
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
            
            if type == CPU_TYPE_X86{
                if subtype & CPU_SUBTYPE_X86_64_ALL != 0 || HWInfo.CPU.is64Bit(){
                    ret = .intel64;
                }else{
                    ret = .intel32
                }
            }else if type == CPU_TYPE_X86_64{
                ret = .intel64;
            }else if type == CPU_TYPE_ARM {
                if subtype & CPU_SUBTYPE_ARM64_ALL != 0{
                    ret = .arm64
                }else{
                    ret = .arm
                }
            }else if type == CPU_TYPE_ARM64{
                ret = .arm64
            }else if type == CPU_TYPE_POWERPC{
                if subtype & CPU_SUBTYPE_POWERPC_750 != 0 || family & UInt32(CPUFAMILY_POWERPC_G3) != 0 {
                    ret = .ppcG3
                }else if subtype & CPU_SUBTYPE_POWERPC_7450 != 0 || family & UInt32(CPUFAMILY_POWERPC_G4) != 0 {
                    ret = .ppcG4
                }else if subtype & CPU_SUBTYPE_POWERPC_970 != 0 || family & UInt32(CPUFAMILY_POWERPC_G5) != 0{
                    ret = .ppcG5
                }else{
                    ret = .ppc
                }
            }else if type == CPU_TYPE_POWERPC64{
                if subtype & CPU_SUBTYPE_POWERPC_970 != 0 || family & UInt32(CPUFAMILY_POWERPC_G5) != 0{
                    ret = .ppcG5
                }else{
                    ret = .ppc64
                }
            }
            
            
            Printer.print("Detected cpu architecture of the current process is: \(ret?.rawValue ?? "[Arch not detected]")")
            
            MEM.state = ret
        }
        
        return MEM.state
    }
    
    ///Gets the cpu architecture used by the current device
    public static func machineCurrent() -> CpuArchitecture?{
        guard let arch = current() else { return nil }
        let mode = AppExecutionMode.current()
        
        if mode == .emulated{
            //Resetta 2 does not support 32 bit intel apps
            if arch == .intel64{
                Printer.print("The actual cpu architecture of the current machine is: \(arm64.rawValue)")
                return arm64
            }
            
            if arch.isPPC32(){
                Printer.print("The actual cpu architecture of the current machine is: \(intel32.rawValue)")
                return intel32
            }
            
            if arch.isPPC64(){
                Printer.print("The actual cpu architecture of the current machine is: \(intel64.rawValue)")
                return intel64
            }
        }
        
        Printer.print("The actual cpu architecture of the current machine is: \(arch.rawValue)")
        return arch
        
    }
    
    ///Returns the cpu architectures supported by the current program/app
    public static func currentExecutableArchitectures() -> [CpuArchitecture]{
        //stores the obtained value so useless re-detections are avoided since this value isn't supposed to change at execution time
        struct MEM{
            static var status: [CpuArchitecture]!
        }
        
        if MEM.status == nil{
            var supportedArchs = [NSBundleExecutableArchitectureX86_64: intel64, NSBundleExecutableArchitectureI386: intel32, NSBundleExecutableArchitecturePPC: ppc, NSBundleExecutableArchitecturePPC64: ppc64, 12: arm]
            
            if #available(macOS 11.0, iOS 14.0, *, watchOS 7.0, tvOS 14.0) {
                supportedArchs[NSBundleExecutableArchitectureARM64] = arm64
            }else{
                supportedArchs[16777228] = arm64
            }
            
            let raw = Bundle.main.executableArchitectures ?? [NSNumber]()
            
            if raw.isEmpty{
                Printer.print("Support for the executable's arch feature is usable only on bundle types! \n    An empry list will be returned")
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
        }
        
        return MEM.status
    }
    
    ///Gets if the current istance is a powerPC cpu
    public func isPPC() -> Bool{
        return self.rawValue.starts(with: "ppc")
    }
    
    ///Gets if the current instance is  a powerPC 64 bits cpu
    public func isPPC64() -> Bool{
        return self == .ppc64 || self == .ppcG5
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
}
