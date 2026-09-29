import Foundation
import SwiftCardanoCore

/// [Cardanoscan](https://cardanoscan.io), on mainnet, preprod and preview.
///
/// Blocks are linked by number.
public struct CardanoScan: BlockchainExplorable {
    /// The network the links are for.
    public let network: Network
    /// The explorer's name.
    public let name = "Cardanoscan"
    /// The explorer's site on each network it covers.
    public let networkUrls = NetworkURLs(
        mainnet: URL(string: "https://cardanoscan.io")!,
        preprod: URL(string: "https://preprod.cardanoscan.io")!,
        preview: URL(string: "https://preview.cardanoscan.io")!
    )
    /// The kinds of item the explorer has pages for.
    public let supportedItems: Set<ExplorerItem.Kind> = [
        .transaction, .address, .account, .block, .epoch, .pool, .drep, .governanceAction,
        .committeeMember, .policy, .asset,
    ]

    /// The explorer on `network`.
    /// - Parameter network: The network the links are for.
    public init(network: Network) { self.network = network }

    /// The transaction's page: `/transaction/<id in hex>`
    public func viewTransaction(transactionId: TransactionId) throws -> URL {
        try page("transaction", hex(transactionId))
    }
    /// The address's page: `/address/<addr…>`
    public func viewAddress(address: Address) throws -> URL { try page("address", bech32(address)) }
    /// The stake account's page: `/stakekey/<stake…>`
    public func viewAccount(address: Address) throws -> URL { try page("stakekey", stakeBech32(address)) }
    /// The block's page: `/block/<number>`. Cardanoscan links blocks by number only; a hash throws.
    public func viewBlock(block: BlockNumberOrBodyHash) throws -> URL {
        guard case .number(let number) = block else {
            throw ExplorerError.invalidItem("Cardanoscan links blocks by number, not hash.")
        }
        return try page("block", String(number))
    }
    /// The epoch's page: `/epoch/<number>`
    public func viewEpoch(epoch: EpochNumber) throws -> URL { try page("epoch", String(epoch)) }
    /// The pool's page: `/pool/<pool1…>`
    public func viewPool(pool: PoolOperator) throws -> URL { try page("pool", poolBech32(pool)) }
    /// The DRep's page: `/drep/<drep1…>`, CIP-129
    public func viewDRep(drep: DRep) throws -> URL { try page("drep", drepID(drep)) }
    /// The governance action's page: `/govAction/<gov_action1…>`
    public func viewGovernanceAction(govActionID: GovActionID) throws -> URL {
        try page("govAction", govActionBech32(govActionID))
    }
    /// The committee member's page: `/ccmember/<cc_cold1…>`
    public func viewCommitteeMember(committeeColdCredential: CommitteeColdCredential) throws -> URL {
        try page("ccmember", committeeID(committeeColdCredential))
    }
    /// The policy's page: `/tokenPolicy/<policy id in hex>`
    public func viewPolicy(policyID: PolicyID) throws -> URL { try page("tokenPolicy", policyID.payload.toHex) }
    /// The asset's page: `/token/<policy id and name in hex>`
    public func viewAsset(policyID: PolicyID, assetName: AssetName) throws -> URL {
        try page("token", assetHex(policyID, assetName))
    }
}
