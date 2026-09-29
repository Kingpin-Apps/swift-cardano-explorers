import Foundation
import SwiftCardanoCore
import Testing

@testable import SwiftCardanoExplorers

/// Real mainnet items. The expected links below were each checked to open
/// the right page on the explorer's site (September 2026).
enum Sample {
    static let txHex = "01e9d18aeff8432b38d0b7b79faf813ec214cffe3ccd601983a9ed5dc119458c"
    static let addressBech32 = "addr1qx7a3e0cmwrdspnslsy5hc602w7zvx5ejw924avw8them8mj5qpt4teewa586j20qh6fqdt47xns85ta22hkr32twatq3ym80g"
    static let stakeBech32 = "stake1u9e2qq464uuhw6raf98staysx46lrfcr69749tmpc49hw4ssu4aa4"
    static let stakeHash = "72a002baaf3977687d494f05f4903575f1a703d17d52af61c54b7756"
    static let poolBech32 = "pool1mxqjlrfskhd5kql9kak06fpdh8xjwc76gec76p3taqy2qmfzs5z"
    static let poolHex = "d9812f8d30b5db4b03e5b76cfd242db9cd2763da4671ed062be808a0"
    static let blockHash = "ed068852ddefffa749d84cc1fdaa26ba445318d3ab330d1657c98218319d5f90"
    static let drepCIP129 = "drep1ygqzg3ed7rdqeg3343jw0fptqzc3lqtk3rvnnmgq64rj85sxd4sr4"
    static let drepCIP105 = "drep1qqjywt0smgx2yvdvvnn6g2cqky0cza5gmyu76qx4gu3aycpj93e"
    static let govActionBech32 = "gov_action1w2w64uhelz0cg2np7m37hal905tdd7jpzm3fcyc3g7qvkwgfppgqqfsggt5"
    static let govActionTx = "729daaf2f9f89f842a61f6e3ebf7e57d16d6fa4116e29c13114780cb39090850"
    static let ccCold = "cc_cold1zwz2a08a8cqdp7r6lyv0cj67qqf47sr7x7vf8hm705ujc6s4m87eh"
    static let policyHex = "29d222ce763455e3d7a09a665ce554f00ac89d2e99a1a83d267170c6"
    static let assetNameHex = "4d494e"
    static let fingerprint = "asset1d9v7aptfvpx7we2la8f25kwprkj2ma5rp6uwzv"

    static var transaction: ExplorerItem { .transaction(TransactionId(payload: Data(hexString: txHex)!)) }
    static var address: ExplorerItem { get throws { .address(try Address(from: .string(addressBech32))) } }
    static var account: ExplorerItem { get throws { .account(try Address(from: .string(addressBech32))) } }
    static var blockByNumber: ExplorerItem { .block(.number(14_003_180)) }
    static var blockByHash: ExplorerItem { .block(.bodyHash(BlockBodyHash(payload: Data(hexString: blockHash)!))) }
    static var pool: ExplorerItem { get throws { .pool(try PoolOperator(from: poolBech32)) } }
    static var drep: ExplorerItem { get throws { .drep(try DRep(from: drepCIP129)) } }
    static var governanceAction: ExplorerItem { get throws { .governanceAction(try GovActionID(from: govActionBech32)) } }
    static var committeeMember: ExplorerItem { get throws { .committeeMember(try CommitteeColdCredential(from: ccCold)) } }
    static var policy: ExplorerItem { .policy(PolicyID(payload: Data(hexString: policyHex)!)) }
    static var asset: ExplorerItem {
        get throws { .asset(policy: PolicyID(payload: Data(hexString: policyHex)!), name: try AssetName(payload: Data(hexString: assetNameHex)!)) }
    }

    /// One item of every kind.
    static var all: [ExplorerItem] {
        get throws {
            [transaction, try address, try account, blockByNumber, blockByHash, .epoch(658), try pool, try drep,
             try governanceAction, try committeeMember, policy, try asset]
        }
    }
}

