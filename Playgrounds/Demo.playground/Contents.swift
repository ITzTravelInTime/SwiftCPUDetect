/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022-2023 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import SwiftCPUDetect
import SwiftSystemValues

//Disabled debug prints from the library
SwiftCPUDetect.GeneralPrinter.enabled = false

var str = " "

//those prints gets various info about the cpu
#if os(macOS) || targetEnvironment(macCatalyst)

print("This cpu has \"\(HWInfo.CPU.coresPerPackage() ?? 255)\" cores for each package")
print("This cpu has \"\(HWInfo.CPU.threadsPerPackage() ?? 255)\" threads for each package")

#if arch(x86_64) || arch(i386)
for info in HWInfo.CPU.featuresList() ?? []{ //intel only
    str += " \(info),"
}

print("Features for CPU: \(str.dropLast())")

print("This system has \"\(HWInfo.CPU.packagesCount() ?? 255)\" cpu packages")
#endif

//Prints the current execution mode
print("Is my app running with Rosetta? \((AppExecutionMode.current() == .emulated) ? "Yes" : "No")")

#endif

print("The name of the CPU is \"\(HWInfo.CPU.name() ?? "[Not detected]")\"")

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

for arch in CpuArchitecture.AppArchitectures.current() ?? []{
    str += " " + arch.rawValue + ","
}

print("My app supports those architectures: " + str.dropLast())

//Testing the uname fetching
print("Device's `uname -a`: \(UnameReimplemented.uname(withCommandLineArgs: [.a]) ?? "[Failed to get the uname string]")")

//TODO: Add gpu detection
