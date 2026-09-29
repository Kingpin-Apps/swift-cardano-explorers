import Foundation
import SwiftCardanoCore

/// [AdaStat](https://adastat.net), on mainnet only.
///
/// Accounts are linked by stake key hash, pools by hex id and governance
/// actions by their hex id. It has no committee member pages.
public struct AdaStat: BlockchainExplorable {
    public let network: Network
    public let name = "AdaStat"
    public let networkUrls = NetworkURLs(mainnet: URL(string: "https://adastat.net")!)
    public let supportedItems: Set<ExplorerItem.Kind> = [
        .transaction, .address, .account, .block, .epoch, .pool, .drep, .governanceAction, .policy, .asset,
    ]

    public init(network: Network) { self.network = network }

    public func viewTransaction(transactionId: TransactionId) throws -> URL {
        try page("transactions", hex(transactionId))
    }
    public func viewAddress(address: Address) throws -> URL { try page("addresses", bech32(address)) }
    public func viewAccount(address: Address) throws -> URL { try page("accounts", stakeHash(address)) }
    public func viewBlock(block: BlockNumberOrBodyHash) throws -> URL {
        switch block {
        case .number(let number): try page("blocks", String(number))
        case .bodyHash(let hash): try page("blocks", hash.payload.toHex)
        }
    }
    public func viewEpoch(epoch: EpochNumber) throws -> URL { try page("epochs", String(epoch)) }
    public func viewPool(pool: PoolOperator) throws -> URL { try page("pools", poolHex(pool)) }
    public func viewDRep(drep: DRep) throws -> URL { try page("dreps", drepID(drep)) }
    public func viewGovernanceAction(govActionID: GovActionID) throws -> URL {
        try page("governances", govActionHex(govActionID))
    }
    public func viewPolicy(policyID: PolicyID) throws -> URL { try page("policies", policyID.payload.toHex) }
    public func viewAsset(policyID: PolicyID, assetName: AssetName) throws -> URL {
        try page("tokens", assetHex(policyID, assetName))
    }
}
