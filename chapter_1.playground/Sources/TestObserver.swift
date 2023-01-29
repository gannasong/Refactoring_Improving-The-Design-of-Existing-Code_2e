import Foundation
import XCTest

/*
 In a playground, this process does not exist really.
 We have to manually create a test suite (something containing all of the tests)
 and run it
 */

public class TestObserver: NSObject, XCTestObservation {
    public func testCase(_ testCase: XCTestCase,
                         didFailWithDescription description: String,
                         inFile filePath: String?,
                         atLine lineNumber: Int) {
        assertionFailure(description, line: UInt(lineNumber))
    }
}
