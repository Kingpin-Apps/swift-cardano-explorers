import Foundation
import SwiftCardanoCore

/// [Cexplorer](https://cexplorer.io), on mainnet, preprod and preview.
///
/// Blocks are linked by hash, pools by `pool1…`, assets by fingerprint, and
/// governance actions as `txhash#index`.
public struct Cexplorer: BlockchainExplorable {
    /// The network the links are for.
    public let network: Network
    /// The explorer's name.
    public let name = "Cexplorer"
    /// The explorer's site on each network it covers.
    public let networkUrls = NetworkURLs(
        mainnet: URL(string: "https://cexplorer.io")!,
        preprod: URL(string: "https://preprod.cexplorer.io")!,
        preview: URL(string: "https://preview.cexplorer.io")!
    )
    /// The kinds of item the explorer has pages for.
    public let supportedItems: Set<ExplorerItem.Kind> = [
        .transaction, .address, .account, .block, .epoch, .pool, .drep, .governanceAction,
        .committeeMember, .policy, .asset,
    ]

    /// The explorer on `network`.
    /// - Parameter network: The network the links are for.
    public init(network: Network) { self.network = network }

    /// The transaction's page: `/tx/<id in hex>`
    public func viewTransaction(transactionId: TransactionId) throws -> URL { try page("tx", hex(transactionId)) }
    /// The address's page: `/address/<addr…>`
    public func viewAddress(address: Address) throws -> URL { try page("address", bech32(address)) }
    /// The stake account's page: `/stake/<stake…>`
    public func viewAccount(address: Address) throws -> URL { try page("stake", stakeBech32(address)) }
    /// The block's page: `/block/<hash>`. Cexplorer links blocks by hash only; a number throws.
    public func viewBlock(block: BlockNumberOrBodyHash) throws -> URL {
        guard case .bodyHash(let hash) = block else {
            throw ExplorerError.invalidItem("Cexplorer links blocks by hash, not number.")
        }
        return try page("block", hash.payload.toHex)
    }
    /// The epoch's page: `/epoch/<number>`
    public func viewEpoch(epoch: EpochNumber) throws -> URL { try page("epoch", String(epoch)) }
    /// The pool's page: `/pool/<pool1…>`. Cexplorer rejects hex pool ids.
    public func viewPool(pool: PoolOperator) throws -> URL { try page("pool", poolBech32(pool)) }
    /// The DRep's page: `/drep/<drep1…>`, CIP-129
    public func viewDRep(drep: DRep) throws -> URL { try page("drep", drepID(drep)) }
    /// The governance action's page: `/gov/action/<transaction id>%23<index>`: the action as `txhash#index`, with the `#` encoded.
    public func viewGovernanceAction(govActionID: GovActionID) throws -> URL {
        // The `#` is sent encoded, as %23.
        try page("gov", "action", "\(hex(govActionID.transactionID))#\(govActionID.govActionIndex)")
    }
    /// The committee member's page: `/gov/cc/<cc_cold1…>`
    public func viewCommitteeMember(committeeColdCredential: CommitteeColdCredential) throws -> URL {
        try page("gov", "cc", committeeID(committeeColdCredential))
    }
    /// The policy's page: `/policy/<policy id in hex>`
    public func viewPolicy(policyID: PolicyID) throws -> URL { try page("policy", policyID.payload.toHex) }
    /// The asset's page: `/asset/<asset1…>`: the CIP-14 fingerprint. Cexplorer rejects policy and name in hex.
    public func viewAsset(policyID: PolicyID, assetName: AssetName) throws -> URL {
        try page("asset", assetFingerprint(policyID, assetName))
    }
}
