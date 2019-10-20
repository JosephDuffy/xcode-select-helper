import Foundation

public struct XcodeVersion: Comparable, CustomStringConvertible {
    
    public static func < (lhs: XcodeVersion, rhs: XcodeVersion) -> Bool {
        if lhs.semanticVersion == rhs.semanticVersion {
            return lhs.isBeta && !rhs.isBeta
        } else {
            return lhs.semanticVersion < rhs.semanticVersion
        }
    }
    
    public let semanticVersion: SemanticVersion
    public let build: String
    public let isBeta: Bool
    
    public var description: String {
        return "Xcode\(isBeta ? " Beta" : "") \(semanticVersion) (\(build))"
    }
    
    public init?(url: URL) {
        let decoder = PropertyListDecoder()
        let url = url.appendingPathComponent("Contents/Info.plist", isDirectory: false)
        
        guard let data = FileManager.default.contents(atPath: url.path) else {
            return nil
        }
        do {
            var format = PropertyListSerialization.PropertyListFormat.binary
            let plist = try decoder.decode(XcodePlist.self, from: data, format: &format)
            semanticVersion = plist.semanticVersion
            build = plist.build
            isBeta = plist.iconFileName.hasSuffix("Beta")
        } catch {
            return nil
        }
    }

    public init(semanticVersion: SemanticVersion, build: String, isBeta: Bool) {
        self.semanticVersion = semanticVersion
        self.build = build
        self.isBeta = isBeta
    }

    internal func write(to url: URL) throws {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        let plistRepresentation = XcodePlist(semanticVersion: semanticVersion, build: build, isBeta: isBeta)
        let data = try encoder.encode(plistRepresentation)
        let appName = "Xcode_" + String(describing: semanticVersion).replacingOccurrences(of: ".", with: "_") + ".app"
        let contentsDirectory = url.appendingPathComponent(appName, isDirectory: true).appendingPathComponent("Contents", isDirectory: true)
        try FileManager.default.createDirectory(at: contentsDirectory, withIntermediateDirectories: true, attributes: nil)
        let infoPlistURL = contentsDirectory.appendingPathComponent("Info.plist", isDirectory: false)
        FileManager
            .default
            .createFile(
                atPath: infoPlistURL.path,
                contents: data,
                attributes: nil
            )
        print("Wrote Info.plist to", infoPlistURL)
    }
    
}

private struct XcodePlist: Codable {
    
    enum CodingKeys: String, CodingKey {
        case semanticVersion = "CFBundleShortVersionString"
        case build = "DTXcodeBuild"
        case iconFileName = "CFBundleIconFile"
    }
    
    let semanticVersion: SemanticVersion
    let build: String
    let iconFileName: String

    fileprivate init(semanticVersion: SemanticVersion, build: String, isBeta: Bool) {
        self.semanticVersion = semanticVersion
        self.build = build
        self.iconFileName = "Xcode" + (isBeta ? "Beta" : "")
    }

}
