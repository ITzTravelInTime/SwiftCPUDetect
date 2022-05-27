
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
        let expectedValues: [String] = ["Darwin"]
        #else
        let expectedValues: [String] = ["Linux"]
        #endif
        
        print("[Test] Excpected values: \(expectedValues)")
        
        let fetched: [String?] = [Sysctl.Kernel.ostype]
        
        print("[Test] Fetched test values: \(fetched)")
        
        print("[Test] Starting tests")
        
        assert(fetched.count == expectedValues.count, "BAD TEST!!! Array lenght mismatch")
        
        for i in 0..<expectedValues.count{
            
            XCTAssertNotNil(fetched[i])
        
            XCTAssertEqual(fetched[i], expectedValues[i])
            
        }
        
        print("[Test] test done")
        
        let uname: String? = UnameReimplemented.uname(withCommandLineArgs: [.a])
        
        print("[Test] Uname -a: \(uname ?? "Can't fetch the uname value")")
        
        #if os(Linux)
        
        print("[Test] Fetched Linux cpu preset: \(SwiftSystemValues.FileSystem.Sys.Devices.System.CPU.present ?? "")")
        
        print("[Test] Fetched Linux cpu values: \(SwiftSystemValues.FileSystem.Sys.Devices.System.CPU.listFileEntriesWithValues("")!)")
        
        print("[Test] Fetched Linux cpu info: \(SwiftSystemValues.FileSystem.Proc.cpuinfoItems() ?? [[:]])")
        
        #endif
    }
}
#endif
