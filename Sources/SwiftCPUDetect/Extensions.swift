
import Foundation

extension Array where Element: Equatable{
    func removingDuplicates() -> Self{
        var ret = [Element]()
        
        for i in self{
            if !ret.contains(i){
                ret.append(i)
            }
        }
        
        return ret
    }
    
    mutating func removeDuplicates(){
        self = self.removingDuplicates()
    }
}

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
