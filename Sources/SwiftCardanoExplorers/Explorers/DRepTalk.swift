import Foundation
import SwiftCardanoCore

/// [DRepTalk](https://dreptalk.com), for governance: discussions, votes and
/// rationales on an action, and DRep profiles. On mainnet and preprod.
///
/// A DRep page exists only for DReps with a DRepTalk profile; others get a
/// "not found" page.
public struct DRepTalk: BlockchainExplorable {
    /// The network the links are for.
    public let network: Network
    /// The explorer's name.
    public let name = "DRepTalk"
    /// The explorer's site on each network it covers.
    public let networkUrls = NetworkURLs(
        mainnet: URL(string: "https://dreptalk.com")!,
        preprod: URL(string: "https://preprod.dreptalk.com")!
    )
    /// The kinds of item the explorer has pages for.
    public let supportedItems: Set<ExplorerItem.Kind> = [.drep, .governanceAction]

    /// The explorer on `network`.
    /// - Parameter network: The network the links are for.
    public init(network: Network) { self.network = network }

    /// The DRep's page: `/dreps/<drep1…>`, CIP-129 only. Only DReps with a DRepTalk profile have a page.
    public func viewDRep(drep: DRep) throws -> URL { try page("dreps", drepID(drep)) }
    /// The governance action's page: `/t/<gov_action1…>`
    public func viewGovernanceAction(govActionID: GovActionID) throws -> URL {
        try page("t", govActionBech32(govActionID))
    }
}
