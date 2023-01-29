import Foundation

public struct Play {
    public let name: String
    public let type: String
}

public let plays: [String: Play] = [
    "hamlet": Play(name: "Hamlet", type: "tragedy"),
    "as-like": Play(name: "As You Like It", type: "comedy"),
    "othello": Play(name: "Othello", type: "tragedy")
]
