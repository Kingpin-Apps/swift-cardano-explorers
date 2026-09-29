import Foundation
import SwiftCardanoCore

/// [PoolTool](https://pooltool.io), for stake pools and stake accounts, on
/// mainnet only.
public struct PoolTool: BlockchainExplorable {
    public let network: Network
    public let name = "PoolTool"
    public let networkUrls = NetworkURLs(mainnet: URL(string: "https://pooltool.io")!)
    public let supportedItems: Set<ExplorerItem.Kind> = [.account, .pool]

    public init(network: Network) { self.network = network }

    public func viewAccount(address: Address) throws -> URL { try page("address", stakeHash(address)) }
    public func viewPool(pool: PoolOperator) throws -> URL { try page("pool", poolHex(pool)) }
}
