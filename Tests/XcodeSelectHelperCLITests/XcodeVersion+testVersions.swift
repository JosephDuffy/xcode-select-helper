import Foundation
import XcodeSelectHelper

extension XcodeVersion {

    static var v11_1_gm: XcodeVersion {
        return XcodeVersion(
            semanticVersion: SemanticVersion(major: 11, minor: 1, patch: 0),
            build: "11A1024",
            isBeta: false
        )
    }

}