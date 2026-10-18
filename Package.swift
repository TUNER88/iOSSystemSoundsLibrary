// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SystemSoundsLibrary",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15),
        .visionOS(.v1),
        .macCatalyst(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(name: "SystemSoundsLibrary", targets: ["SystemSoundsLibrary"]),
    ],
    targets: [
        .target(name: "SystemSoundsLibrary"),
        .testTarget(name: "SystemSoundsLibraryTests", dependencies: ["SystemSoundsLibrary"]),
    ]
)
