import Foundation
import XCTest

let plays: [String: Play] = [
    "hamlet": Play(name: "Hamlet", type: "tragedy"),
    "as-like": Play(name: "As You Like It", type: "comedy"),
    "othello": Play(name: "Othello", type: "tragedy")
]

func statement(invoice: Invoice, plays: [String: Play]) -> String {
    var totalAmount = 0
    var volumeCredits = 0
    var result = "Statement for \(invoice.customer)\n"

    for perf in invoice.performances {
        volumeCredits += volumeCreditsFor(perf)

        // print line for this order
        result += " \(playFor(perf).name): $\(amountFor(perf) / 100) (\(perf.audience) seats)\n"
        totalAmount += amountFor(perf)
    }

    result += "Amount owed is $\(totalAmount / 100)\n"
    result += "You earned \(volumeCredits) credits"
    return result
}

func volumeCreditsFor(_ perf: Performance) -> Int {
    var volumeCredits = 0
    volumeCredits += max(perf.audience - 30, 0)

    if "comedy" == playFor(perf).type {
        volumeCredits += perf.audience / 5
    }

    return volumeCredits
}

// [106]
func amountFor(_ aPerformance: Performance) -> Int {
    var result = 0

    switch playFor(aPerformance).type {
        case "tragedy":
            result = 40000
            if aPerformance.audience > 30 {
                result += 1000 * (aPerformance.audience - 30)
            }
        case "comedy":
            result = 30000
            if aPerformance.audience > 20 {
                result += 10000 + 500 * (aPerformance.audience - 20)
            }
            result += 300 * aPerformance.audience
        default:
            fatalError("unknown type: \(playFor(aPerformance).type)")
    }

    return result
}

// [123]
func playFor(_ aPerformance: Performance) -> Play {
    return plays[aPerformance.playID]!
}

// Test
class StatementTests: XCTestCase {
    func test_validate_statementResultEqualToAnyResult() {
        let anyInvoices = makeAnyInvoices()
        let anyPlays = makeAnyPlays()
        let expectResult = makeAnyResult()

        let receivedResults = statement(invoice: anyInvoices,
                                        plays: anyPlays)

        XCTAssertEqual(expectResult, receivedResults)
    }

    // MARK: - Helpers
    private func makeAnyResult() -> String {
        return """
            Statement for BigCo
             Hamlet: $650 (55 seats)
             As You Like It: $580 (35 seats)
             Othello: $500 (40 seats)
            Amount owed is $1730
            You earned 47 credits
            """
    }

    private func makeAnyPlays() -> [String: Play] {
        return [
            "hamlet": Play(name: "Hamlet", type: "tragedy"),
            "as-like": Play(name: "As You Like It", type: "comedy"),
            "othello": Play(name: "Othello", type: "tragedy")
        ]
    }

    private func makeAnyInvoices() -> Invoice {
        return Invoice(customer: "BigCo",
                       performances: [
                        .init(playID: "hamlet", audience: 55),
                        .init(playID: "as-like", audience: 35),
                        .init(playID: "othello", audience: 40)
                       ])
    }
}

let testObserver = TestObserver()
XCTestObservationCenter.shared.addTestObserver(testObserver)
StatementTests.defaultTestSuite.run()
