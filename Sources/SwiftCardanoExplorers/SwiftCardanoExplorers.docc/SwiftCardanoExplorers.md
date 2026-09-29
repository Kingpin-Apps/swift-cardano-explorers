# ``SwiftCardanoExplorers``

Links to Cardano block explorers.

## Overview

``BlockchainExplorer`` lists the community explorers at [explorer.cardano.org](https://explorer.cardano.org). Give one an ``ExplorerItem`` and a network, and it returns the page for it, or nil when it has none:

```swift
let url = BlockchainExplorer.cardanoScan.link(for: .pool(pool), on: .mainnet)
```

Explorers differ in the networks they cover, the pages they have and the form they want each identifier in. Each is a type conforming to ``BlockchainExplorable`` that knows its own.

``ExplorerLink`` reads a link back: which explorer, which network, and what it shows.

## Topics

### Explorers

- ``BlockchainExplorer``
- ``BlockchainExplorable``
- ``AdaStat``
- ``CardanoScan``
- ``Cexplorer``
- ``DRepTalk``
- ``Eutxo``
- ``PoolPM``
- ``PoolTool``

### Items

- ``ExplorerItem``
- ``BlockNumberOrBodyHash``

### Reading links

- ``ExplorerLink``

### Errors

- ``ExplorerError``
- ``NetworkURLs``
