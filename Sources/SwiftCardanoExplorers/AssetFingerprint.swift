import Foundation
import SwiftCardanoCore
import SwiftNaCl

extension AssetName {
    /// The asset's CIP-14 fingerprint, `asset1…`, under `policy`.
    ///
    /// The fingerprint is the bech32 encoding of a 160-bit BLAKE2b hash of the policy
    /// id and the asset name, as [CIP-14](https://cips.cardano.org/cip/CIP-0014) defines.
    /// Cexplorer and Pool PM link assets by it.
    ///
    /// - Parameter policy: The policy the asset is minted under.
    /// - Returns: The fingerprint, such as `asset1rjklcrnsdzqp65wjgrg55sy9723kw09mlgvlc3`.
    /// - Throws: ``ExplorerError/invalidItem(_:)`` if it cannot be encoded.
    public func fingerprint(policy: PolicyID) throws -> String {
        let digest = try SwiftNaCl.Hash().blake2b(
            data: policy.payload + payload, digestSize: 20, encoder: RawEncoder.self
        )
        guard let fingerprint = Bech32().encode(hrp: "asset", witprog: digest) else {
            throw ExplorerError.invalidItem("The asset's fingerprint could not be written.")
        }
        return fingerprint
    }
}
