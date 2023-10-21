// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "swiftdata-transferrable",
    platforms: [
        .macOS("14.0"),
        .iOS("17.0"),
    ],
    products: [
        .library(
            name: "SwiftDataTransferrable",
            targets: ["SwiftDataTransferrable"]),
    ],
    targets: [
        .target(
            name: "SwiftDataTransferrable"),
        .testTarget(
            name: "SwiftDataTransferrableTests",
            dependencies: ["SwiftDataTransferrable"]),
    ]
)
