// XrayWeave
// Written by Bogdan Belogurov, 2023.

public struct OutboundProxy: Encodable, XrayParsable {

    /// Connection protocol name (Vless/Vmess).
    let `protocol`: OutboundProtocol

    /// The identifier of this outbound connection, used to locate this connection in other configurations.
    /// When it is not empty, its value must be unique `tag` among all.
    let tag: String

    /// The specific configuration content varies depending on the protocol.
    let settings: OutboundConfigurationObject?

    /// The underlying transmission method (transport) is the way the current Xray node connects with other nodes.
    let streamSettings: StreamSettings?

    /// The IP address used to send data, valid when the host has multiple IP addresses, the default value is "0.0.0.0".
    let sendThrough: String

    init(_ parser: XrayWeave) throws {
        `protocol` = parser.outboundProtocol
        tag = "proxy"
        settings = try OutboundConfigurationObject(parser)
        streamSettings = try StreamSettings(parser)
        sendThrough = "0.0.0.0"
    }

    public init(
        `protocol`: OutboundProtocol = .vless,
        tag: String = String(),
        settings: OutboundConfigurationObject? = nil,
        streamSettings: StreamSettings? = nil,
        sendThrough: String = "0.0.0.0"
    ) {
        self.protocol = `protocol`
        self.tag = tag
        self.settings = settings
        self.streamSettings = streamSettings
        self.sendThrough = sendThrough
    }
}
