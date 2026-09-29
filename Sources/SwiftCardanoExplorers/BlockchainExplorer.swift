import Foundation
import SwiftCardanoCore

/// The explorers this package links to: the community explorers listed at
/// [explorer.cardano.org](https://explorer.cardano.org).
///
/// Use it for a setting: it is `Codable` by a stable raw value, and each case
/// has a name, a website and the networks it covers.
///
/// ```swift
/// let explorer = BlockchainExplorer.cexplorer
/// if let url = explorer.link(for: .transaction(id), on: .preprod) { open(url) }
/// ```
public enum BlockchainExplorer: String, Codable, CaseIterable, Identifiable, CustomStringConvertible, Sendable {
    /// [AdaStat](https://adastat.net): see ``AdaStat``.
    case adaStat = "adastat"
    /// [Cardanoscan](https://cardanoscan.io): see ``CardanoScan``.
    case cardanoScan = "cardanoscan"
    /// [Cexplorer](https://cexplorer.io): see ``Cexplorer``.
    case cexplorer = "cexplorer"
    /// [DRepTalk](https://dreptalk.com): see ``DRepTalk``.
    case drepTalk = "dreptalk"
    /// [eUTxO](https://eutxo.org): see ``Eutxo``.
    case eutxo = "eutxo"
    /// [Pool PM](https://pool.pm): see ``PoolPM``.
    case poolPM = "poolpm"
    /// [PoolTool](https://pooltool.io): see ``PoolTool``.
    case poolTool = "pooltool"

    /// The raw value, which is stable across versions and safe to store.
    public var id: String { rawValue }

    /// The explorer on `network`.
    /// - Parameter network: The network the links are for.
    /// - Returns: The explorer's type, such as ``Cexplorer``, for that network.
    public func explorer(network: Network) -> any BlockchainExplorable {
        switch self {
        case .adaStat: AdaStat(network: network)
        case .cardanoScan: CardanoScan(network: network)
        case .cexplorer: Cexplorer(network: network)
        case .drepTalk: DRepTalk(network: network)
        case .eutxo: Eutxo(network: network)
        case .poolPM: PoolPM(network: network)
        case .poolTool: PoolTool(network: network)
        }
    }

    /// The explorer's name, as people know it.
    public var name: String { explorer(network: .mainnet).name }

    /// The explorer's mainnet site.
    public var website: URL { explorer(network: .mainnet).networkUrls.mainnet }

    /// The networks the explorer covers.
    public var networks: [Network] { explorer(network: .mainnet).networkUrls.networks }

    /// The kinds of item the explorer has pages for.
    public var supportedItems: Set<ExplorerItem.Kind> { explorer(network: .mainnet).supportedItems }

    /// What the explorer is best at.
    public var summary: String {
        switch self {
        case .adaStat: "Statistics and network monitoring."
        case .cardanoScan: "A full explorer: transactions, accounts, pools, governance and tokens."
        case .cexplorer: "A full explorer with analytics: transactions, accounts, pools, governance and assets."
        case .drepTalk: "Governance: discussion, votes and rationales on actions, and DRep profiles."
        case .eutxo: "Transactions and blocks, drawn as a picture."
        case .poolPM: "Wallets, pools and native assets, NFTs above all."
        case .poolTool: "Stake pool performance, for choosing where to stake."
        }
    }

    /// The explorer's ``name``.
    public var description: String { name }

    /// Whether the explorer covers `network`.
    /// - Parameter network: A network.
    /// - Returns: Whether the explorer has a site for it.
    public func supports(_ network: Network) -> Bool {
        explorer(network: network).supportsNetwork
    }

    /// Whether the explorer has a page for `kind` on `network`.
    /// - Parameters:
    ///   - kind: A kind of item.
    ///   - network: A network.
    /// - Returns: Whether the explorer has a site on `network` and pages for `kind`.
    public func supports(_ kind: ExplorerItem.Kind, on network: Network) -> Bool {
        explorer(network: network).supports(kind)
    }

    /// The explorer's page for `item` on `network`.
    /// - Parameters:
    ///   - item: What to show.
    ///   - network: The network the item is on.
    /// - Returns: The page for it.
    /// - Throws: ``ExplorerError`` when there is none, saying why.
    public func url(for item: ExplorerItem, on network: Network) throws -> URL {
        try explorer(network: network).url(for: item)
    }

    /// The explorer's page for `item` on `network`, or nil when there is none.
    /// - Parameters:
    ///   - item: What to show.
    ///   - network: The network the item is on.
    /// - Returns: The page for it, or nil.
    public func link(for item: ExplorerItem, on network: Network) -> URL? {
        explorer(network: network).link(for: item)
    }

    /// The explorers with a page for `kind` on `network`, in the order of `allCases`.
    ///
    /// Use it to offer another explorer when the chosen one has no page:
    ///
    /// ```swift
    /// let explorers = BlockchainExplorer.supporting(.transaction, on: .preview)
    /// // [.cardanoScan, .cexplorer]
    /// ```
    ///
    /// - Parameters:
    ///   - kind: A kind of item.
    ///   - network: A network.
    /// - Returns: The explorers that can show it.
    public static func supporting(_ kind: ExplorerItem.Kind, on network: Network) -> [BlockchainExplorer] {
        allCases.filter { $0.supports(kind, on: network) }
    }
}
