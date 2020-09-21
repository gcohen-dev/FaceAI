import XCTest
@testable import FaceAI

final class FaceAITests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(FaceAI().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
