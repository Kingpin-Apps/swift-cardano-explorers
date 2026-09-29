import Foundation
import SwiftCardanoCore
import SwiftNaCl

extension AssetName {
    /// The asset's CIP-14 fingerprint, `asset1…`, under `policy`.
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
