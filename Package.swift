// swift-tools-version:5.0

/*
 SwiftCPUDetect a Swift library to collect system and current process info.
 Copyright (C) 2022-2023 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftCPUDetect",
    platforms: [
        //Provviding this requirements is needed in order to offer the widest compatibility possible, not provviding requirements will limit this stuff to later versions
        .iOS("7.0"),
        .macOS("10.9"),
        .watchOS(.v2),
        .tvOS(.v9)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftCPUDetect",
            targets: ["SwiftCPUDetect", "SwiftSystemValues"]),
        .library(
            name: "SwiftSystemValues",
            targets: ["SwiftSystemValues"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/ITzTravelInTime/SwiftPackagesBase", from: "0.0.23")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftCPUDetect",
            dependencies: ["SwiftSystemValues", "SwiftPackagesBase"]),
        .target(name: "SwiftSystemValues", dependencies: ["SwiftPackagesBase"]),
        .testTarget(
            name: "SwiftCPUDetectTests",
            dependencies: ["SwiftCPUDetect", "SwiftSystemValues"])
    ]
)
