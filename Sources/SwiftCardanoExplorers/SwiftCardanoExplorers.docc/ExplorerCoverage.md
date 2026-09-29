# Explorer Coverage

The networks each explorer covers, the pages it has, and the URLs it gets.

## Overview

Each explorer's site, and the form of each link, as its site takes it. These were checked against the live sites in September 2026 with real mainnet items; Cardanoscan's against its own pages as archived, since it does not answer automated requests.

### Networks

| Explorer | Mainnet | Preprod | Preview |
|---|---|---|---|
| ``AdaStat`` | `adastat.net` | — | — |
| ``CardanoScan`` | `cardanoscan.io` | `preprod.cardanoscan.io` | `preview.cardanoscan.io` |
| ``Cexplorer`` | `cexplorer.io` | `preprod.cexplorer.io` | `preview.cexplorer.io` |
| ``DRepTalk`` | `dreptalk.com` | `preprod.dreptalk.com` | — |
| ``Eutxo`` | `eutxo.org` | — | — |
| ``PoolPM`` | `pool.pm` | — | — |
| ``PoolTool`` | `pooltool.io` | — | — |

This matches [explorer.cardano.org](https://explorer.cardano.org)'s network tabs.

### Transactions, addresses and accounts

| Explorer | Transaction | Address | Stake account |
|---|---|---|---|
| AdaStat | `/transactions/<hex>` | `/addresses/<addr…>` | `/accounts/<credential hash>` |
| Cardanoscan | `/transaction/<hex>` | `/address/<addr…>` | `/stakekey/<stake…>` |
| Cexplorer | `/tx/<hex>` | `/address/<addr…>` | `/stake/<stake…>` |
| eUTxO | `/transaction/<hex>` | — | — |
| Pool PM | — | `/<addr…>` | `/<stake…>` |
| PoolTool | — | — | `/address/<credential hash>` |

### Blocks, epochs and pools

| Explorer | Block | Epoch | Pool |
|---|---|---|---|
| AdaStat | `/blocks/<number or hash>` | `/epochs/<n>` | `/pools/<hex>` |
| Cardanoscan | `/block/<number>` | `/epoch/<n>` | `/pool/<pool1…>` |
| Cexplorer | `/block/<hash>` | `/epoch/<n>` | `/pool/<pool1…>` |
| eUTxO | `/block/<number or hash>` | — | — |
| Pool PM | — | — | `/<pool1…>` |
| PoolTool | — | — | `/pool/<hex>` |

Cardanoscan takes blocks by number only, and Cexplorer by hash only; asking either for the other form throws.

### Governance

| Explorer | DRep | Governance action | Committee member |
|---|---|---|---|
| AdaStat | `/dreps/<drep1…>` | `/governances/<tx hash + index byte>` | — |
| Cardanoscan | `/drep/<drep1…>` | `/govAction/<gov_action1…>` | `/ccmember/<cc_cold1…>` |
| Cexplorer | `/drep/<drep1…>` | `/gov/action/<tx hash>%23<index>` | `/gov/cc/<cc_cold1…>` |
| DRepTalk | `/dreps/<drep1…>` | `/t/<gov_action1…>` | — |
| Pool PM | `/<drep1…>` | — | — |

DRep ids are always written in the CIP-129 form (`drep1y…`), the one every explorer takes; a DRep given in the older CIP-105 form is converted.

### Native assets

| Explorer | Policy | Asset |
|---|---|---|
| AdaStat | `/policies/<hex>` | `/tokens/<policy + name hex>` |
| Cardanoscan | `/tokenPolicy/<hex>` | `/token/<policy + name hex>` |
| Cexplorer | `/policy/<hex>` | `/asset/<asset1…>` |
| Pool PM | `/policy/<hex>` | `/<asset1…>` |

`asset1…` is the asset's CIP-14 fingerprint; see `AssetName/fingerprint(policy:)`.
