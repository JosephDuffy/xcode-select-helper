import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(xcode_select_helperTests.allTests),
    ]
}
#endif
