// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "XrayWeave",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "XrayWeave",
            targets: ["XrayWeave"]),
    ],
    targets: [
        .target(
            name: "XrayWeave"
        ),
        .testTarget(
            name: "XrayWeaveTests",
            dependencies: ["XrayWeave"])
    ]
)
