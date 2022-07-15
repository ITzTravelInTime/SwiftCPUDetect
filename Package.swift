// swift-tools-version:5.0
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
        .package(url: "https://github.com/ITzTravelInTime/SwiftPackagesBase", from: "0.0.17")
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
