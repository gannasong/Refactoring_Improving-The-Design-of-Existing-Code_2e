import Foundation
import XCTest

// Sample Plays Data
let plays: [String: Play] = [
    "hamlet": Play(name: "Hamlet", type: "tragedy"),
    "as-like": Play(name: "As You Like It", type: "comedy"),
    "othello": Play(name: "Othello", type: "tragedy")
]

// Main Function
func statement(invoice: Invoice, plays: [String: Play]) -> String {
    return renderPlainText(invoice, plays)
}

// Helpers
func renderPlainText(_ invoice: Invoice, _ plays: [String: Play]) -> String {
    var result = "Statement for \(invoice.customer)\n"
    for perf in invoice.performances {
        result += " \(playFor(perf).name): $\(usd(amountFor(perf))) (\(perf.audience) seats)\n"
    }

    result += "Amount owed is $\(usd(totalAmount(invoice)))\n"
    result += "You earned \(totalVolumeCredits(invoice)) credits"
    return result
}

func totalAmount(_ invoice: Invoice) -> Int {
    var result = 0
    for perf in invoice.performances {
        result += amountFor(perf)
    }

    return result
}

func totalVolumeCredits(_ invoice: Invoice) -> Int {
    var result = 0
    for perf in invoice.performances {
        result += volumeCreditsFor(perf)
    }

    return result
}

func usd(_ aNumber: Int) -> Int {
    return aNumber / 100
}

func volumeCreditsFor(_ aPerformance: Performance) -> Int {
    var result = 0
    result += max(aPerformance.audience - 30, 0)

    if "comedy" == playFor(aPerformance).type {
        result += aPerformance.audience / 5
    }

    return result
}

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
