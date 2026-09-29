import Foundation

/// Why an explorer cannot link to something.
public enum ExplorerError: Error, Equatable, Sendable, CustomStringConvertible {
    /// The explorer has no site for the network.
    case unsupportedNetwork(explorer: String, network: String)
    /// The explorer has no page for this kind of item.
    case unsupportedItem(explorer: String, item: String)
    /// The item cannot be written in the form the explorer needs, such as an
    /// address without a stake part for an account page.
    case invalidItem(String)

    public var description: String {
        switch self {
        case .unsupportedNetwork(let explorer, let network): "\(explorer) has no \(network) explorer."
        case .unsupportedItem(let explorer, let item): "\(explorer) has no page for \(item)."
        case .invalidItem(let reason): reason
        }
    }
}
