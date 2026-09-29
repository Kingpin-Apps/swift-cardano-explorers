import Foundation
import SwiftCardanoCore

// The forms explorers want their identifiers in.
extension BlockchainExplorable {
    func hex(_ id: TransactionId) -> String { id.payload.toHex }

    /// A stake account as its bech32 stake address, `stake1…`.
    func stakeBech32(_ address: Address) throws -> String {
        try bech32(try stakeAddress(address))
    }

    /// A stake account as the hex hash of its stake credential.
    func stakeHash(_ address: Address) throws -> String {
        guard let staking = try stakeAddress(address).stakingPart else {
            throw ExplorerError.invalidItem("The address has no stake part, so it has no stake account.")
        }
        return staking.hash().toHex
    }

    func poolBech32(_ pool: PoolOperator) throws -> String {
        do {
            return try pool.id(.bech32)
        } catch {
            throw ExplorerError.invalidItem("The pool id could not be written in bech32.")
        }
    }

    func poolHex(_ pool: PoolOperator) -> String { pool.poolKeyHash.payload.toHex }

    /// A DRep as its CIP-129 id, `drep1…`: the one form every explorer takes.
    func drepID(_ drep: DRep) throws -> String {
        do {
            return try drep.id((.bech32, .cip129))
        } catch {
            throw ExplorerError.invalidItem("The DRep id could not be written.")
        }
    }

    /// A governance action as its CIP-129 id, `gov_action1…`.
    func govActionBech32(_ id: GovActionID) throws -> String {
        do {
            return try id.id(.bech32)
        } catch {
            throw ExplorerError.invalidItem("The governance action id could not be written.")
        }
    }

    /// A governance action as hex: its transaction id and index.
    func govActionHex(_ id: GovActionID) throws -> String {
        do {
            return try id.id(.hex)
        } catch {
            throw ExplorerError.invalidItem("The governance action id could not be written.")
        }
    }

    /// A committee member as its CIP-129 cold credential id, `cc_cold1…`.
    func committeeID(_ credential: CommitteeColdCredential) throws -> String {
        do {
            return try credential.id()
        } catch {
            throw ExplorerError.invalidItem("The committee member's id could not be written.")
        }
    }

    func assetFingerprint(_ policy: PolicyID, _ name: AssetName) throws -> String {
        try name.fingerprint(policy: policy)
    }

    /// An asset as its policy id and name, in hex, run together.
    func assetHex(_ policy: PolicyID, _ name: AssetName) -> String {
        policy.payload.toHex + name.payload.toHex
    }
}
