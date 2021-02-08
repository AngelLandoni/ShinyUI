import XCTest
@testable import ShinyUI

final class ShinyUITests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ShinyUI().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample)
    ]
}
