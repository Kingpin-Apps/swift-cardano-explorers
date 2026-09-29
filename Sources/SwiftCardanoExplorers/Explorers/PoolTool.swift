import Foundation
import SwiftCardanoCore

/// [PoolTool](https://pooltool.io), for stake pools and stake accounts, on
/// mainnet only.
public struct PoolTool: BlockchainExplorable {
    /// The network the links are for.
    public let network: Network
    /// The explorer's name.
    public let name = "PoolTool"
    /// The explorer's site on each network it covers.
    public let networkUrls = NetworkURLs(mainnet: URL(string: "https://pooltool.io")!)
    /// The kinds of item the explorer has pages for.
    public let supportedItems: Set<ExplorerItem.Kind> = [.account, .pool]

    /// The explorer on `network`.
    /// - Parameter network: The network the links are for.
    public init(network: Network) { self.network = network }

    /// The stake account's page: `/address/<stake credential hash in hex>`
    public func viewAccount(address: Address) throws -> URL { try page("address", stakeHash(address)) }
    /// The pool's page: `/pool/<pool id in hex>`
    public func viewPool(pool: PoolOperator) throws -> URL { try page("pool", poolHex(pool)) }
}
