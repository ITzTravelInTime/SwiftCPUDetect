
import Foundation
import SwiftPackagesBase

#if !os(Linux)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13, *) extension CpuArchitecture: Identifiable{}
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13, *) extension UnameReimplemented.UnameCommandLineArgs: Identifiable{}
#endif

#if os(macOS)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13, *) extension AppExecutionMode: Identifiable{}
#endif
