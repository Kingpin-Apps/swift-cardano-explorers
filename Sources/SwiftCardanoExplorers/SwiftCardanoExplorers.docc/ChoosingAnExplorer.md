# Choosing an Explorer

Let people pick their explorer, and fall back gracefully when it has no page.

## Overview

``BlockchainExplorer`` is made to be a setting. It is `CaseIterable` for a picker, `Codable` and `RawRepresentable` by a stable string (`"cexplorer"`, `"cardanoscan"`, …) for storage, and each case has a ``BlockchainExplorer/name``, a ``BlockchainExplorer/summary`` and the ``BlockchainExplorer/networks`` it covers.

### A SwiftUI setting

```swift
import SwiftCardanoExplorers
import SwiftUI

struct ExplorerSetting: View {
    @AppStorage("blockchainExplorer") private var explorer = BlockchainExplorer.cexplorer

    var body: some View {
        Picker("Explorer", selection: $explorer) {
            ForEach(BlockchainExplorer.allCases) { explorer in
                Text(explorer.name).tag(explorer)
            }
        }
    }
}
```

### Falling back

Not every explorer covers every network or every kind of page. PoolTool has pools and accounts only; DRepTalk has DReps and governance actions only; four explorers are mainnet only. A link that silently disappears when someone picks PoolTool is confusing, so fall back to an explorer that has the page, and say which:

```swift
func opening(_ item: ExplorerItem, on network: Network, preferring chosen: BlockchainExplorer)
    -> (BlockchainExplorer, URL)?
{
    for explorer in [chosen, .cardanoScan, .cexplorer] {
        if let url = explorer.link(for: item, on: network) { return (explorer, url) }
    }
    return nil
}

if let (explorer, url) = opening(.transaction(id), on: .preview, preferring: chosen) {
    Link("Open in \(explorer.name)", destination: url)
}
```

Cardanoscan and Cexplorer cover every kind of page on mainnet, preprod and preview, so they make good fallbacks. On a network no explorer covers — a local devnet, SanchoNet or a custom network — there is no link at all.

### Explorers that only work for some items

DRepTalk has a page only for DReps who have made a DRepTalk profile; for others its link opens a "not found" page. If DReps matter to you, prefer Cardanoscan or Cexplorer for them.
