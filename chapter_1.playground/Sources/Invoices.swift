import Foundation

public struct Invoice {
    let customer: String
    let performances: [Performance]
}

public struct Performance {
    let playID: String
    let audience: Int
}

let performances: [Performance] = [
    .init(playID: "hamlet", audience: 55),
    .init(playID: "as-like", audience: 35),
    .init(playID: "othello", audience: 45)

]

public let invoices = Invoice(customer: "BigCo",
                              performances: performances)
