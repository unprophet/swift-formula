import XCTest
@testable import Formula

final class AliasTableTests: XCTestCase {
    func testTableGeneration() throws {
        let weights = [0.125, 0.2, 0.1, 0.25, 0.1, 0.1, 0.125]
        let table = AliasTable(from: weights)
        
        XCTAssertEqual(table.probabilities, [0.875, 1.0, 0.7000000000000001, 0.7250000000000004, 0.7000000000000001, 0.7000000000000001, 0.875], "AliasTable probabilities were selected incorrectly.")
        XCTAssertEqual(table.aliases, [1, 0, 3, 1, 3, 3, 3], "AliasTable aliases were chosen incorrectly.")
    }
}
