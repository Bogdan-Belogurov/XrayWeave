// XrayWeave
// Written by Bogdan Belogurov, 2023.

import Foundation

public enum OutboundConfigurationObject: Encodable, XrayParsable {

    case vless(VlessOutboundConfigurationObject)

    init(_ parser: XrayWeave) throws {
        switch parser.outboundProtocol {
        case .vless:
            self = .vless(try VlessOutboundConfigurationObject(parser))
        case .freedom:
            throw NSError.newError("Fix me 🥲")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .vless(let object):
            try container.encode(["vnext": [object]])
        }
    }
}
