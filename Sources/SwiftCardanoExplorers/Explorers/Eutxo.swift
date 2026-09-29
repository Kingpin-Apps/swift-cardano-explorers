import Foundation
import SwiftCardanoCore

/// [eUTxO](https://eutxo.org), a visual explorer of transactions and blocks,
/// on mainnet only.
public struct Eutxo: BlockchainExplorable {
    public let network: Network
    public let name = "eUTxO"
    public let networkUrls = NetworkURLs(mainnet: URL(string: "https://eutxo.org")!)
    public let supportedItems: Set<ExplorerItem.Kind> = [.transaction, .block]

    public init(network: Network) { self.network = network }

    public func viewTransaction(transactionId: TransactionId) throws -> URL {
        try page("transaction", hex(transactionId))
    }
    public func viewBlock(block: BlockNumberOrBodyHash) throws -> URL {
        switch block {
        case .number(let number): try page("block", String(number))
        case .bodyHash(let hash): try page("block", hash.payload.toHex)
        }
    }
}
