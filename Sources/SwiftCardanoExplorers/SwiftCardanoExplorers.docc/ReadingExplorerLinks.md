# Reading Explorer Links

Turn a pasted explorer link back into what it shows.

## Overview

People copy links from explorers. ``ExplorerLink`` reads one back into its explorer, network and ``ExplorerItem``, so you can accept "a transaction id or an explorer link" in the same field:

```swift
let url = URL(string: "https://preprod.cardanoscan.io/transaction/01e9d18a…")!
if let link = ExplorerLink(url), case .transaction(let id) = link.item {
    fetch(id, on: link.network)  // .preprod
}
```

It reads any link this package makes, from any of the seven explorers and any of their networks. A link that is not to an explorer page, or whose identifier is malformed, gives nil.

### What cannot be read back

A few identifiers do not say everything the item needs:

- **Assets by fingerprint** (Cexplorer, Pool PM): `asset1…` is a hash of the policy and name, and cannot be reversed.
- **Accounts by credential hash** (AdaStat, PoolTool): the hash does not say whether the credential is a key or a script.

These links give nil. Links with `stake1…`, and assets as policy and name in hex, read back in full.