@Suite("Explorer links")
struct ExplorerTests {
    func link(_ explorer: BlockchainExplorer, _ item: ExplorerItem, on network: Network = .mainnet) throws -> String {
        try explorer.url(for: item, on: network).absoluteString
    }

    @Test("Cardanoscan")
    func cardanoScan() throws {
        #expect(try link(.cardanoScan, Sample.transaction) == "https://cardanoscan.io/transaction/\(Sample.txHex)")
        #expect(try link(.cardanoScan, Sample.address) == "https://cardanoscan.io/address/\(Sample.addressBech32)")
        #expect(try link(.cardanoScan, Sample.account) == "https://cardanoscan.io/stakekey/\(Sample.stakeBech32)")
        #expect(try link(.cardanoScan, Sample.blockByNumber) == "https://cardanoscan.io/block/14003180")
        #expect(try link(.cardanoScan, .epoch(658)) == "https://cardanoscan.io/epoch/658")
        #expect(try link(.cardanoScan, Sample.pool) == "https://cardanoscan.io/pool/\(Sample.poolBech32)")
        #expect(try link(.cardanoScan, Sample.drep) == "https://cardanoscan.io/drep/\(Sample.drepCIP129)")
        #expect(try link(.cardanoScan, Sample.governanceAction) == "https://cardanoscan.io/govAction/\(Sample.govActionBech32)")
        #expect(try link(.cardanoScan, Sample.committeeMember) == "https://cardanoscan.io/ccmember/\(Sample.ccCold)")
        #expect(try link(.cardanoScan, Sample.policy) == "https://cardanoscan.io/tokenPolicy/\(Sample.policyHex)")
        #expect(try link(.cardanoScan, Sample.asset) == "https://cardanoscan.io/token/\(Sample.policyHex)\(Sample.assetNameHex)")
        #expect(try link(.cardanoScan, Sample.transaction, on: .preview) == "https://preview.cardanoscan.io/transaction/\(Sample.txHex)")
        #expect(throws: ExplorerError.self) { try link(.cardanoScan, Sample.blockByHash) }
    }

    @Test("Cexplorer")
    func cexplorer() throws {
        #expect(try link(.cexplorer, Sample.transaction) == "https://cexplorer.io/tx/\(Sample.txHex)")
        #expect(try link(.cexplorer, Sample.address) == "https://cexplorer.io/address/\(Sample.addressBech32)")
        #expect(try link(.cexplorer, Sample.account) == "https://cexplorer.io/stake/\(Sample.stakeBech32)")
        #expect(try link(.cexplorer, Sample.blockByHash) == "https://cexplorer.io/block/\(Sample.blockHash)")
        #expect(try link(.cexplorer, .epoch(658)) == "https://cexplorer.io/epoch/658")
        #expect(try link(.cexplorer, Sample.pool) == "https://cexplorer.io/pool/\(Sample.poolBech32)")
        #expect(try link(.cexplorer, Sample.drep) == "https://cexplorer.io/drep/\(Sample.drepCIP129)")
        #expect(try link(.cexplorer, Sample.governanceAction) == "https://cexplorer.io/gov/action/\(Sample.govActionTx)%230")
        #expect(try link(.cexplorer, Sample.committeeMember) == "https://cexplorer.io/gov/cc/\(Sample.ccCold)")
        #expect(try link(.cexplorer, Sample.policy) == "https://cexplorer.io/policy/\(Sample.policyHex)")
        #expect(try link(.cexplorer, Sample.asset) == "https://cexplorer.io/asset/\(Sample.fingerprint)")
        #expect(try link(.cexplorer, .epoch(1435), on: .preview) == "https://preview.cexplorer.io/epoch/1435")
        #expect(throws: ExplorerError.self) { try link(.cexplorer, Sample.blockByNumber) }
    }

