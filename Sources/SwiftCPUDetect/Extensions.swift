
/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022-2023 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation
import SwiftPackagesBase

#if !os(Linux)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13, *) extension CpuArchitecture: Identifiable{}
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13, *) extension UnameReimplemented.UnameCommandLineArgs: Identifiable{}
#endif

#if os(macOS) || targetEnvironment(macCatalyst)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13, *) extension AppExecutionMode: Identifiable{}
#endif
