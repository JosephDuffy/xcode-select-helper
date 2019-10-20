import XCTest
import class Foundation.Bundle

final class xcode_select_helperTests: XCTestCase {
    
    func testExample() throws {
        let fooBinary = productsDirectory.appendingPathComponent("xcode-select-helper")

        let process = Process()
        process.executableURL = fooBinary
        process.arguments = [
            "--searchPath",
        ]

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "Hello, world!\n")
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }
    
    var mockXcodesDirectory: URL {
        return productsDirectory.appendingPathComponent("Resources/MockXcodes", isDirectory: true)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
