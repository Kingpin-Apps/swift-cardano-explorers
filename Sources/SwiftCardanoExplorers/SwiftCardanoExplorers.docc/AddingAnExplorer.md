# Adding an Explorer

Link to an explorer that is not built in.

## Overview

Each built-in explorer is a type conforming to ``BlockchainExplorable``. Your own can conform too, and be used anywhere the built-in ones are:

```swift
import SwiftCardanoCore
import SwiftCardanoExplorers

struct MyExplorer: BlockchainExplorable {
    let network: Network
    let name = "My Explorer"
    let networkUrls = NetworkURLs(
        mainnet: URL(string: "https://myexplorer.io")!,
        preview: URL(string: "https://preview.myexplorer.io")!
    )
    let supportedItems: Set<ExplorerItem.Kind> = [.transaction, .address]

    func viewTransaction(transactionId: TransactionId) throws -> URL {
        try baseURL.appendingPathComponent("tx").appendingPathComponent(transactionId.payload.toHex)
    }

    func viewAddress(address: Address) throws -> URL {
        try baseURL.appendingPathComponent("address").appendingPathComponent(address.toBech32())
    }
}

MyExplorer(network: .preview).link(for: .transaction(id))  // https://preview.myexplorer.io/tx/…
MyExplorer(network: .preprod).link(for: .transaction(id))  // nil: no preprod site
```

- ``BlockchainExplorable/baseURL`` is the site on the explorer's network, and throws when it has none.
- Every `view…` method you do not write throws ``ExplorerError/unsupportedItem(explorer:item:)``.
- Keep ``BlockchainExplorable/supportedItems`` to the kinds you implement, so ``BlockchainExplorable/supports(_:)`` answers truthfully before anyone asks for a link.

### Adding one to the package

To add an explorer to ``BlockchainExplorer`` for everyone, add its type under `Explorers/`, a case to the enum, and golden URLs to the tests: real mainnet items whose links you have opened and seen the right page. The package's own tests check that every explorer links each kind it claims and no other, and that every link reads back through ``ExplorerLink``.
