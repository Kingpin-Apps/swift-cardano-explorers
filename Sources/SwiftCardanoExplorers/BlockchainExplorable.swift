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
///         try baseURL.appendingPathComponent("tx").appendingPathComponent(transactionId.payload.toHex)
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

    /// The page for a stake account.
    /// - Parameter address: A stake address, or any address with a stake part.
    /// - Returns: The account's page.
    /// - Throws: ``ExplorerError`` when the explorer has no account pages or no site on
    ///   ``network``, or the address has no stake part.
    func viewAccount(address: Address) throws -> URL

    /// The page for an address.
    /// - Parameter address: A payment address.
    /// - Returns: The address's page.
    /// - Throws: ``ExplorerError`` when the explorer has no address pages or no site on ``network``.
    func viewAddress(address: Address) throws -> URL

    /// The page for a block.
    /// - Parameter block: The block, by number or body hash. Some explorers take only one.
    /// - Returns: The block's page.
    /// - Throws: ``ExplorerError`` when the explorer has no block pages, no site on ``network``,
    ///   or does not take the block in the form given.
    func viewBlock(block: BlockNumberOrBodyHash) throws -> URL

    /// The page for an epoch.
    /// - Parameter epoch: The epoch number.
    /// - Returns: The epoch's page.
    /// - Throws: ``ExplorerError`` when the explorer has no epoch pages or no site on ``network``.
    func viewEpoch(epoch: EpochNumber) throws -> URL

    /// The page for a stake pool.
    /// - Parameter pool: The pool.
    /// - Returns: The pool's page.
    /// - Throws: ``ExplorerError`` when the explorer has no pool pages or no site on ``network``.
    func viewPool(pool: PoolOperator) throws -> URL

    /// The page for a transaction.
    /// - Parameter transactionId: The transaction's id.
    /// - Returns: The transaction's page.
    /// - Throws: ``ExplorerError`` when the explorer has no transaction pages or no site on ``network``.
    func viewTransaction(transactionId: TransactionId) throws -> URL

    /// The page for a delegated representative.
    /// - Parameter drep: The DRep. It is written as its CIP-129 id, `drep1…`, the one form
    ///   every explorer takes.
    /// - Returns: The DRep's page.
    /// - Throws: ``ExplorerError`` when the explorer has no DRep pages or no site on ``network``.
    func viewDRep(drep: DRep) throws -> URL

    /// The page for a governance action.
    /// - Parameter govActionID: The action's id: the transaction that proposed it and its index.
    /// - Returns: The action's page.
    /// - Throws: ``ExplorerError`` when the explorer has no governance pages or no site on ``network``.
    func viewGovernanceAction(govActionID: GovActionID) throws -> URL

    /// The page for a constitutional committee member.
    /// - Parameter committeeColdCredential: The member's cold credential.
    /// - Returns: The member's page.
    /// - Throws: ``ExplorerError`` when the explorer has no committee pages or no site on ``network``.
    func viewCommitteeMember(committeeColdCredential: CommitteeColdCredential) throws -> URL

    /// The page for a minting policy and the assets under it.
    /// - Parameter policyID: The policy id.
    /// - Returns: The policy's page.
    /// - Throws: ``ExplorerError`` when the explorer has no policy pages or no site on ``network``.
    func viewPolicy(policyID: PolicyID) throws -> URL

    /// The page for one native asset.
    /// - Parameters:
    ///   - policyID: The asset's policy id.
    ///   - assetName: The asset's name under the policy.
    /// - Returns: The asset's page.
    /// - Throws: ``ExplorerError`` when the explorer has no asset pages or no site on ``network``.
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
    /// - Parameter kind: A kind of item.
    /// - Returns: Whether the explorer has a site on ``network`` and pages for `kind`.
    public func supports(_ kind: ExplorerItem.Kind) -> Bool {
        supportsNetwork && supportedItems.contains(kind)
    }

    /// The explorer's page for `item`.
    ///
    /// Calls the `view…` method for the item's kind.
    ///
    /// - Parameter item: What to show.
    /// - Returns: The page for it.
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
    ///
    /// Use it where a missing page should simply mean no link:
    ///
    /// ```swift
    /// if let url = Cexplorer(network: .preview).link(for: .transaction(id)) {
    ///     openURL(url)
    /// }
    /// ```
    ///
    /// - Parameter item: What to show.
    /// - Returns: The page for it, or nil.
    public func link(for item: ExplorerItem) -> URL? {
        try? url(for: item)
    }

    func unsupported(_ kind: ExplorerItem.Kind) -> ExplorerError {
        .unsupportedItem(explorer: name, item: kind.rawValue)
    }

    /// Throws ``ExplorerError/unsupportedItem(explorer:item:)``: by default an explorer has no
    /// account pages.
    public func viewAccount(address: Address) throws -> URL { throw unsupported(.account) }
    /// Throws ``ExplorerError/unsupportedItem(explorer:item:)``: by default an explorer has no
    /// address pages.
    public func viewAddress(address: Address) throws -> URL { throw unsupported(.address) }
    /// Throws ``ExplorerError/unsupportedItem(explorer:item:)``: by default an explorer has no
    /// block pages.
    public func viewBlock(block: BlockNumberOrBodyHash) throws -> URL { throw unsupported(.block) }
    /// Throws ``ExplorerError/unsupportedItem(explorer:item:)``: by default an explorer has no
    /// epoch pages.
    public func viewEpoch(epoch: EpochNumber) throws -> URL { throw unsupported(.epoch) }
    /// Throws ``ExplorerError/unsupportedItem(explorer:item:)``: by default an explorer has no
    /// pool pages.
    public func viewPool(pool: PoolOperator) throws -> URL { throw unsupported(.pool) }
    /// Throws ``ExplorerError/unsupportedItem(explorer:item:)``: by default an explorer has no
    /// transaction pages.
    public func viewTransaction(transactionId: TransactionId) throws -> URL { throw unsupported(.transaction) }
    /// Throws ``ExplorerError/unsupportedItem(explorer:item:)``: by default an explorer has no
    /// DRep pages.
    public func viewDRep(drep: DRep) throws -> URL { throw unsupported(.drep) }
    /// Throws ``ExplorerError/unsupportedItem(explorer:item:)``: by default an explorer has no
    /// governance action pages.
    public func viewGovernanceAction(govActionID: GovActionID) throws -> URL { throw unsupported(.governanceAction) }
    /// Throws ``ExplorerError/unsupportedItem(explorer:item:)``: by default an explorer has no
    /// committee member pages.
    public func viewCommitteeMember(committeeColdCredential: CommitteeColdCredential) throws -> URL {
        throw unsupported(.committeeMember)
    }
    /// Throws ``ExplorerError/unsupportedItem(explorer:item:)``: by default an explorer has no
    /// policy pages.
    public func viewPolicy(policyID: PolicyID) throws -> URL { throw unsupported(.policy) }
    /// Throws ``ExplorerError/unsupportedItem(explorer:item:)``: by default an explorer has no
    /// asset pages.
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
