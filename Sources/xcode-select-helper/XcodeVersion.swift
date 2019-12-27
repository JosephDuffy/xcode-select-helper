import Foundation
import Version

public struct XcodeVersion: Decodable, Comparable {
    
    public static func < (lhs: XcodeVersion, rhs: XcodeVersion) -> Bool {
        if lhs.semanticVersion == rhs.semanticVersion {
            return lhs.isBeta && !rhs.isBeta
        } else {
            return lhs.semanticVersion < rhs.semanticVersion
        }
    }
    
    public let semanticVersion: Version
    public let build: String
    public let isBeta: Bool
    
    public var description: String {
        return "Xcode\(isBeta ? " Beta" : "") version \(semanticVersion) (\(build))"
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
    
}

private struct XcodePlist: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case semanticVersion = "CFBundleShortVersionString"
        case build = "DTXcodeBuild"
        case iconFileName = "CFBundleIconFile"
    }
    
    let semanticVersion: SemanticVersion
    let build: String
    let iconFileName: String
    
}
