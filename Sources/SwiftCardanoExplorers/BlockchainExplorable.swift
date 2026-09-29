import Foundation
import SwiftCardanoCore

/// A block explorer on one network: builds links to its pages.
///
/// Conforming types give their name, their site on each network and the kinds
/// of item they have pages for, and implement the `view…` methods for those
/// kinds. The others throw ``ExplorerError/unsupportedItem(explorer:item:)``.
///
/// ```swift
/// struct MyExplorer: BlockchainExplorable {
///     let network: Network
///     let name = "My Explorer"
///     let networkUrls = NetworkURLs(mainnet: URL(string: "https://myexplorer.io")!)
///     let supportedItems: Set<ExplorerItem.Kind> = [.transaction]
///
///     func viewTransaction(transactionId: TransactionId) throws -> URL {
///         try baseURL.appending(path: "tx/\(transactionId.payload.toHex)")
///     }
/// }
/// ```
public protocol BlockchainExplorable: Sendable {
    /// The network the links are for.
    var network: Network { get }
    /// The explorer's name, as people know it.
    var name: String { get }
    /// The explorer's site on each network it covers.
    var networkUrls: NetworkURLs { get }
    /// The kinds of item the explorer has pages for.
    var supportedItems: Set<ExplorerItem.Kind> { get }

    /// The stake account of an address with a stake part, or of a stake address.
    func viewAccount(address: Address) throws -> URL
    func viewAddress(address: Address) throws -> URL
    func viewBlock(block: BlockNumberOrBodyHash) throws -> URL
    func viewEpoch(epoch: EpochNumber) throws -> URL
    func viewPool(pool: PoolOperator) throws -> URL
    func viewTransaction(transactionId: TransactionId) throws -> URL
    func viewDRep(drep: DRep) throws -> URL
    func viewGovernanceAction(govActionID: GovActionID) throws -> URL
    func viewCommitteeMember(committeeColdCredential: CommitteeColdCredential) throws -> URL
    func viewPolicy(policyID: PolicyID) throws -> URL
    func viewAsset(policyID: PolicyID, assetName: AssetName) throws -> URL
}

extension BlockchainExplorable {
    /// The explorer's site on ``network``.
    /// - Throws: ``ExplorerError/unsupportedNetwork(explorer:network:)`` when
    ///   the explorer does not cover it.
    public var baseURL: URL {
        get throws {
            guard let url = networkUrls.url(for: network) else {
                throw ExplorerError.unsupportedNetwork(explorer: name, network: network.description)
            }
            return url
        }
    }

    /// Whether the explorer covers ``network``.
    public var supportsNetwork: Bool { networkUrls.url(for: network) != nil }

    /// Whether the explorer can show `kind` on ``network``.
    public func supports(_ kind: ExplorerItem.Kind) -> Bool {
        supportsNetwork && supportedItems.contains(kind)
    }

    /// The explorer's page for `item`.
    /// - Throws: ``ExplorerError`` when there is none.
    public func url(for item: ExplorerItem) throws -> URL {
        switch item {
        case .transaction(let id): try viewTransaction(transactionId: id)
        case .address(let address): try viewAddress(address: address)
        case .account(let address): try viewAccount(address: address)
        case .block(let block): try viewBlock(block: block)
        case .epoch(let epoch): try viewEpoch(epoch: epoch)
        case .pool(let pool): try viewPool(pool: pool)
        case .drep(let drep): try viewDRep(drep: drep)
        case .governanceAction(let id): try viewGovernanceAction(govActionID: id)
        case .committeeMember(let credential): try viewCommitteeMember(committeeColdCredential: credential)
        case .policy(let policy): try viewPolicy(policyID: policy)
        case .asset(let policy, let name): try viewAsset(policyID: policy, assetName: name)
        }
    }

    /// The explorer's page for `item`, or nil when there is none.
    public func link(for item: ExplorerItem) -> URL? {
        try? url(for: item)
    }

    func unsupported(_ kind: ExplorerItem.Kind) -> ExplorerError {
        .unsupportedItem(explorer: name, item: kind.rawValue)
    }

    public func viewAccount(address: Address) throws -> URL { throw unsupported(.account) }
    public func viewAddress(address: Address) throws -> URL { throw unsupported(.address) }
    public func viewBlock(block: BlockNumberOrBodyHash) throws -> URL { throw unsupported(.block) }
    public func viewEpoch(epoch: EpochNumber) throws -> URL { throw unsupported(.epoch) }
    public func viewPool(pool: PoolOperator) throws -> URL { throw unsupported(.pool) }
    public func viewTransaction(transactionId: TransactionId) throws -> URL { throw unsupported(.transaction) }
    public func viewDRep(drep: DRep) throws -> URL { throw unsupported(.drep) }
    public func viewGovernanceAction(govActionID: GovActionID) throws -> URL { throw unsupported(.governanceAction) }
    public func viewCommitteeMember(committeeColdCredential: CommitteeColdCredential) throws -> URL {
        throw unsupported(.committeeMember)
    }
    public func viewPolicy(policyID: PolicyID) throws -> URL { throw unsupported(.policy) }
    public func viewAsset(policyID: PolicyID, assetName: AssetName) throws -> URL { throw unsupported(.asset) }

    /// `baseURL` with `components` appended as path segments.
    func page(_ components: String...) throws -> URL {
        components.reduce(try baseURL) { $0.appendingPathComponent($1) }
    }

    /// An address in bech32.
    func bech32(_ address: Address) throws -> String {
        do {
            return try address.toBech32()
        } catch {
            throw ExplorerError.invalidItem("The address could not be written in bech32.")
        }
    }

    /// The stake address of an address with a stake part, or the address
    /// itself when it is a stake address.
    func stakeAddress(_ address: Address) throws -> Address {
        if address.paymentPart == nil, address.stakingPart != nil { return address }
        guard let staking = address.stakingPart else {
            throw ExplorerError.invalidItem("The address has no stake part, so it has no stake account.")
        }
        do {
            return try Address(stakingPart: staking, network: address.network)
        } catch {
            throw ExplorerError.invalidItem("The address's stake account could not be written.")
        }
    }
}
