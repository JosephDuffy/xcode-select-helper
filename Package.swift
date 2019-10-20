// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "XcodeSelectHelper",
    platforms: [
        .macOS(.v10_13),
    ],
    products: [
        .executable(name: "xcode-select-helper", targets: ["XcodeSelectHelperCLI"]),
        .library(name: "XcodeSelectHelper", targets: ["XcodeSelectHelper"]),
    ],
    targets: [
        .target(name: "XcodeSelectHelperCLI", dependencies: ["XcodeSelectHelper"]),
        .testTarget(name: "XcodeSelectHelperCLITests", dependencies: ["XcodeSelectHelperCLI"]),
        .target(name: "XcodeSelectHelper", dependencies: []),
        .testTarget(name: "XcodeSelectHelperTests", dependencies: ["XcodeSelectHelper"]),
    ]
)
