// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "advent2024",
    platforms: [.macOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "advent2024", targets: ["advent2024"])
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "advent2024",
            dependencies: ["InputFetcher"]
        ),
        .target(
            name: "InputFetcher",
            resources: [.process("secrets.json")]
        ),
        .testTarget(
            name: "advent2024Tests",
            dependencies: ["advent2024"]
        ),
    ]
)
