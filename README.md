# SwiftCardanoExplorers

Links to Cardano block explorers, for every explorer listed at [explorer.cardano.org](https://explorer.cardano.org): pick an explorer, give it a transaction, address, stake account, block, epoch, pool, DRep, governance action, committee member, policy or asset, and get the page for it on mainnet, preprod or preview.

It only builds URLs, so it runs everywhere Swift does, iOS and visionOS included, and depends only on [swift-cardano-core](https://github.com/Kingpin-Apps/swift-cardano-core).

## Explorers

| Explorer | Networks | Pages |
|---|---|---|
| [AdaStat](https://adastat.net) | mainnet | transaction, address, account, block, epoch, pool, DRep, governance action, policy, asset |
| [Cardanoscan](https://cardanoscan.io) | mainnet, preprod, preview | all |
| [Cexplorer](https://cexplorer.io) | mainnet, preprod, preview | all |
| [DRepTalk](https://dreptalk.com) | mainnet, preprod | DRep, governance action |
| [eUTxO](https://eutxo.org) | mainnet | transaction, block |
| [Pool PM](https://pool.pm) | mainnet | address, account, pool, DRep, policy, asset |
| [PoolTool](https://pooltool.io) | mainnet | account, pool |

Each explorer takes identifiers in its own form — blocks by number or hash, pools as `pool1…` or hex, governance actions as `gov_action1…`, `txhash#index` or hex, assets by CIP-14 fingerprint or hex. The package writes each one the way that explorer's site expects.

## Usage

```swift
.package(url: "https://github.com/Kingpin-Apps/swift-cardano-explorers.git", from: "0.1.0")
```

```swift
import SwiftCardanoExplorers

// A setting: Codable, CaseIterable, with a name and the networks it covers.
let explorer = BlockchainExplorer.cexplorer

// nil when the explorer has no such page on that network.
if let url = explorer.link(for: .transaction(txID), on: .preprod) {
    openURL(url)
}

// Or throwing, to say why not.
let url = try explorer.url(for: .governanceAction(actionID), on: .mainnet)

// Which explorers can show something.
BlockchainExplorer.supporting(.drep, on: .preprod)  // [.cardanoScan, .cexplorer, .drepTalk]

// Read a pasted explorer link back.
if let link = ExplorerLink(pastedURL), case .transaction(let id) = link.item {
    fetch(id, on: link.network)
}
```

Each explorer is also a type conforming to `BlockchainExplorable` (`Cexplorer(network: .preview).viewPool(pool:)`), for adding explorers of your own.

## License

MIT
