import Foundation
import SwiftCardanoCore

/// [DRepTalk](https://dreptalk.com), for governance: discussions, votes and
/// rationales on an action, and DRep profiles. On mainnet and preprod.
///
/// A DRep page exists only for DReps with a DRepTalk profile; others get a
/// "not found" page.
public struct DRepTalk: BlockchainExplorable {
    public let network: Network
    public let name = "DRepTalk"
    public let networkUrls = NetworkURLs(
        mainnet: URL(string: "https://dreptalk.com")!,
        preprod: URL(string: "https://preprod.dreptalk.com")!
    )
    public let supportedItems: Set<ExplorerItem.Kind> = [.drep, .governanceAction]

    public init(network: Network) { self.network = network }

    public func viewDRep(drep: DRep) throws -> URL { try page("dreps", drepID(drep)) }
    public func viewGovernanceAction(govActionID: GovActionID) throws -> URL {
        try page("t", govActionBech32(govActionID))
    }
}
