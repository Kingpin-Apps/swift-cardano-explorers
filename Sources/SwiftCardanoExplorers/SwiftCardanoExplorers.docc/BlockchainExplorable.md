# ``SwiftCardanoExplorers/BlockchainExplorable``

A block explorer on one network: builds links to its pages.

## Topics

### Describing the explorer

- ``name``
- ``network``
- ``networkUrls``
- ``supportedItems``
- ``baseURL``

### Linking to any item

- ``link(for:)``
- ``url(for:)``
- ``supports(_:)``
- ``supportsNetwork``

### Linking to each kind of item

- ``viewTransaction(transactionId:)``
- ``viewAddress(address:)``
- ``viewAccount(address:)``
- ``viewBlock(block:)``
- ``viewEpoch(epoch:)``
- ``viewPool(pool:)``
- ``viewDRep(drep:)``
- ``viewGovernanceAction(govActionID:)``
- ``viewCommitteeMember(committeeColdCredential:)``
- ``viewPolicy(policyID:)``
- ``viewAsset(policyID:assetName:)``
