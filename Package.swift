// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "OfflineSyncKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "OfflineSyncKit",
            targets: ["OfflineSyncKit"]
        )
    ],
    targets: [
        .target(
            name: "OfflineSyncKit",
            dependencies: []
        ),
        .testTarget(
            name: "OfflineSyncKitTests",
            dependencies: ["OfflineSyncKit"]
        )
    ]
)
