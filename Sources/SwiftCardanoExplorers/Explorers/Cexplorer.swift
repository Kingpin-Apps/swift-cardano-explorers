import Foundation
import SwiftCardanoCore

/// [Cexplorer](https://cexplorer.io), on mainnet, preprod and preview.
///
/// Blocks are linked by hash, pools by `pool1…`, assets by fingerprint, and
/// governance actions as `txhash#index`.
public struct Cexplorer: BlockchainExplorable {
    public let network: Network
    public let name = "Cexplorer"
    public let networkUrls = NetworkURLs(
        mainnet: URL(string: "https://cexplorer.io")!,
        preprod: URL(string: "https://preprod.cexplorer.io")!,
        preview: URL(string: "https://preview.cexplorer.io")!
    )
    public let supportedItems: Set<ExplorerItem.Kind> = [
        .transaction, .address, .account, .block, .epoch, .pool, .drep, .governanceAction,
        .committeeMember, .policy, .asset,
    ]

    public init(network: Network) { self.network = network }

    public func viewTransaction(transactionId: TransactionId) throws -> URL { try page("tx", hex(transactionId)) }
    public func viewAddress(address: Address) throws -> URL { try page("address", bech32(address)) }
    public func viewAccount(address: Address) throws -> URL { try page("stake", stakeBech32(address)) }
    public func viewBlock(block: BlockNumberOrBodyHash) throws -> URL {
        guard case .bodyHash(let hash) = block else {
            throw ExplorerError.invalidItem("Cexplorer links blocks by hash, not number.")
        }
        return try page("block", hash.payload.toHex)
    }
    public func viewEpoch(epoch: EpochNumber) throws -> URL { try page("epoch", String(epoch)) }
    public func viewPool(pool: PoolOperator) throws -> URL { try page("pool", poolBech32(pool)) }
    public func viewDRep(drep: DRep) throws -> URL { try page("drep", drepID(drep)) }
    public func viewGovernanceAction(govActionID: GovActionID) throws -> URL {
        // The `#` is sent encoded, as %23.
        try page("gov", "action", "\(hex(govActionID.transactionID))#\(govActionID.govActionIndex)")
    }
    public func viewCommitteeMember(committeeColdCredential: CommitteeColdCredential) throws -> URL {
        try page("gov", "cc", committeeID(committeeColdCredential))
    }
    public func viewPolicy(policyID: PolicyID) throws -> URL { try page("policy", policyID.payload.toHex) }
    public func viewAsset(policyID: PolicyID, assetName: AssetName) throws -> URL {
        try page("asset", assetFingerprint(policyID, assetName))
    }
}
