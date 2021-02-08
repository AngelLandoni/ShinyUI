// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ShinyUI",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_11)
    ],
    products: [
        .library(name: "ShinyUI", targets: ["ShinyUI"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "ShinyUI", dependencies: [], path: "Sources"),

        .testTarget(name: "ShinyUITests", dependencies: ["ShinyUI"])
    ]
)
