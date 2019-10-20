// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "xcode-select-helper",
    platforms: [
        .macOS(.v10_13),
    ],
    targets: [
        .target(name: "xcode-select-helper", dependencies: []),
        .testTarget(name: "xcode-select-helperTests", dependencies: ["xcode-select-helper"]),
    ]
)
