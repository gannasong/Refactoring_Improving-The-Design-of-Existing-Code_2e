import Foundation

public struct Invoice {
    public let customer: String
    public let performances: [Performance]
}

public struct Performance {
    public let playID: String
    public let audience: Int
}

let performances: [Performance] = [
    .init(playID: "hamlet", audience: 55),
    .init(playID: "as-like", audience: 35),
    .init(playID: "othello", audience: 40)

]

public let invoices = Invoice(customer: "BigCo",
                              performances: performances)
