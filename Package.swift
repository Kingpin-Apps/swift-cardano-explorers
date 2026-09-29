// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SwiftCardanoExplorers",
    platforms: [
        .iOS(.v16),
        .macOS(.v14),
        .watchOS(.v8),
        .tvOS(.v15),
        .visionOS(.v1),
        .macCatalyst(.v15),
    ],
    products: [
        .library(name: "SwiftCardanoExplorers", targets: ["SwiftCardanoExplorers"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Kingpin-Apps/swift-cardano-core.git", from: "0.8.3"),
        .package(url: "https://github.com/Kingpin-Apps/swift-nacl.git", .upToNextMinor(from: "1.0.2")),
    ],
    targets: [
        .target(
            name: "SwiftCardanoExplorers",
            dependencies: [
                .product(name: "SwiftCardanoCore", package: "swift-cardano-core"),
                .product(name: "SwiftNaCl", package: "swift-nacl"),
            ]
        ),
        .testTarget(
            name: "SwiftCardanoExplorersTests",
            dependencies: ["SwiftCardanoExplorers"]
        ),
    ]
)
