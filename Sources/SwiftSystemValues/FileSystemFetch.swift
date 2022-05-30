//
//  File.swift
//  
//
//  Created by ITzTravelInTime on 25/05/22.
//

import Foundation

///Used to fetch values from the file system
public protocol FileSystemFetchInstance: FetchProtocolBoolFromIntInstance{
    var subfolder: String { get }
}

public extension FileSystemFetchInstance{
    
    private func getPath(forItem item: String) -> String{
        return subfolder + item.replacingOccurrences(of: ".", with: "/")
    }
    
    ///Gets a `String` from `/proc`
    func getString(_ valueName: String) -> String?{
        
        let path = getPath(forItem: valueName)
        var contents = ""
        
        Printer.print("Fetching value for linux sysctl pseudofile path: \(path)")
        
        do{
            contents = try String(contentsOfFile: path)
        }catch let err{
            Printer.errorPrint("Value fetching failed \(err.localizedDescription)")
            return nil
        }
        
        if contents.last == "\n"{
            contents.removeLast()
        }
        
        Printer.print("Fetched value: \(contents)")
        
        return contents
    }
    
    ///Gets an Integer value from `/proc`
    func getInteger<T: FixedWidthInteger>(_ valueName: String) -> T?{
        guard let str = getString(valueName) else { return nil }
        return T(str)
    }
    
    
    ///Gets a list of file system entries for the speficied subfolder name
    func listEntries(_ tableName: String) -> [String: Bool]?{
        let path = getPath(forItem: tableName)
        
        Printer.print("Listing entries at path: \(path)")
        
        if !FileManager.default.fileExists(atPath: path){
            Printer.errorPrint("Specified entry path does not exist: \(path)")
            return nil
        }
        
        let isCaseSensitive = FileManager.default.isCaseSensitive(atPath: path)
        
        var ret = [String: Bool]()
        
        do{
            for i in try FileManager.default.contentsOfDirectory(atPath: path){
                
                var isDir: ObjCBool = .init(booleanLiteral: false)
                
                if FileManager.default.fileExists(atPath: path + i, isDirectory: &isDir){
                    ret[ isCaseSensitive ? i.lowercased() : i ] = isDir.boolValue
                }
            }
        }catch let err{
            Printer.errorPrint("Error while retriving the contents of path: \(err.localizedDescription)")
            return nil
        }
        
        Printer.print("Got directory contents: \(ret)")
        
        return ret
    }
    
    ///Gets a list of file system entries for the speficied subfolder name
    @inline(__always) fileprivate func listSpecificEntries(_ tableName: String, onlyFolders: Bool) -> [String]?{
        guard let entries = listEntries(tableName) else{
            return nil
        }
        
        var ret = [String]()
        
        for i in entries where i.value == onlyFolders{
            ret.append(i.key)
        }
        
        return ret
    }
    
    ///Gets a list of file system directory entries for the speficied subfolder name
    func listDirectoryEntries(_ tableName: String) -> [String]?{
        return listSpecificEntries(tableName, onlyFolders: true)
    }
    
    ///Gets a list of file system file entries for the speficied subfolder name
    func listFileEntries(_ tableName: String) -> [String]?{
        return listSpecificEntries(tableName, onlyFolders: false)
    }
    
    ///Gets a list of file system entries for the speficied subfolder name
    func listFileEntriesWithValues(_ tableName: String) -> [String: Any]?{
        guard let list = listFileEntries(tableName) else{
            return nil
        }
        
        var ret = [String: Any]()
        
        for i in list{
            guard let contents = getString(tableName + i)else{
                continue
            }
        
            if let number: Int = Int(contents){
                ret[i] = number
            }else{
                ret[i] = contents
            }
        }
        
        return ret
    }
}

///Used to fetch values from the file system
public protocol FileSystemFetch: FetchProtocolBoolFromInt{
    static var subfolder: String { get }
}

fileprivate struct BrigeFetcher: FileSystemFetchInstance{
    var subfolder: String
}

public extension FileSystemFetch{
    
    ///Gets a `String` from `/proc`
    static func getString(_ valueName: String) -> String?{
        return BrigeFetcher(subfolder: Self.subfolder).getString(valueName)
    }
    
    ///Gets an Integer value from `/proc`
    static func getInteger<T: FixedWidthInteger>(_ valueName: String) -> T?{
        return BrigeFetcher(subfolder: Self.subfolder).getInteger(valueName)
    }
    
    ///Gets a list of file system entries for the speficied subfolder name
    static func listEntries(_ tableName: String) -> [String: Bool]?{
        return BrigeFetcher(subfolder: Self.subfolder).listEntries(tableName)
    }
    
    ///Gets a list of file system directory entries for the speficied subfolder name
    static func listDirectoryEntries(_ tableName: String) -> [String]?{
        return BrigeFetcher(subfolder: Self.subfolder).listDirectoryEntries(tableName)
    }
    
    ///Gets a list of file system file entries for the speficied subfolder name
    static func listFileEntries(_ tableName: String) -> [String]?{
        return BrigeFetcher(subfolder: Self.subfolder).listFileEntries(tableName)
    }
    
    ///Gets a list of file system entries for the speficied subfolder name
    static func listFileEntriesWithValues(_ tableName: String) -> [String: Any]?{
        return BrigeFetcher(subfolder: Self.subfolder).listFileEntriesWithValues(tableName)
    }
    
}
