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
    case adaStat = "adastat"
    case cardanoScan = "cardanoscan"
    case cexplorer = "cexplorer"
    case drepTalk = "dreptalk"
    case eutxo = "eutxo"
    case poolPM = "poolpm"
    case poolTool = "pooltool"

    public var id: String { rawValue }

    /// The explorer on `network`.
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

    public var description: String { name }

    /// Whether the explorer covers `network`.
    public func supports(_ network: Network) -> Bool {
        explorer(network: network).supportsNetwork
    }

    /// Whether the explorer has a page for `kind` on `network`.
    public func supports(_ kind: ExplorerItem.Kind, on network: Network) -> Bool {
        explorer(network: network).supports(kind)
    }

    /// The explorer's page for `item` on `network`.
    /// - Throws: ``ExplorerError`` when there is none.
    public func url(for item: ExplorerItem, on network: Network) throws -> URL {
        try explorer(network: network).url(for: item)
    }

    /// The explorer's page for `item` on `network`, or nil when there is none.
    public func link(for item: ExplorerItem, on network: Network) -> URL? {
        explorer(network: network).link(for: item)
    }

    /// The explorers with a page for `kind` on `network`.
    public static func supporting(_ kind: ExplorerItem.Kind, on network: Network) -> [BlockchainExplorer] {
        allCases.filter { $0.supports(kind, on: network) }
    }
}
