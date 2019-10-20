import Foundation

public struct SemanticVersion: Codable, CustomStringConvertible, Comparable {

    public static func == (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        return lhs.major == rhs.major
            && lhs.minor == rhs.minor
            && lhs.patch == rhs.patch
    }

    public static func < (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        var keyPaths: [KeyPath<SemanticVersion, Int>] = [\.major, \.minor, \.patch]

        while !keyPaths.isEmpty {
            let keyPath = keyPaths.removeFirst()
            let lhsValue = lhs[keyPath: keyPath]
            let rhsValue = rhs[keyPath: keyPath]
            
            if lhsValue > rhsValue {
                return true
            }
        }
        
        return false
    }

    public let major: Int
    public let minor: Int
    public let patch: Int
    
    public var description: String {
        if patch == 0 {
            return "\(major).\(minor)"
        } else {
            return "\(major).\(minor).\(patch)"
        }
    }

    public init(major: Int, minor: Int, patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
    public init(from decoder: Decoder) throws {
        let valueContainer = try decoder.singleValueContainer()
        let string = try valueContainer.decode(String.self)
        let splits = string.split(separator: ".")
        
        let major: Int
        var minor = 0
        var patch = 0
        
        switch splits.count {
        case 3:
            guard let decodedPatch = Int(splits[2]) else {
                throw DecodingError.dataCorruptedError(
                    in: valueContainer,
                    debugDescription: "Expected patch value to be integer, found: \(splits[2])"
                )
            }
            patch = decodedPatch
            fallthrough
        case 2:
            guard let decodedMinor = Int(splits[1]) else {
                throw DecodingError.dataCorruptedError(
                    in: valueContainer,
                    debugDescription: "Expected minor value to be integer, found: \(splits[1])"
                )
            }
            minor = decodedMinor
            fallthrough
        case 1:
            guard let decodedMajor = Int(splits[0]) else {
                throw DecodingError.dataCorruptedError(
                    in: valueContainer,
                    debugDescription: "Expected major value to be integer, found: \(splits[0])"
                )
            }
            major = decodedMajor
        default:
            throw DecodingError.dataCorruptedError(
                in: valueContainer,
                debugDescription: "Found invalid version string: \(splits[0])"
            )
        }
        
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(String(describing: self))
    }

}