    @Test("AdaStat")
    func adaStat() throws {
        #expect(try link(.adaStat, Sample.transaction) == "https://adastat.net/transactions/\(Sample.txHex)")
        #expect(try link(.adaStat, Sample.address) == "https://adastat.net/addresses/\(Sample.addressBech32)")
        #expect(try link(.adaStat, Sample.account) == "https://adastat.net/accounts/\(Sample.stakeHash)")
        #expect(try link(.adaStat, Sample.blockByNumber) == "https://adastat.net/blocks/14003180")
        #expect(try link(.adaStat, .epoch(658)) == "https://adastat.net/epochs/658")
        #expect(try link(.adaStat, Sample.pool) == "https://adastat.net/pools/\(Sample.poolHex)")
        #expect(try link(.adaStat, Sample.drep) == "https://adastat.net/dreps/\(Sample.drepCIP129)")
        #expect(try link(.adaStat, Sample.governanceAction) == "https://adastat.net/governances/\(Sample.govActionTx)00")
        #expect(try link(.adaStat, Sample.policy) == "https://adastat.net/policies/\(Sample.policyHex)")
        #expect(try link(.adaStat, Sample.asset) == "https://adastat.net/tokens/\(Sample.policyHex)\(Sample.assetNameHex)")
        #expect(throws: ExplorerError.self) { try link(.adaStat, Sample.committeeMember) }
    }

    @Test("eUTxO, PoolTool, Pool PM and DRepTalk")
    func others() throws {
        #expect(try link(.eutxo, Sample.transaction) == "https://eutxo.org/transaction/\(Sample.txHex)")
        #expect(try link(.eutxo, Sample.blockByNumber) == "https://eutxo.org/block/14003180")
        #expect(try link(.poolTool, Sample.pool) == "https://pooltool.io/pool/\(Sample.poolHex)")
        #expect(try link(.poolTool, Sample.account) == "https://pooltool.io/address/\(Sample.stakeHash)")
        #expect(try link(.poolPM, Sample.address) == "https://pool.pm/\(Sample.addressBech32)")
        #expect(try link(.poolPM, Sample.account) == "https://pool.pm/\(Sample.stakeBech32)")
        #expect(try link(.poolPM, Sample.pool) == "https://pool.pm/\(Sample.poolBech32)")
        #expect(try link(.poolPM, Sample.drep) == "https://pool.pm/\(Sample.drepCIP129)")
        #expect(try link(.poolPM, Sample.policy) == "https://pool.pm/policy/\(Sample.policyHex)")
        #expect(try link(.poolPM, Sample.asset) == "https://pool.pm/\(Sample.fingerprint)")
        #expect(try link(.drepTalk, Sample.governanceAction) == "https://dreptalk.com/t/\(Sample.govActionBech32)")
        #expect(try link(.drepTalk, Sample.drep) == "https://dreptalk.com/dreps/\(Sample.drepCIP129)")
        #expect(try link(.drepTalk, Sample.governanceAction, on: .preprod) == "https://preprod.dreptalk.com/t/\(Sample.govActionBech32)")
        #expect(throws: ExplorerError.self) { try link(.poolTool, Sample.transaction) }
    }

    @Test("A CIP-105 DRep id links as CIP-129, the form every explorer takes")
    func drepForm() throws {
        let drep = try DRep(from: Sample.drepCIP105)
        #expect(try link(.drepTalk, .drep(drep)) == "https://dreptalk.com/dreps/\(Sample.drepCIP129)")
    }

    @Test("Networks match explorer.cardano.org")
    func networks() {
        #expect(BlockchainExplorer.cardanoScan.networks == [.mainnet, .preprod, .preview])
        #expect(BlockchainExplorer.cexplorer.networks == [.mainnet, .preprod, .preview])
        #expect(BlockchainExplorer.drepTalk.networks == [.mainnet, .preprod])
        for explorer in [BlockchainExplorer.adaStat, .eutxo, .poolPM, .poolTool] {
            #expect(explorer.networks == [.mainnet])
        }
        #expect(!BlockchainExplorer.eutxo.supports(.preprod))
        #expect(!BlockchainExplorer.cardanoScan.supports(.sanchonet))
        #expect(BlockchainExplorer.adaStat.link(for: Sample.transaction, on: .preprod) == nil)
        #expect(BlockchainExplorer.supporting(.transaction, on: .preview) == [.cardanoScan, .cexplorer])
    }

