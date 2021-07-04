# SwiftCPUDetect
Swift Library to detect the current CPU Architecture and if the current process is running under Rosetta.

# Features

- Get if the current process is ruiing using Rosetta (aka as emulated) using the `AppExecutionMode` enum
- Get the Cpu architecture used by the current process and the architecture used by the computer using the `CpuArchitecture`  enum

# Usage

Usage should be pretty simple, just take a look at the source code, here is also a very usefoul example usage:

```swift

import SwiftCPUDetect

print("Is my app running with Rosetta? \((AppExecutionMode.current() == .emulated) ? "Yes" : "No")")

print("My app is running using the \(CpuArchitecture.current()?.rawValue ?? "[Can't detect architecture]") architecture")

print("My computer is running using the \(CpuArchitecture.actualCurrent()?.rawValue ?? "[Can't detect architecture]") architecture")

```

# What apps/programs is this Library intended for?

This library should be used by Swift apps/programs, that needs to operate differently depending on which cpu architecture are currently running on and if they are running using Rosetta.

This code should work across multiple platforms based on the XNU kernel and that provvides the necessary function calls usinf the Foundation module, but it has been tested to work only on macOS/OS X.

# About the project:

This code was created as part of my [TINU project](https://github.com/ITzTravelInTime/TINU) and it has been separated and made into it's own library to make the main project's source less complex and more focused on it's aim. 

Also having this as it's own library allows for code to be updated separately and so various versions of the main TINU app will be able to be compiled all with the latest version of this library.

# Credits:

 - ITzTravelInTime (Pietro Caruso) - Project creator and main developer
 - Original source for the methods used to perform some of the detections: https://developer.apple.com/forums/thread/652667

# Contacts

 - ITzTravelInTime (Pietro Caruso): piecaruso97@gmail.com

# Copyright

Copyright (C) 2021 Pietro Caruso

This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA


