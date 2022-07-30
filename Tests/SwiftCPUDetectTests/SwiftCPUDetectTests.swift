
import Foundation

#if !os(watchOS) || swift(>=5.4) || canImport(XCTest)
import XCTest
@testable import SwiftCPUDetect
@testable import SwiftSystemValues

final class SwiftLinuxSysctlTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        print("[Test] Testing backend")
        
        #if !os(Linux)
        let expectedValues: [String] = ["Darwin", "Darwin"]
        #else
        let expectedValues: [String] = ["Linux", "Linux"]
        #endif
        
        print("[Test] Excpected values: \(expectedValues)")
        
        let fetched: [String?] = [Sysctl.Kernel.ostype, UnameReimplemented.uname(withCommandLineArgs: [.s])]
        
        print("[Test] Fetched test values: \(fetched)")
        
        print("[Test] Starting tests")
        
        assert(fetched.count == expectedValues.count, "BAD TEST!!! Array lenght mismatch")
        
        for i in 0..<expectedValues.count{
            
            XCTAssertNotNil(fetched[i])
        
            XCTAssertEqual(fetched[i], expectedValues[i])
            
        }
        
        print("[Test] test done")
        
        let uname: String? = UnameReimplemented.uname(withCommandLineArgs: [.a])
        
        XCTAssertNotNil(uname)
        
        print("[Test] Uname -a: \(uname ?? "Can't fetch the uname value")")
    }
    
    func testCPUID() throws{
        print("[Test] Performing CPUID test")
        
        let random1 = UInt32.random(in: 0...UInt32.max)
        let random2 = UInt32.random(in: 0...UInt32.max)
        let random3 = UInt32.random(in: 0...UInt32.max)
        
        #if arch(x86_64) || arch(i386)
        CPUID.Registers.recoverFromCache = true
        CPUID.Registers.storeQueryInCache = false
        #endif
        
        CPUID.Registers.queryCache.append(.init(eax: .max, ebx: random1, ecx: random2, edx: random3, queryLevel1: 1, queryLevel2: nil))
        
        XCTAssertEqual(CPUID.Registers.from(level: 1)?.eax, .max,    "EAX Value recovered from cache doesn't match")
        XCTAssertEqual(CPUID.Registers.from(level: 1)?.ebx, random1, "EBX Value recovered from cache doesn't match")
        XCTAssertEqual(CPUID.Registers.from(level: 1)?.ecx, random2, "ECX Value recovered from cache doesn't match")
        XCTAssertEqual(CPUID.Registers.from(level: 1)?.edx, random3, "EDX Value recovered from cache doesn't match")
        
        #if arch(x86_64) || arch(i386)
        CPUID.Registers.recoverFromCache = false
        
        let testQuery = CPUID.Registers.from(level: 1)
        
        XCTAssertNotNil(CPUID.Registers.from(level: 1), "Test query is nil")
        
        if testQuery != nil{
            print(testQuery!)
        }
        
        XCTAssertNotNil(CPUID.Registers.from(level: 1)?.eax, "EAX Value is nil")
        XCTAssertNotNil(CPUID.Registers.from(level: 1)?.ebx, "EBX Value is nil")
        XCTAssertNotNil(CPUID.Registers.from(level: 1)?.ecx, "ECX Value is nil")
        XCTAssertNotNil(CPUID.Registers.from(level: 1)?.edx, "EDX Value is nil")
        #endif
        
        print("[Test] Performing CPUID end")
    }
    
    #if os(Linux)
    func testLinux() throws{
        
        let cpus_present = SwiftSystemValues.FileSystem.Sys.Devices.System.CPU.present
        
        XCTAssertNotNil(cpus_present)
        
        print("[Test] Fetched Linux cpu preset: \(cpus_present ?? "")")

        let cpus_values = SwiftSystemValues.FileSystem.Sys.Devices.System.CPU.listFileEntriesWithValues("")
        
        XCTAssertNotNil(cpus_values)
        
        print("[Test] Fetched Linux cpu values: \(cpus_values ?? [:])")
        
        let cpuinfo_items = SwiftSystemValues.FileSystem.Proc.cpuinfoItems()
        
        XCTAssertNotNil(cpuinfo_items)

        print("[Test] Fetched Linux cpu info: \(cpuinfo_items ?? [[:]])")
    }
    #endif
    
}
#endif
