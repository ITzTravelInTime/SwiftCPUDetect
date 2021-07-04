//
//  SwiftCPUDetect.swift
//  TINU
//
//  Created by Pietro Caruso on 21/05/21.
//  Copyright © 2021 Pietro Caruso. All rights reserved.
//

import Foundation

///This enum is used to determinate if the current process is running as emulated or native
public enum AppExecutionMode: Int32, Codable, Equatable, CaseIterable{
    case unkown = -1
    case native = 0
    case emulated = 1
    
    ///Gets if the current process is running natively or emulated
    static func current() -> AppExecutionMode{
        //stores the obtained value so useless re-detections are avoided since this value isn't supposed to change at execution time
        struct MEM{
            static var state: AppExecutionMode? = nil
        }
        
        if MEM.state == nil {
            var ret: Int32 = 0
            var size = ret.bitWidth / 8
            
            let result = sysctlbyname("sysctl.proc_translated", &ret, &size, nil, 0)
            
            if result == -1 {
                if (errno == ENOENT){
                    MEM.state = AppExecutionMode.native
                }else{
                    MEM.state = AppExecutionMode.unkown
                }
            }else{
                MEM.state = AppExecutionMode(rawValue: ret) ?? .unkown
            }
            
            Printer.print("Detected Execution mode is: \(MEM.state == .emulated ? "Emulated" : (MEM.state == .native ? "Native" : "Unkown"))")
        }
        
        return MEM.state!
    }
}

///This enum is used to make more conveniente the detection of the actual cpu architecture
public enum CpuArchitecture: String, Codable, Equatable, CaseIterable{
    case ppc     = "ppc"   //belive it or not but there are swift compilers for ppc out there, so a bunch of PPC targets are included, if one is missing feel free to add it using a pull request.
    case ppcG1   = "ppc601"
    case ppcG2   = "ppc604"
    case ppcG3   = "ppc750"
    case ppcG4   = "ppc7400"
    case ppcG5   = "ppc970"
    case ppc64   = "ppc64"
    case intel32 = "i386"   //fist gens of intel macs
    case intel64 = "x86_64" //most intel macs from 2008 on
    case arm     = "arm"
    case arm64   = "arm64"
    case arm64e  = "arm64e" //apple silicon
    
    //TODO: Add a function to get the current cpu's marketing name and model.
    
    public static func currentRaw() -> String? {
        var sysinfo = utsname()
        let result = uname(&sysinfo)
        guard result == EXIT_SUCCESS else { return nil }
        let data = Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN))
        guard let identifier = String(bytes: data, encoding: .ascii) else { return nil }
        let ret = identifier.trimmingCharacters(in: .controlCharacters)
        
        Printer.print("Detected raw arch is: \(ret)")
        
        return ret
    }
    
    ///Gets the current architecture used by the current process
    public static func current() -> CpuArchitecture?{
        //stores the obtained value so useless re-detections are avoided since this value isn't supposed to change at execution time
        struct MEM{
            static var state: CpuArchitecture? = nil
        }
        
        if MEM.state == nil{
            guard let arch = currentRaw() else { return nil }
            
            Printer.print("Detected cpu architecture of the current process is: \(arch)")
            
            MEM.state = CpuArchitecture(rawValue: arch)
        }
        
        return MEM.state
    }
    
    ///Gets the architecture of the current machine
    public static func actualCurrent() -> CpuArchitecture?{
        guard let arch = current() else { return nil }
        let mode = AppExecutionMode.current()
        
        //Resetta 2 does not support 32 bit intel apps
        if arch == .intel64 && mode == .emulated{
            Printer.print("The actual cpu architecture of the current machine is: \(arm64.rawValue)")
            return arm64
        }
        
        if arch.isPPC32() && mode == .emulated{
            Printer.print("The actual cpu architecture of the current machine is: \(intel32.rawValue)")
            return intel32
        }
        
        if arch.isPPC64() && mode == .emulated{
            Printer.print("The actual cpu architecture of the current machine is: \(intel64.rawValue)")
            return intel64
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
            var supportedArchs = [NSBundleExecutableArchitectureX86_64: intel64, NSBundleExecutableArchitectureI386: intel32, NSBundleExecutableArchitecturePPC: ppc, NSBundleExecutableArchitecturePPC64: ppc64]
            
            if #available(OSX 11.0, *) {
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
        return self == .arm64e || self == .arm64
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