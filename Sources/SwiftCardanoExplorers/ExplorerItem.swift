import Foundation
import SwiftCardanoCore

/// A block, by its number or its body hash. Explorers differ in which they
/// take: Cardanoscan and PoolTool use numbers; AdaStat, Cexplorer and eUTxO
/// use hashes.
public enum BlockNumberOrBodyHash: Codable, Hashable, CustomStringConvertible, Sendable {
    /// A block by its height.
    case number(BlockNumber)
    /// A block by the hash of its body.
    case bodyHash(BlockBodyHash)

    /// The identifier, labelled with its form.
    public var description: String {
        switch self {
        case .bodyHash(let hash): "Block Hash: \(hash)"
        case .number(let number): "Block Number: \(number)"
        }
    }
}

/// Something an explorer can show.
///
/// Each explorer writes the item's identifier in the form its site expects,
/// so an item is given as the swift-cardano-core value, not as text:
///
/// ```swift
/// let item = ExplorerItem.pool(try PoolOperator(from: "pool1…"))
/// ```
public enum ExplorerItem: Sendable, CustomStringConvertible {
    /// A transaction, by its id.
    case transaction(TransactionId)
    /// A payment address.
    case address(Address)
    /// The stake account of an address with a stake part, or of a stake address.
    case account(Address)
    /// A block, by number or body hash.
    case block(BlockNumberOrBodyHash)
    /// An epoch, by number.
    case epoch(EpochNumber)
    /// A stake pool.
    case pool(PoolOperator)
    /// A delegated representative.
    case drep(DRep)
    /// A governance action.
    case governanceAction(GovActionID)
    /// A constitutional committee member, by cold credential.
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

    /// What kind of item it is, in words, as in "a transaction".
    public var description: String { kind.rawValue }

    /// The kinds of item, without their values: for asking which explorers
    /// have pages for something. The raw value names the kind in words.
    public enum Kind: String, CaseIterable, Sendable {
        /// Transactions.
        case transaction = "a transaction"
        /// Payment addresses.
        case address = "an address"
        /// Stake accounts.
        case account = "a stake account"
        /// Blocks.
        case block = "a block"
        /// Epochs.
        case epoch = "an epoch"
        /// Stake pools.
        case pool = "a stake pool"
        /// Delegated representatives.
        case drep = "a DRep"
        /// Governance actions.
        case governanceAction = "a governance action"
        /// Constitutional committee members.
        case committeeMember = "a committee member"
        /// Minting policies.
        case policy = "a policy"
        /// Native assets.
        case asset = "an asset"
    }
}
