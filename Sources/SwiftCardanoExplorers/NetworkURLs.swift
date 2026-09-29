import Foundation
import SwiftCardanoCore

/// An explorer's site on each network it covers.
public struct NetworkURLs: Sendable, Equatable {
    public var mainnet: URL
    public var preprod: URL?
    public var preview: URL?

    public init(mainnet: URL, preprod: URL? = nil, preview: URL? = nil) {
        self.mainnet = mainnet
        self.preprod = preprod
        self.preview = preview
    }

    /// The site for `network`, if the explorer has one.
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
