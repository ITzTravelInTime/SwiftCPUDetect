/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation
import SwiftSystemValues
import SwiftPackagesBase

#if os(macOS) || targetEnvironment(macCatalyst)
///This enum is used to determinate if the current process is running as emulated or native
public enum AppExecutionMode: Int32, Hashable, DetectProtocol{
    @available(*, deprecated) case unkown = -1
    case native = 0
    case emulated = 1
    
    ///Gets if the current process is running natively or emulated
    public static func current() -> Self?{
        //stores the obtained value so useless re-detections are avoided since this value isn't supposed to change at execution time
        struct MEM{
            static var state: AppExecutionMode? = nil
        }
        
        if MEM.state == nil {
            if let translated = Sysctl.Sysctl.proc_translated{
                MEM.state = translated ? .emulated : .native
            }else if let native = Sysctl.Sysctl.proc_native{
                MEM.state = native ? .native : .emulated
            }else if (errno == ENOENT){
                MEM.state = .native
            }else{
                Printer.errorPrint("Can't detect the app execution mode")
                MEM.state = nil//.unkown
            }
            
            Printer.print("Detected Execution mode is: \(MEM.state == .emulated ? "Emulated" : (MEM.state == .native ? "Native" : "Unkown"))")
        }
        
        return MEM.state
    }
}
#endif
