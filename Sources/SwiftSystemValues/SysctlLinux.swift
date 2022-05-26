//
//  File.swift
//  
//
//  Created by ITzTravelInTime on 25/05/22.
//

import Foundation

#if os(Linux)

public typealias SysctlBaseProtocol = FileSystemFetch

public extension SysctlFetch{
    static var subfolder: String{
        return "/proc/sys/" + namePrefix.replacingOccurrences(of: ".", with: "/")
    }
}

#endif
