
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
