//
//  File.swift
//  
//
//  Created by Pietro Caruso on 15/07/21.
//

import Foundation

///This enum is used to determinate if the current process is running as emulated or native
public enum AppExecutionMode: Int32, Codable, Equatable, CaseIterable{
    case unkown = -1
    case native = 0
    case emulated = 1
    
    ///Gets if the current process is running natively or emulated
    public static func current() -> AppExecutionMode{
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
