# SwiftCardanoExplorers

[![Swift](https://github.com/Kingpin-Apps/swift-cardano-explorers/actions/workflows/swift.yml/badge.svg)](https://github.com/Kingpin-Apps/swift-cardano-explorers/actions/workflows/swift.yml)

Link transactions, addresses, stake accounts, pools, governance and native assets to Cardano block explorers — every explorer listed at [explorer.cardano.org](https://explorer.cardano.org), on the networks each one covers.

```swift
import SwiftCardanoExplorers

let explorer = BlockchainExplorer.cexplorer
if let url = explorer.link(for: .transaction(txID), on: .preprod) {
    openURL(url)  // https://preprod.cexplorer.io/tx/…
}
```

- **Seven explorers:** AdaStat, Cardanoscan, Cexplorer, DRepTalk, eUTxO, Pool PM and PoolTool.
- **Eleven kinds of page:** transactions, addresses, stake accounts, blocks, epochs, pools, DReps, governance actions, committee members, policies and assets.
- **The right identifier for each site:** blocks by number or hash, pools as `pool1…` or hex, governance actions as `gov_action1…`, `txhash#index` or hex, assets by CIP-14 fingerprint or policy and name — each written the way that explorer takes it.
- **Made for a setting:** `CaseIterable`, `Codable` by a stable string, with names, summaries and the networks each covers.
- **Reads links back:** turn a pasted explorer link into its explorer, network and item.
- **Nothing fetched:** it only builds URLs, so it works offline, on iOS, macOS, visionOS, watchOS and tvOS.

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/Kingpin-Apps/swift-cardano-explorers.git", from: "0.1.0"),
],
targets: [
    .target(name: "MyApp", dependencies: [
        .product(name: "SwiftCardanoExplorers", package: "swift-cardano-explorers"),
    ]),
]
```

It depends only on [swift-cardano-core](https://github.com/Kingpin-Apps/swift-cardano-core) (0.5.0 or later) and [swift-nacl](https://github.com/Kingpin-Apps/swift-nacl).

## Explorers

| Explorer | Mainnet | Preprod | Preview | Pages |
|---|:-:|:-:|:-:|---|
| [AdaStat](https://adastat.net) | ✓ | | | everything but committee members |
| [Cardanoscan](https://cardanoscan.io) | ✓ | ✓ | ✓ | everything |
| [Cexplorer](https://cexplorer.io) | ✓ | ✓ | ✓ | everything |
| [DRepTalk](https://dreptalk.com) | ✓ | ✓ | | DReps, governance actions |
| [eUTxO](https://eutxo.org) | ✓ | | | transactions, blocks |
| [Pool PM](https://pool.pm) | ✓ | | | addresses, accounts, pools, DReps, policies, assets |
| [PoolTool](https://pooltool.io) | ✓ | | | accounts, pools |

The URL each explorer gets for each kind of page is in the [Explorer Coverage](https://swiftpackageindex.com/Kingpin-Apps/swift-cardano-explorers/documentation/swiftcardanoexplorers/explorercoverage) article. Every format was checked against the live sites with real mainnet items.

## Usage

### Linking

Give an `ExplorerItem`, as a swift-cardano-core value, and a network:

```swift
import SwiftCardanoCore
import SwiftCardanoExplorers

let pool = ExplorerItem.pool(try PoolOperator(from: "pool1…"))

BlockchainExplorer.cardanoScan.link(for: pool, on: .mainnet)  // https://cardanoscan.io/pool/pool1…
BlockchainExplorer.poolTool.link(for: pool, on: .mainnet)     // https://pooltool.io/pool/<hex>
BlockchainExplorer.poolTool.link(for: pool, on: .preview)     // nil: PoolTool is mainnet only
```

`link(for:on:)` returns nil where there is no page. `url(for:on:)` throws an `ExplorerError` that says why:

```swift
try BlockchainExplorer.cexplorer.url(for: .block(.number(14_003_180)), on: .mainnet)
// ExplorerError: Cexplorer links blocks by hash, not number.
```

The items:

```swift
.transaction(TransactionId)
.address(Address)
.account(Address)              // a stake address, or any address with a stake part
.block(.number(n)), .block(.bodyHash(hash))
.epoch(EpochNumber)
.pool(PoolOperator)
.drep(DRep)                    // written as CIP-129, drep1y…
.governanceAction(GovActionID)
.committeeMember(CommitteeColdCredential)
.policy(PolicyID)
.asset(policy: PolicyID, name: AssetName)
```

### A setting, with a fallback

```swift
struct ExplorerSetting: View {
    @AppStorage("blockchainExplorer") private var explorer = BlockchainExplorer.cexplorer

    var body: some View {
        Picker("Explorer", selection: $explorer) {
            ForEach(BlockchainExplorer.allCases) { Text($0.name).tag($0) }
        }
    }
}
```

Not every explorer has every page on every network, so fall back to one that does, and say which:

```swift
func opening(_ item: ExplorerItem, on network: Network, preferring chosen: BlockchainExplorer)
    -> (BlockchainExplorer, URL)?
{
    for explorer in [chosen, .cardanoScan, .cexplorer] {
        if let url = explorer.link(for: item, on: network) { return (explorer, url) }
    }
    return nil
}

BlockchainExplorer.supporting(.drep, on: .preprod)  // [.cardanoScan, .cexplorer, .drepTalk]
```

### Reading a pasted link

```swift
if let link = ExplorerLink(URL(string: "https://preprod.cardanoscan.io/transaction/01e9…")!),
   case .transaction(let id) = link.item {
    fetch(id, on: link.network)  // .preprod
}
```

Assets linked by fingerprint, and accounts linked by credential hash, cannot be read back: neither says everything the item needs.

### Asset fingerprints

```swift
try assetName.fingerprint(policy: policyID)  // "asset1…", per CIP-14
```

### Your own explorer

Conform a type to `BlockchainExplorable`, give its name, sites and supported kinds, and write the `view…` methods it has; the rest throw `unsupportedItem`:

```swift
struct MyExplorer: BlockchainExplorable {
    let network: Network
    let name = "My Explorer"
    let networkUrls = NetworkURLs(mainnet: URL(string: "https://myexplorer.io")!)
    let supportedItems: Set<ExplorerItem.Kind> = [.transaction]

    func viewTransaction(transactionId: TransactionId) throws -> URL {
        try baseURL.appendingPathComponent("tx").appendingPathComponent(transactionId.payload.toHex)
    }
}
```

## Documentation

The full documentation, with articles on getting started, choosing an explorer, coverage, reading links and adding explorers, is on the [Swift Package Index](https://swiftpackageindex.com/Kingpin-Apps/swift-cardano-explorers/documentation/swiftcardanoexplorers). To build it locally, use Xcode's **Product › Build Documentation**.

## Contributing

To add an explorer, add its type under `Sources/SwiftCardanoExplorers/Explorers/`, a case to `BlockchainExplorer`, and golden URLs to the tests: real mainnet items whose links you have opened and seen the right page. The tests check that every explorer links each kind it claims and no other, and that every link reads back through `ExplorerLink`.

```bash
swift test
```

## License

MIT. See [LICENSE](LICENSE).
