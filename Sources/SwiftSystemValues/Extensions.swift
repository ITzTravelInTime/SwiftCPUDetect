/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

extension String {
    
    func replaceFirst(of pattern: String, with replacement: String) -> String {
        if let range = self.range(of: pattern){
            return self.replacingCharacters(in: range, with: replacement)
        }
        
        return self
    }
    
    func replaceAll(of pattern:String, with replacement:String, options: NSRegularExpression.Options = []) -> String{
        do{
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(0..<self.utf16.count)
            return regex.stringByReplacingMatches(in: self, options: [],
                                                  range: range, withTemplate: replacement)
        }catch{
            NSLog("replaceAll error: \(error)")
            return self
        }
    }
    
}

public extension FixedWidthInteger{
    func boolValue() -> Bool?{
        return (self != 0 && self != 1) ? nil : self == 1
    }
}

extension FileManager{
    func isCaseSensitive(atPath path: String) -> Bool {
#if os(Linux)
        return true //assumes true on linux
#else
        var sensitive = false
        let url = URL(fileURLWithPath: path)
        
        if let resourceValues = try? url.resourceValues(forKeys: [.volumeSupportsCaseSensitiveNamesKey]), let isCS = resourceValues.volumeSupportsCaseSensitiveNames{
            
            sensitive = isCS
            
        }
        return sensitive
#endif
    }
}


