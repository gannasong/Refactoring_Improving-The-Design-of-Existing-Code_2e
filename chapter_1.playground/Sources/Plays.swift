import Foundation

public struct Play {
    let name: String
    let type: String
}

public let plays: [Play] = [
    .init(name: "Hamlet", type: "tragedy"),
    .init(name: "As You Like It", type: "comedy"),
    .init(name: "Othello", type: "tragedy")
]
