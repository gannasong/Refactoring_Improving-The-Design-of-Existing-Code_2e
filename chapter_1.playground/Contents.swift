import Foundation
import XCTest

func statement(invoice: Invoice, plays: [String: Play]) -> String {
    var totalAmount = 0
    var volumeCredits = 0
    var result = "Statement for \(invoice.customer)\n"

    for perf in invoice.performances {
        guard let play = plays[perf.playID] else {
            fatalError("Not to found play.")
        }

        var thisAmount = amountFor(perf, play)

        // add volume credits
        volumeCredits += max(perf.audience - 30, 0)
        // add extra credit for every ten comedy attendees
        if "comedy" == play.type {
            volumeCredits += perf.audience / 5
        }

        // print line for this order
        result += " \(play.name): $\(thisAmount / 100) (\(perf.audience) seats)\n"
        totalAmount += thisAmount
    }

    result += "Amount owed is $\(totalAmount / 100)\n"
    result += "You earned \(volumeCredits) credits"
    return result
}

// 106
func amountFor(_ perf: Performance, _ play: Play) -> Int {
    var result = 0

    switch play.type {
        case "tragedy":
            result = 40000
            if perf.audience > 30 {
                result += 1000 * (perf.audience - 30)
            }
        case "comedy":
            result = 30000
            if perf.audience > 20 {
                result += 10000 + 500 * (perf.audience - 20)
            }
            result += 300 * perf.audience
        default:
            fatalError("unknown type: \(play.type)")
    }

    return result
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
