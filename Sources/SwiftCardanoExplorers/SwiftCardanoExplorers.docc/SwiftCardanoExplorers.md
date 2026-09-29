# ``SwiftCardanoExplorers``

Link transactions, addresses, pools, governance and assets to Cardano block explorers.

## Overview

A wallet, a dApp or a developer tool often wants a "View on explorer" link, and people have their favourite explorer. SwiftCardanoExplorers gives you the seven community explorers listed at [explorer.cardano.org](https://explorer.cardano.org), each knowing the networks it covers, the pages it has, and the form it wants each identifier in:

```swift
import SwiftCardanoExplorers

let explorer = BlockchainExplorer.cexplorer
if let url = explorer.link(for: .transaction(txID), on: .preprod) {
    openURL(url)  // https://preprod.cexplorer.io/tx/…
}
```

Give it swift-cardano-core values — a `TransactionId`, an `Address`, a `PoolOperator`, a `DRep`, a `GovActionID` — and it writes them the way each site expects: blocks by number or hash, pools as `pool1…` or hex, governance actions as `gov_action1…`, `txhash#index` or hex, assets by CIP-14 fingerprint or by policy and name.

It only builds URLs. Nothing is fetched, so it works offline on every Apple platform, and it depends on nothing but swift-cardano-core and SwiftNaCl.

| Explorer | Networks | Best for |
|---|---|---|
| ``AdaStat`` | mainnet | Statistics and network monitoring |
| ``CardanoScan`` | mainnet, preprod, preview | Everything |
| ``Cexplorer`` | mainnet, preprod, preview | Everything, with analytics |
| ``DRepTalk`` | mainnet, preprod | Governance discussion and DRep profiles |
| ``Eutxo`` | mainnet | Transactions and blocks, drawn |
| ``PoolPM`` | mainnet | Wallets, pools and NFTs |
| ``PoolTool`` | mainnet | Stake pool performance |

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:ChoosingAnExplorer>
- ``BlockchainExplorer``
- ``ExplorerItem``

### Explorers

- <doc:ExplorerCoverage>
- ``AdaStat``
- ``CardanoScan``
- ``Cexplorer``
- ``DRepTalk``
- ``Eutxo``
- ``PoolPM``
- ``PoolTool``

### Reading links

- <doc:ReadingExplorerLinks>
- ``ExplorerLink``

### Adding explorers

- <doc:AddingAnExplorer>
- ``BlockchainExplorable``
- ``NetworkURLs``

### Items and errors

- ``BlockNumberOrBodyHash``
- ``ExplorerError``
