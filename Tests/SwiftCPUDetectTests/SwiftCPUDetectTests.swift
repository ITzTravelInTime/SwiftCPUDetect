
import Foundation

#if !os(watchOS) || swift(>=5.4)
import XCTest
@testable import SwiftCPUDetect

final class SwiftLinuxSysctlTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        Printer.print("[Test] Testing backend")
        
        #if !os(Linux)
        let expectedValues: [String] = ["Darwin"]
        #else
        let expectedValues: [String] = ["Linux"]
        #endif
        
        Printer.print("[Test] Excpected values: \(expectedValues)")
        
        let fetched: [String?] = [Sysctl.Kernel.ostype]
        
        Printer.print("[Test] Fetched test values: \(fetched)")
        
        assert(fetched.count == expectedValues.count, "BAD TEST!!! Array lenght mismatch")
        
        for i in 0..<expectedValues.count{
            
            XCTAssertNotNil(fetched[i])
        
            XCTAssertEqual(fetched[i], expectedValues[i])
            
        }
    }
}
#endif
