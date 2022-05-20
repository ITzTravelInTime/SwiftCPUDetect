# SwiftCPUDetect
Swift Library to detect the current CPU Architecture and if the current process is running under Rosetta.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FITzTravelInTime%2FSwiftCPUDetect%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/ITzTravelInTime/SwiftCPUDetect)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FITzTravelInTime%2FSwiftCPUDetect%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/ITzTravelInTime/SwiftCPUDetect)

## Features

- Get if the current process is running using Rosetta (aka as emulated) using the `AppExecutionMode` enum
- Get the Cpu architecture used by the current process, the computer or the ones supported by the current executable by using the `CpuArchitecture`  enum
- Get CPU and system info using the `HWInfo` class
- Get information from the sysctl api easily with the `Sysctl` namespace class (From version 2.0 onwards)
- Swift-friendly re-implementation of uname, called `UnameReimplemented.uname` provviding also an API-equivalent for the uname command line program (From version 2.0 onwards)

## Usage

Usage should be pretty simple, just take a look at the source code. Here is also a very useful example usage:

Also check out the DEMO playground included inside the project.

```swift

import SwiftCPUDetect

//Disabled debug prints from the library
SwiftCPUDetect.GeneralPrinter.enabled = false

var str = " "

//those prints gets various info about the cpu
#if os(macOS)

print("Brand string for CPU is \"\(HWInfo.CPU.brandString() ?? "[Not detected]")\"")

print("This cpu has \"\(HWInfo.CPU.coresPerPackage() ?? 255)\" cores for each package")
print("This cpu has \"\(HWInfo.CPU.threadsPerPackage() ?? 255)\" threads for each package")

for info in HWInfo.CPU.featuresList() ?? []{ //intel only
    str += " \(info),"
}

print("Features for CPU: \(str.dropLast())")

print("This system has \"\(HWInfo.CPU.packagesCount() ?? 255)\" cpu packages")

//Prints the current execution mode
print("Is my app running with Rosetta? \((AppExecutionMode.current() == .emulated) ? "Yes" : "No")")

//Example for fetching values using the Sysctl namespace class (intel only)
print("My cpu's vendor is \(Sysctl.Machdep.CPU.getString("vendor") ?? "Apple silicon or no vendor detected")")

#endif

print("This cpu has \"\(HWInfo.CPU.coresCount() ?? 255)\" cores")
print("This cpu has \"\(HWInfo.CPU.threadsCount() ?? 255)\" threads")

print("This cpu has \"\(HWInfo.CPU.EfficiencyCores.coresCount() ?? 0)\" E-cores")
print("This cpu has \"\(HWInfo.CPU.PerformanceCores.coresCount() ?? 0)\" P-cores")


print("This cpu is \(HWInfo.CPU.is64Bit() ? "64" : "32" ) bits")

//Prints the ammount of RAM in bytes
print("This computer has \((HWInfo.ramAmmount() ?? 0) / (1024 * 1024 * 1024)) GB of RAM")

//Prints the architecture of the current process
print("My app is running using the \(CpuArchitecture.current()?.rawValue ?? "[Can't detect architecture]") architecture")

//Prints the architecture of the current computer
print("My computer is running using the \(CpuArchitecture.machineCurrent()?.rawValue ?? "[Can't detect architecture]") architecture")

//Prints the architectures supported by the current executable
str = " "

for arch in CpuArchitecture.currentExecutableArchitectures(){
    str += " " + arch.rawValue + ","
}

print("My app supports those architectures: " + str.dropLast())

//Testing the uname fetching
print("Device's `uname -a`: \(UnameReimplemented.uname(withCommandLineArgs: [.a]) ?? "[Failed to get the uname string]")")

//Testing the boot args fetching
print("Cureently used boot-args: \(Sysctl.Kern.bootargs ?? "[can't get the boot args]")")


```

## What apps/programs is this Library intended for?

This library should be used by Swift apps/programs, that needs to know system information like the current cpu architecture, if the current app/program is running using Rosetta or just needs some basic system info.

This code should work across multiple platforms based on the XNU kernel and that provvides the necessary function calls using the Foundation module, but it has been tested to work only on macOS/OS X and iOS.

## About the project:

This code was created as part of my [TINU project](https://github.com/ITzTravelInTime/TINU) and it has been separated and made into it's own library to make the main project's source less complex and more focused on it's aim. 

Also having this as it's own library allows for code to be updated separately and so various versions of the main TINU app will be able to be compiled all with the latest version of this library.

## Credits:

 - ITzTravelInTime (Pietro Caruso) - Project creator and main developer
 - Original source for the methods used to perform some of the detections: https://developer.apple.com/forums/thread/652667

## Contacts

 - ITzTravelInTime (Pietro Caruso, project creator): piecaruso97@gmail.com

## Copyright

SwiftCPUDetect a Swift library to collect system and current process info.
Copyright (C) 2022 Pietro Caruso

This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA


