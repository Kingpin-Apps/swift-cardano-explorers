import Foundation
import SwiftCardanoCore

/// [Pool PM](https://pool.pm), for wallets, pools, DReps and native assets,
/// on mainnet only. Its pages sit at the root: `pool.pm/<id>`.
public struct PoolPM: BlockchainExplorable {
    public let network: Network
    public let name = "Pool PM"
    public let networkUrls = NetworkURLs(mainnet: URL(string: "https://pool.pm")!)
    public let supportedItems: Set<ExplorerItem.Kind> = [.address, .account, .pool, .drep, .policy, .asset]

    public init(network: Network) { self.network = network }

    public func viewAddress(address: Address) throws -> URL { try page(bech32(address)) }
    public func viewAccount(address: Address) throws -> URL { try page(stakeBech32(address)) }
    public func viewPool(pool: PoolOperator) throws -> URL { try page(poolBech32(pool)) }
    public func viewDRep(drep: DRep) throws -> URL { try page(drepID(drep)) }
    public func viewPolicy(policyID: PolicyID) throws -> URL { try page("policy", policyID.payload.toHex) }
    public func viewAsset(policyID: PolicyID, assetName: AssetName) throws -> URL {
        try page(assetFingerprint(policyID, assetName))
    }
}
