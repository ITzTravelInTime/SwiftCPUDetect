
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
        print("[Test] Performing CPUID test and dumping values obtained from the current system (x86 systems only)")
        
        let random1 = UInt32.random(in: 0...UInt32.max)
        let random2 = UInt32.random(in: 0...UInt32.max)
        let random3 = UInt32.random(in: 0...UInt32.max)
        
        #if arch(x86_64) || arch(i386)
        let prevVal = CPUID.Registers.recoverFromCache, prevVal2 = CPUID.Registers.storeQueryInCache
        
        CPUID.Registers.recoverFromCache = true
        CPUID.Registers.storeQueryInCache = false
        #endif
        
        CPUID.Registers.queryCache.append(.init(eax: .max, ebx: random1, ecx: random2, edx: random3, queryLevel1: 1, queryLevel2: nil))
        
        //Sanity test
        XCTAssertEqual(CPUID.Registers.from(level: 1)?.eax, .max,    "EAX Value recovered from cache doesn't match")
        XCTAssertEqual(CPUID.Registers.from(level: 1)?.ebx, random1, "EBX Value recovered from cache doesn't match")
        XCTAssertEqual(CPUID.Registers.from(level: 1)?.ecx, random2, "ECX Value recovered from cache doesn't match")
        XCTAssertEqual(CPUID.Registers.from(level: 1)?.edx, random3, "EDX Value recovered from cache doesn't match")
        
        CPUID.Registers.queryCache.removeAll()
        CPUID.Registers.queryCache.append(.init(eax: 591593, ebx: 34605056, ecx: 2147154879, edx: 3219913727, queryLevel1: 1, queryLevel2: nil))
        
        CPUID.Registers.queryCache.append(.init(eax: 1702129225, ebx: 693250156, ecx: 1919894304, edx: 1297360997, queryLevel1: 2147483650, queryLevel2: nil))
        CPUID.Registers.queryCache.append(.init(eax: 929636393, ebx: 808924973, ecx: 542197808, edx: 542462019, queryLevel1: 2147483651, queryLevel2: nil))
        CPUID.Registers.queryCache.append(.init(eax: 775036992, ebx: 1212624952, ecx: 122, edx: 0, queryLevel1: 2147483652, queryLevel2: nil))
        
        //Value fetching functions tests
        XCTAssertEqual(CPUID.family(), 0x06, "CPU Family is wrong")
        XCTAssertEqual(CPUID.extFamily(), 0x00, "CPU Extended Family is wrong")
        
        XCTAssertEqual(CPUID.model(), 0x9E, "CPU Model is wrong")
        XCTAssertEqual(CPUID.extModel(), 0x09, "CPU Extended Model is wrong")
        
        XCTAssertEqual(CPUID.stepping(), 0x09, "CPU Stepping is wrong")
        
        XCTAssertEqual(CPUID.brandString(), "Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz", "Brand string doesn't match")
    
        CPUID.Registers.queryCache.removeAll()
        
        #if arch(x86_64) || arch(i386)
        CPUID.Registers.recoverFromCache = false
        
        let testQuery = CPUID.Registers.from(level: 1)
        
        //fetching from system tests
        XCTAssertNotNil(CPUID.Registers.from(level: 1), "Test query is nil")
        
        if testQuery != nil{
            print(testQuery!)
        }
        
        XCTAssertNotNil(CPUID.Registers.from(level: 1)?.eax, "EAX Value is nil")
        XCTAssertNotNil(CPUID.Registers.from(level: 1)?.ebx, "EBX Value is nil")
        XCTAssertNotNil(CPUID.Registers.from(level: 1)?.ecx, "ECX Value is nil")
        XCTAssertNotNil(CPUID.Registers.from(level: 1)?.edx, "EDX Value is nil")
        
        let brandStringQuery1 = CPUID.Registers.from(level: 0x80000002), brandStringQuery2 = CPUID.Registers.from(level: 0x80000003), brandStringQuery3 = CPUID.Registers.from(level: 0x80000004)
        
        if let query1 = brandStringQuery1, let query2 = brandStringQuery2, let query3 = brandStringQuery3{
            print(query1)
            print(query2)
            print(query3)
            
            print(CPUID.brandString() ?? "")
        }
        
        XCTAssertNotNil(brandStringQuery1, "Brand String Query 1 is nil")
        XCTAssertNotNil(brandStringQuery2, "Brand String Query 2 is nil")
        XCTAssertNotNil(brandStringQuery3, "Brand String Query 3 is nil")
        
        XCTAssertNotNil(CPUID.brandString(), "Brand String from system is nil")
        
        CPUID.Registers.recoverFromCache = prevVal
        CPUID.Registers.storeQueryInCache = prevVal2
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
