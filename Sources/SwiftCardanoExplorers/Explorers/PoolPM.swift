import Foundation
import SwiftCardanoCore

/// [Pool PM](https://pool.pm), for wallets, pools, DReps and native assets,
/// on mainnet only. Its pages sit at the root: `pool.pm/<id>`.
public struct PoolPM: BlockchainExplorable {
    /// The network the links are for.
    public let network: Network
    /// The explorer's name.
    public let name = "Pool PM"
    /// The explorer's site on each network it covers.
    public let networkUrls = NetworkURLs(mainnet: URL(string: "https://pool.pm")!)
    /// The kinds of item the explorer has pages for.
    public let supportedItems: Set<ExplorerItem.Kind> = [.address, .account, .pool, .drep, .policy, .asset]

    /// The explorer on `network`.
    /// - Parameter network: The network the links are for.
    public init(network: Network) { self.network = network }

    /// The address's page: `/<addr…>`
    public func viewAddress(address: Address) throws -> URL { try page(bech32(address)) }
    /// The stake account's page: `/<stake…>`
    public func viewAccount(address: Address) throws -> URL { try page(stakeBech32(address)) }
    /// The pool's page: `/<pool1…>`
    public func viewPool(pool: PoolOperator) throws -> URL { try page(poolBech32(pool)) }
    /// The DRep's page: `/<drep1…>`, CIP-129
    public func viewDRep(drep: DRep) throws -> URL { try page(drepID(drep)) }
    /// The policy's page: `/policy/<policy id in hex>`
    public func viewPolicy(policyID: PolicyID) throws -> URL { try page("policy", policyID.payload.toHex) }
    /// The asset's page: `/<asset1…>`: the CIP-14 fingerprint
    public func viewAsset(policyID: PolicyID, assetName: AssetName) throws -> URL {
        try page(assetFingerprint(policyID, assetName))
    }
}
