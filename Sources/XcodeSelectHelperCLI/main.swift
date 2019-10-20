import Foundation
import XcodeSelectHelper

let args = CommandLine.arguments

let isVerboseLoggingOn = args.contains("--verbose") || args.contains("-v")

func printError(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let descriptions = items.map(String.init(describing:))
    let message = descriptions.joined(separator: separator) + terminator
    fputs(message, stderr)
}

func printVerbose(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    guard isVerboseLoggingOn else { return }
    let descriptions = items.map(String.init(describing:))
    let message = descriptions.joined(separator: separator) + terminator
    fputs(message, stdout)
}

func printDefault(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let descriptions = items.map(String.init(describing:))
    let message = descriptions.joined(separator: separator) + terminator
    fputs(message, stdout)
}

let searchPath: URL
if let searchPathFlagIndex = args.firstIndex(of: "--searchPath") {
    let searchPathIndex = args.index(after: searchPathFlagIndex)
    guard args.indices.contains(searchPathIndex) else {
        printError("--searchPath must be proceeded by a path")
        exit(1)
    }
    let searchPathString = args[searchPathIndex]
    searchPath = URL(fileURLWithPath: searchPathString, isDirectory: true).standardizedFileURL
} else {
    searchPath = URL(string: "/Applications")!
}

let doPrintVersions = args.contains("--printVersions")

do {
    let versions = try XcodeSelectHelper.findVersions(in: searchPath)

    guard !versions.isEmpty else {
        printError("Failed to find any Xcode versions at", searchPath.path)
        exit(1)
    }

    if doPrintVersions {
        let versionDescriptions = versions.map(String.init(describing:))
        let versionsList = versionDescriptions.joined(separator: "\n")
        printDefault(versionsList)
    }
} catch {
    printError("Error finding versions at \(searchPath):", error)
    exit(1)
}
