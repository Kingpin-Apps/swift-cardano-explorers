import Foundation
import SwiftCardanoCore

/// A link to an explorer page, read back: which explorer, which network, and
/// what the page shows.
///
/// ```swift
/// let link = ExplorerLink(URL(string: "https://preprod.cexplorer.io/tx/01e9…")!)
/// link?.explorer  // .cexplorer
/// link?.network   // .preprod
/// link?.item      // .transaction(…)
/// ```
///
/// Only links this package could have made are read. Some cannot be read back
/// to an item: an asset by fingerprint, or an account by its stake key hash,
/// which does not say whether it is a key or a script. Those give nil.
public struct ExplorerLink: Sendable {
    public let explorer: BlockchainExplorer
    public let network: Network
    public let item: ExplorerItem

    public init?(_ url: URL) {
        guard let host = url.host()?.lowercased() else { return nil }
        let site = BlockchainExplorer.allCases.lazy.flatMap { explorer in
            explorer.networks.map { (explorer, $0) }
        }.first { explorer, network in
            explorer.explorer(network: network).networkUrls.url(for: network)?.host()?.lowercased() == host
        }
        guard let (explorer, network) = site else { return nil }
        let segments = url.path(percentEncoded: false).split(separator: "/").map(String.init)
        guard let id = segments.last,
            let item = Self.item(route: segments.dropLast().joined(separator: "/"), id: id, explorer: explorer, network: network)
        else { return nil }
        self.explorer = explorer
        self.network = network
        self.item = item
    }

    /// The kind of page each explorer's routes show.
    static let routes: [BlockchainExplorer: [String: ExplorerItem.Kind]] = [
        .cardanoScan: [
            "transaction": .transaction, "address": .address, "stakekey": .account, "block": .block,
            "epoch": .epoch, "pool": .pool, "drep": .drep, "govaction": .governanceAction,
            "ccmember": .committeeMember, "tokenpolicy": .policy, "token": .asset,
        ],
        .cexplorer: [
            "tx": .transaction, "address": .address, "stake": .account, "block": .block, "epoch": .epoch,
            "pool": .pool, "drep": .drep, "gov/action": .governanceAction, "gov/cc": .committeeMember,
            "policy": .policy, "asset": .asset,
        ],
        .adaStat: [
            "transactions": .transaction, "addresses": .address, "accounts": .account, "blocks": .block,
            "epochs": .epoch, "pools": .pool, "dreps": .drep, "governances": .governanceAction,
            "policies": .policy, "tokens": .asset,
        ],
        .eutxo: ["transaction": .transaction, "block": .block],
        .poolTool: ["address": .account, "pool": .pool],
        .poolPM: ["policy": .policy],
        .drepTalk: ["dreps": .drep, "t": .governanceAction],
    ]

    static func item(route: String, id: String, explorer: BlockchainExplorer, network: Network) -> ExplorerItem? {
        let kind: ExplorerItem.Kind? = if route.isEmpty && explorer == .poolPM {
            // Pool PM puts its pages at the root; the id's prefix says what it is.
            kindOfBech32(id)
        } else {
            routes[explorer]?[route.lowercased()]
        }
        guard let kind else { return nil }
        return item(kind, id: id, network: network)
    }

    static func kindOfBech32(_ id: String) -> ExplorerItem.Kind? {
        if id.hasPrefix("addr") { return .address }
        if id.hasPrefix("stake") { return .account }
        if id.hasPrefix("pool1") { return .pool }
        if id.hasPrefix("drep") { return .drep }
        return nil
    }

    static func item(_ kind: ExplorerItem.Kind, id: String, network: Network) -> ExplorerItem? {
        switch kind {
        case .transaction:
            return hexBytes(id, count: 32).map { .transaction(TransactionId(payload: $0)) }
        case .address:
            guard let address = try? Address(from: .string(id)) else { return nil }
            return .address(address)
        case .account:
            guard id.hasPrefix("stake"), let address = try? Address(from: .string(id)) else { return nil }
            return .account(address)
        case .block:
            if let number = BlockNumber(id) { return .block(.number(number)) }
            return hexBytes(id, count: 32).map { .block(.bodyHash(BlockBodyHash(payload: $0))) }
        case .epoch:
            return EpochNumber(id).map { .epoch($0) }
        case .pool:
            if let pool = try? PoolOperator(from: id) { return .pool(pool) }
            return hexBytes(id, count: 28).flatMap { try? PoolOperator(from: $0) }.map { .pool($0) }
        case .drep:
            return (try? DRep(from: id)).map { .drep($0) }
        case .governanceAction:
            return governanceAction(id).map { .governanceAction($0) }
        case .committeeMember:
            return (try? CommitteeColdCredential(from: id)).map { .committeeMember($0) }
        case .policy:
            return hexBytes(id, count: 28).map { .policy(PolicyID(payload: $0)) }
        case .asset:
            guard let bytes = hexBytes(id), bytes.count >= 28, bytes.count <= 60 else { return nil }
            guard let name = try? AssetName(payload: Data(bytes.dropFirst(28))) else { return nil }
            return .asset(policy: PolicyID(payload: Data(bytes.prefix(28))), name: name)
        }
    }

    /// A governance action id as `gov_action1…`, `txhash#index`, or the
    /// transaction id followed by a one-byte index, in hex.
    static func governanceAction(_ id: String) -> GovActionID? {
        if let action = try? GovActionID(from: id) { return action }
        let parts = id.split(separator: "#")
        if parts.count == 2, let hash = hexBytes(String(parts[0]), count: 32), let index = UInt16(parts[1]) {
            return GovActionID(transactionID: TransactionId(payload: hash), govActionIndex: index)
        }
        if let bytes = hexBytes(id, count: 33) {
            return GovActionID(transactionID: TransactionId(payload: bytes.prefix(32)), govActionIndex: UInt16(bytes[32]))
        }
        return nil
    }

    static func hexBytes(_ text: String, count: Int? = nil) -> Data? {
        guard text.count % 2 == 0, text.allSatisfy(\.isHexDigit), let data = Data(hexString: text) else { return nil }
        if let count, data.count != count { return nil }
        return data
    }
}
