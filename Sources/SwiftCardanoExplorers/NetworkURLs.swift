import Foundation
import SwiftCardanoCore

/// An explorer's site on each network it covers.
///
/// Every explorer has a mainnet site; the testnets are optional.
public struct NetworkURLs: Sendable, Equatable {
    /// The mainnet site.
    public var mainnet: URL
    /// The preprod site, if there is one.
    public var preprod: URL?
    /// The preview site, if there is one.
    public var preview: URL?

    /// The sites on each network.
    /// - Parameters:
    ///   - mainnet: The mainnet site.
    ///   - preprod: The preprod site, if there is one.
    ///   - preview: The preview site, if there is one.
    public init(mainnet: URL, preprod: URL? = nil, preview: URL? = nil) {
        self.mainnet = mainnet
        self.preprod = preprod
        self.preview = preview
    }

    /// The site for `network`, if the explorer has one.
    /// - Parameter network: A network. Only mainnet, preprod and preview have sites.
    /// - Returns: The site, or nil.
    public func url(for network: Network) -> URL? {
        switch network {
        case .mainnet: mainnet
        case .preprod: preprod
        case .preview: preview
        default: nil
        }
    }

    /// The networks the explorer covers.
    public var networks: [Network] {
        [.mainnet] + (preprod == nil ? [] : [.preprod]) + (preview == nil ? [] : [.preview])
    }
}
