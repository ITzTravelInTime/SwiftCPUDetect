
import Foundation

#if !os(Linux)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13, *) extension CpuArchitecture: Identifiable{
    public var id: RawValue{
        return rawValue
    }
}

#endif

#if !os(Linux)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13, *) extension UnameReimplemented.UnameCommandLineArgs: Identifiable{
    public var id: RawValue{
        return rawValue
    }
}
#endif

#if os(macOS)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13, *) extension AppExecutionMode: Identifiable{
    public var id: RawValue{
        return rawValue
    }
}
#endif
