//
//  File.swift
//  
//
//  Created by Pietro Caruso on 30/07/22.
//

import Foundation
import SwiftPackagesBase

public extension CPUID{
    
    typealias FlagsIntegerFormat = UInt32
    
    static let flagsLastBit = UInt8(MemoryLayout<FlagsIntegerFormat>.size * 8 - 1)
    
    ///Executes a CPUID query and returns the vale of the EAX register
    static func queryAndReturnEAXBits(leaf: UInt32, extraLeaf: UInt32? = nil) -> FlagsIntegerFormat?{
        
        guard let reg = Registers.from(level: leaf, extendedLevel: extraLeaf) else{
            return nil
        }
        
        return reg.eax
    }
    
    ///Executes a CPUID query and returns the vale of the EAX register, bitmasked using the specified bits
    static func queryAndReturnEAXBits(leaf: UInt32, extraLeaf: UInt32? = nil, firstBit: UInt8 = 0, lastBit: UInt8 = flagsLastBit) -> FlagsIntegerFormat?{
        
        guard let reg = Registers.from(level: leaf, extendedLevel: extraLeaf) else{
            return nil
        }
        
        return (reg.eax & .generateBitMask(first: UInt32(firstBit), last: UInt32(lastBit))) >> firstBit
    }
    
    ///Returns the stepping value of the CPU
    static func stepping() -> FlagsIntegerFormat?{
        return queryAndReturnEAXBits(leaf: 1, firstBit: 0, lastBit: 3)
    }
    
    ///Returns the model value of the CPU
    static func model() -> FlagsIntegerFormat?{
        guard let model = queryAndReturnEAXBits(leaf: 1, firstBit: 4, lastBit: 7) else { return nil }
        guard let family = queryAndReturnEAXBits(leaf: 1, firstBit: 8, lastBit: 11) else { return nil }
        
        if family == 6 || family == 15{
            guard let extendedModel = extModel() else { return nil }
            
            return (extendedModel << 4) + model
        }else{
            return model
        }
    }
    
    ///Returns the family value of the CPU
    static func family() -> FlagsIntegerFormat?{
        guard let familyField = queryAndReturnEAXBits(leaf: 1, firstBit: 8, lastBit: 11) else { return nil }
        
        if familyField == 15{
            guard let extendedFamily = extFamily() else { return nil }
            
            return familyField + extendedFamily
        }
        
        return familyField
    }
    
    ///Returns the type value of the CPU
    static func type() -> FlagsIntegerFormat?{
        return queryAndReturnEAXBits(leaf: 1, firstBit: 12, lastBit: 13)
    }
    
    ///Returns the extended family value of the CPU
    static func extFamily() -> FlagsIntegerFormat?{
        return queryAndReturnEAXBits(leaf: 1, firstBit: 20, lastBit: 27)
    }
    
    ///Returns the extended model value of the CPU
    static func extModel() -> FlagsIntegerFormat?{
        return queryAndReturnEAXBits(leaf: 1, firstBit: 16, lastBit: 19)
    }
    
    ///Returns the CPU's brand srtring
    static func brandString() -> String?{
        var registers = [UInt32].init(repeating: 0, count: 12)
        
        guard let part1 = Registers.from(level: 0x80000002) else{
            return nil
        }
        
        registers[0] = part1.eax
        registers[1] = part1.ebx
        registers[2] = part1.ecx
        registers[3] = part1.edx
        
        guard let part2 = Registers.from(level: 0x80000003) else{
            return nil
        }
        
        registers[4] = part2.eax
        registers[5] = part2.ebx
        registers[6] = part2.ecx
        registers[7] = part2.edx
        
        guard let part3 = Registers.from(level: 0x80000004) else{
            return nil
        }
        
        registers[8] = part3.eax
        registers[9] = part3.ebx
        registers[10] = part3.ecx
        registers[11] = part3.edx
        
        var str = [CChar].init(repeating: 0, count: registers.count * MemoryLayout<UInt32>.size)
        
        for i in 0..<str.count{
            let regIndex = i / 4
            let shift = (i % 4) * 8
            
            str[i] = CChar((registers[regIndex] >> shift) & 0xff)
        }
        
        str[str.count - 1] = 0
        
        return String(cString: &str)
    }
    
        
}
