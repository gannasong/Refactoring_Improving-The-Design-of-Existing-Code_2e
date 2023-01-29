import Foundation

public struct Invoice {
    public let customer: String
    public let performances: [Performance]

    public init(customer: String, performances: [Performance]) {
        self.customer = customer
        self.performances = performances
    }
}

public struct Performance {
    public let playID: String
    public let audience: Int

    public init(playID: String, audience: Int) {
        self.playID = playID
        self.audience = audience
    }
}
