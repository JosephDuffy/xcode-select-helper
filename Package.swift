// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "xcode-select-helper",
    platforms: [
        .macOS(.v10_13),
    ],
    dependencies: [
        .package(url: "https://github.com/mxcl/Version.git", from: "1.2.0"),
    ],
    targets: [
        .target(name: "xcode-select-helper", dependencies: ["Version"]),
        .testTarget(name: "xcode-select-helperTests", dependencies: ["xcode-select-helper"]),
    ]
)
