// XrayWeave
// Written by Bogdan Belogurov, 2023.

public enum InboundConfigurationObject: Encodable {

    case socks(SocksInboundConfigurationObject)
    case http(timeout: Int)

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .socks(let object):
            try container.encode(object)
        case .http(let timeout):
            try container.encode(["timeout": timeout])
        }
    }
}
