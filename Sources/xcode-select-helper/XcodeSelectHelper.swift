import Foundation

public final class XcodeSelectHelper {
    
    public static func findVersions(in directory: URL) {
        do {
            let xcodePaths = try FileManager.default.contentsOfDirectory(
                at: directory,
                includingPropertiesForKeys: []
            ).filter { $0.lastPathComponent.starts(with: "Xcode") && $0.hasDirectoryPath }
            let xcodeVersions = xcodePaths.compactMap(XcodeVersion.init(url:))
                

            print(xcodeVersions)
        } catch {
            print(error)
        }
    }
    
}
