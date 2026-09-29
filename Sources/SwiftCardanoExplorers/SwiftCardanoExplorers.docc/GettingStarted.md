# Getting Started

Add the package and link your first transaction.

## Overview

### Add the package

In `Package.swift`:

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

It works with swift-cardano-core 0.5.0 and later.

### Describe what to show

An ``ExplorerItem`` is the thing a page shows, as a swift-cardano-core value:

```swift
import SwiftCardanoCore
import SwiftCardanoExplorers

let transaction = ExplorerItem.transaction(TransactionId(payload: txHash))
let address = ExplorerItem.address(try Address(from: .string("addr1…")))
let account = ExplorerItem.account(try Address(from: .string("addr1…")))  // its stake account
let pool = ExplorerItem.pool(try PoolOperator(from: "pool1…"))
let drep = ExplorerItem.drep(try DRep(from: "drep1…"))
let action = ExplorerItem.governanceAction(try GovActionID(from: "gov_action1…"))
let asset = ExplorerItem.asset(policy: policyID, name: assetName)
```

An account can be given as a stake address or as any address with a stake part; each explorer writes it as `stake1…` or as the stake credential's hash, whichever it takes.

### Ask an explorer for its page

``BlockchainExplorer/link(for:on:)`` returns the page, or nil when the explorer has none — no site on that network, or no pages for that kind of item:

```swift
BlockchainExplorer.cardanoScan.link(for: transaction, on: .mainnet)
// https://cardanoscan.io/transaction/…

BlockchainExplorer.poolTool.link(for: transaction, on: .mainnet)
// nil: PoolTool has no transaction pages

BlockchainExplorer.adaStat.link(for: transaction, on: .preview)
// nil: AdaStat is mainnet only
```

When you want to know why, use ``BlockchainExplorer/url(for:on:)``, which throws an ``ExplorerError``:

```swift
do {
    let url = try BlockchainExplorer.cexplorer.url(for: .block(.number(14_003_180)), on: .mainnet)
} catch {
    print(error)  // Cexplorer links blocks by hash, not number.
}
```

### Ask before you show a button

To show a link only when there is a page, check first:

```swift
if BlockchainExplorer.eutxo.supports(.address, on: .mainnet) { … }  // false
BlockchainExplorer.supporting(.drep, on: .preprod)  // [.cardanoScan, .cexplorer, .drepTalk]
```