    @Test("Each explorer links every kind it claims, and no other")
    func supportedItemsAreHonest() throws {
        for explorer in BlockchainExplorer.allCases {
            for kind in ExplorerItem.Kind.allCases {
                let items = try Sample.all.filter { $0.kind == kind }
                let linked = items.contains { explorer.link(for: $0, on: .mainnet) != nil }
                #expect(linked == explorer.supportedItems.contains(kind), "\(explorer) \(kind)")
            }
        }
    }

    @Test("An account link needs an address with a stake part")
    func accountNeedsStakePart() throws {
        let enterprise = try Address(paymentPart: .verificationKeyHash(VerificationKeyHash(payload: Data(repeating: 1, count: 28))), network: .mainnet)
        #expect(BlockchainExplorer.cexplorer.link(for: .account(enterprise), on: .mainnet) == nil)
        let stake = try Address(from: .string(Sample.stakeBech32))
        #expect(try link(.cexplorer, .account(stake)) == "https://cexplorer.io/stake/\(Sample.stakeBech32)")
    }

    @Test("Asset fingerprints follow CIP-14")
    func fingerprint() throws {
        // CIP-14's own test vectors.
        let policy = PolicyID(payload: Data(hexString: "7eae28af2208be856f7a119668ae52a49b73725e326dc16579dcc373")!)
        #expect(try AssetName(payload: Data()).fingerprint(policy: policy) == "asset1rjklcrnsdzqp65wjgrg55sy9723kw09mlgvlc3")
        let other = PolicyID(payload: Data(hexString: "1e349c9bdea19fd6c147626a5260bc44b71635f398b67c59881df209")!)
        #expect(try AssetName(payload: Data(hexString: "504154415445")!).fingerprint(policy: other) == "asset1hv4p5tv2a837mzqrst04d0dcptdjmluqvdx9k3")
    }
}

@Suite("Reading explorer links")
struct ExplorerLinkTests {
    @Test("Every link this package makes reads back to its explorer, network and item")
    func roundTrip() throws {
        for explorer in BlockchainExplorer.allCases {
            for network in explorer.networks {
                for item in try Sample.all {
                    guard let url = explorer.link(for: item, on: network) else { continue }
                    // Fingerprints and stake key hashes cannot be read back.
                    if [.asset, .account].contains(item.kind),
                        url.lastPathComponent.hasPrefix("asset1") || url.lastPathComponent.count == 56 { continue }
                    let link = try #require(ExplorerLink(url), "\(url)")
                    #expect(link.explorer == explorer)
                    #expect(link.network == network)
                    #expect(link.item.kind == item.kind, "\(url)")
                    #expect(explorer.link(for: link.item, on: network) == url, "\(url)")
                }
            }
        }
    }

    @Test("Pasted links from the explorers' sites")
    func pasted() throws {
        let tx = try #require(ExplorerLink(URL(string: "https://preprod.cardanoscan.io/transaction/\(Sample.txHex)")!))
        #expect(tx.explorer == .cardanoScan)
        #expect(tx.network == .preprod)
        guard case .transaction(let id) = tx.item else { Issue.record("not a transaction"); return }
        #expect(id.payload.toHex == Sample.txHex)

        let action = try #require(ExplorerLink(URL(string: "https://adastat.net/governances/\(Sample.govActionTx)00")!))
        guard case .governanceAction(let govAction) = action.item else { Issue.record("not an action"); return }
        #expect(try govAction.id(.bech32) == Sample.govActionBech32)

        let pool = try #require(ExplorerLink(URL(string: "https://pool.pm/\(Sample.poolBech32)")!))
        #expect(pool.item.kind == .pool)
        #expect(ExplorerLink(URL(string: "https://example.com/tx/\(Sample.txHex)")!) == nil)
        #expect(ExplorerLink(URL(string: "https://cexplorer.io/tx/nothex")!) == nil)
    }
}
