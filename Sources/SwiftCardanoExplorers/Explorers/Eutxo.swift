import Foundation
import SwiftCardanoCore

/// [eUTxO](https://eutxo.org), a visual explorer of transactions and blocks,
/// on mainnet only.
public struct Eutxo: BlockchainExplorable {
    /// The network the links are for.
    public let network: Network
    /// The explorer's name.
    public let name = "eUTxO"
    /// The explorer's site on each network it covers.
    public let networkUrls = NetworkURLs(mainnet: URL(string: "https://eutxo.org")!)
    /// The kinds of item the explorer has pages for.
    public let supportedItems: Set<ExplorerItem.Kind> = [.transaction, .block]

    /// The explorer on `network`.
    /// - Parameter network: The network the links are for.
    public init(network: Network) { self.network = network }

    /// The transaction's page: `/transaction/<id in hex>`
    public func viewTransaction(transactionId: TransactionId) throws -> URL {
        try page("transaction", hex(transactionId))
    }
    /// The block's page: `/block/<number or hash>`
    public func viewBlock(block: BlockNumberOrBodyHash) throws -> URL {
        switch block {
        case .number(let number): try page("block", String(number))
        case .bodyHash(let hash): try page("block", hash.payload.toHex)
        }
    }
}
