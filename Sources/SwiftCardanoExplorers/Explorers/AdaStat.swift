import Foundation
import SwiftCardanoCore

/// [AdaStat](https://adastat.net), on mainnet only.
///
/// Accounts are linked by stake key hash, pools by hex id and governance
/// actions by their hex id. It has no committee member pages.
public struct AdaStat: BlockchainExplorable {
    /// The network the links are for.
    public let network: Network
    /// The explorer's name.
    public let name = "AdaStat"
    /// The explorer's site on each network it covers.
    public let networkUrls = NetworkURLs(mainnet: URL(string: "https://adastat.net")!)
    /// The kinds of item the explorer has pages for.
    public let supportedItems: Set<ExplorerItem.Kind> = [
        .transaction, .address, .account, .block, .epoch, .pool, .drep, .governanceAction, .policy, .asset,
    ]

    /// The explorer on `network`.
    /// - Parameter network: The network the links are for.
    public init(network: Network) { self.network = network }

    /// The transaction's page: `/transactions/<id in hex>`
    public func viewTransaction(transactionId: TransactionId) throws -> URL {
        try page("transactions", hex(transactionId))
    }
    /// The address's page: `/addresses/<addr…>`
    public func viewAddress(address: Address) throws -> URL { try page("addresses", bech32(address)) }
    /// The stake account's page: `/accounts/<stake credential hash in hex>`
    public func viewAccount(address: Address) throws -> URL { try page("accounts", stakeHash(address)) }
    /// The block's page: `/blocks/<number or hash>`
    public func viewBlock(block: BlockNumberOrBodyHash) throws -> URL {
        switch block {
        case .number(let number): try page("blocks", String(number))
        case .bodyHash(let hash): try page("blocks", hash.payload.toHex)
        }
    }
    /// The epoch's page: `/epochs/<number>`
    public func viewEpoch(epoch: EpochNumber) throws -> URL { try page("epochs", String(epoch)) }
    /// The pool's page: `/pools/<pool id in hex>`
    public func viewPool(pool: PoolOperator) throws -> URL { try page("pools", poolHex(pool)) }
    /// The DRep's page: `/dreps/<drep1…>`, CIP-129
    public func viewDRep(drep: DRep) throws -> URL { try page("dreps", drepID(drep)) }
    /// The governance action's page: `/governances/<transaction id and a one-byte index, in hex>`
    public func viewGovernanceAction(govActionID: GovActionID) throws -> URL {
        try page("governances", govActionHex(govActionID))
    }
    /// The policy's page: `/policies/<policy id in hex>`
    public func viewPolicy(policyID: PolicyID) throws -> URL { try page("policies", policyID.payload.toHex) }
    /// The asset's page: `/tokens/<policy id and name in hex>`
    public func viewAsset(policyID: PolicyID, assetName: AssetName) throws -> URL {
        try page("tokens", assetHex(policyID, assetName))
    }
}
