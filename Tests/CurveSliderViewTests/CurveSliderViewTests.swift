import XCTest
@testable import CurveSliderView

final class CurveSliderViewTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        if #available(iOS 13.0, *) {
            XCTAssertNotNil(CurveSliderView(value: .constant(100)))
        } else {
            // Fallback on earlier versions
        }
    }
}
