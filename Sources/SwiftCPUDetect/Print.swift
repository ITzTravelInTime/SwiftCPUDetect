//
//  print.swift
//  
//
//  Created by Pietro Caruso on 04/07/21.
//

import Foundation

open class GeneralPrinter {
    public static var enabled: Bool = true
    open class var prefix: String{
        return ""
    }
    
    open class func print( _ str: String){
        if enabled{
            print("\(prefix) \(str)")
        }
    }
}

internal class Printer: GeneralPrinter{
    override class var prefix: String{
        return "[SwiftCPUDetect]"
    }
}
