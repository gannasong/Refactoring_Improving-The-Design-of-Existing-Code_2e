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

        var thisAmount = 0
        switch play.type {
            case "tragedy":
                thisAmount = 40000
                if perf.audience > 30 {
                    thisAmount += 1000 * (perf.audience - 30)
                }
                break
            case "comedy":
                thisAmount = 30000
                if perf.audience > 20 {
                    thisAmount += 10000 + 500 * (perf.audience - 20)
                }
                thisAmount += 300 * perf.audience
                break
            default:
                fatalError("unknown type: \(play.type)")
        }

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
    result += "You earned \(volumeCredits) credits\n"
    return result
}

let result = statement(invoice: invoices, plays: plays)

print(result)

