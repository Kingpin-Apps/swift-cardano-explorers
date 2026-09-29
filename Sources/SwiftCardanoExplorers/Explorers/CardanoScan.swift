import Foundation
import SwiftCardanoCore

/// [Cardanoscan](https://cardanoscan.io), on mainnet, preprod and preview.
///
/// Blocks are linked by number.
public struct CardanoScan: BlockchainExplorable {
    public let network: Network
    public let name = "Cardanoscan"
    public let networkUrls = NetworkURLs(
        mainnet: URL(string: "https://cardanoscan.io")!,
        preprod: URL(string: "https://preprod.cardanoscan.io")!,
        preview: URL(string: "https://preview.cardanoscan.io")!
    )
    public let supportedItems: Set<ExplorerItem.Kind> = [
        .transaction, .address, .account, .block, .epoch, .pool, .drep, .governanceAction,
        .committeeMember, .policy, .asset,
    ]

    public init(network: Network) { self.network = network }

    public func viewTransaction(transactionId: TransactionId) throws -> URL {
        try page("transaction", hex(transactionId))
    }
    public func viewAddress(address: Address) throws -> URL { try page("address", bech32(address)) }
    public func viewAccount(address: Address) throws -> URL { try page("stakekey", stakeBech32(address)) }
    public func viewBlock(block: BlockNumberOrBodyHash) throws -> URL {
        guard case .number(let number) = block else {
            throw ExplorerError.invalidItem("Cardanoscan links blocks by number, not hash.")
        }
        return try page("block", String(number))
    }
    public func viewEpoch(epoch: EpochNumber) throws -> URL { try page("epoch", String(epoch)) }
    public func viewPool(pool: PoolOperator) throws -> URL { try page("pool", poolBech32(pool)) }
    public func viewDRep(drep: DRep) throws -> URL { try page("drep", drepID(drep)) }
    public func viewGovernanceAction(govActionID: GovActionID) throws -> URL {
        try page("govAction", govActionBech32(govActionID))
    }
    public func viewCommitteeMember(committeeColdCredential: CommitteeColdCredential) throws -> URL {
        try page("ccmember", committeeID(committeeColdCredential))
    }
    public func viewPolicy(policyID: PolicyID) throws -> URL { try page("tokenPolicy", policyID.payload.toHex) }
    public func viewAsset(policyID: PolicyID, assetName: AssetName) throws -> URL {
        try page("token", assetHex(policyID, assetName))
    }
}
