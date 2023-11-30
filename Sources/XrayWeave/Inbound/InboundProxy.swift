// XrayWeave
// Written by Bogdan Belogurov, 2023.

public struct InboundProxy: Encodable {

    public struct Sniffing: Encodable {

        let enabled: Bool
        let destOverride: [String]
        let metadataOnly: Bool
        let routeOnly: Bool
        let domainsExcluded: [String]

        public init(
            enabled: Bool = true,
            destOverride: [String] = ["http", "tls"],
            metadataOnly: Bool = false,
            routeOnly: Bool = false,
            domainsExcluded: [String] = []
        ) {
            self.enabled = enabled
            self.destOverride = destOverride
            self.metadataOnly = metadataOnly
            self.routeOnly = routeOnly
            self.domainsExcluded = domainsExcluded
        }
    }

    /// Listening address, IP address or Unix domain socket, the default value is "0.0.0.0", which means accepting connections on all network cards.
    let listen: String

    /// Actual port number.
    let port: Int

    /// Connection protocol name.
    let `protocol`: InboundProtocol

    /// The specific configuration content varies depending on the protocol.
    let settings: InboundConfigurationObject

    /// The identifier of this inbound connection, used to locate this connection in other configurations.
    let tag: String

    /// Traffic detection is mainly used for transparent proxy and other purposes.
    let sniffing: Sniffing

    public init(
        listen: String = "127.0.0.1",
        port: Int = 443,
        `protocol`: InboundProtocol = .socks,
        settings: InboundConfigurationObject = .socks(SocksInboundConfigurationObject()),
        tag: String = "socks-in",
        sniffing: Sniffing = Sniffing()
    ) {
        self.listen = listen
        self.port = port
        self.`protocol` = `protocol`
        self.settings = settings
        self.tag = tag
        self.sniffing = sniffing
    }
}
