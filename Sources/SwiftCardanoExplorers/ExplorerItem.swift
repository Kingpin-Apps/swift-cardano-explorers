import Foundation
import SwiftCardanoCore

/// A block, by its number or its body hash. Explorers differ in which they
/// take: Cardanoscan and PoolTool use numbers; AdaStat, Cexplorer and eUTxO
/// use hashes.
public enum BlockNumberOrBodyHash: Codable, Hashable, CustomStringConvertible, Sendable {
    case number(BlockNumber)
    case bodyHash(BlockBodyHash)

    public var description: String {
        switch self {
        case .bodyHash(let hash): "Block Hash: \(hash)"
        case .number(let number): "Block Number: \(number)"
        }
    }
}

/// Something an explorer can show.
public enum ExplorerItem: Sendable, CustomStringConvertible {
    case transaction(TransactionId)
    case address(Address)
    /// The stake account of an address with a stake part, or of a stake address.
    case account(Address)
    case block(BlockNumberOrBodyHash)
    case epoch(EpochNumber)
    case pool(PoolOperator)
    case drep(DRep)
    case governanceAction(GovActionID)
    case committeeMember(CommitteeColdCredential)
    /// A minting policy and everything under it.
    case policy(PolicyID)
    /// One native asset.
    case asset(policy: PolicyID, name: AssetName)

    /// What kind of item it is, for messages and for asking whether an
    /// explorer supports it.
    public var kind: Kind {
        switch self {
        case .transaction: .transaction
        case .address: .address
        case .account: .account
        case .block: .block
        case .epoch: .epoch
        case .pool: .pool
        case .drep: .drep
        case .governanceAction: .governanceAction
        case .committeeMember: .committeeMember
        case .policy: .policy
        case .asset: .asset
        }
    }

    public var description: String { kind.rawValue }

    public enum Kind: String, CaseIterable, Sendable {
        case transaction = "a transaction"
        case address = "an address"
        case account = "a stake account"
        case block = "a block"
        case epoch = "an epoch"
        case pool = "a stake pool"
        case drep = "a DRep"
        case governanceAction = "a governance action"
        case committeeMember = "a committee member"
        case policy = "a policy"
        case asset = "an asset"
    }
}
