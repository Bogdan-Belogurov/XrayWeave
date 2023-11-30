// XrayWeave
// Written by Bogdan Belogurov, 2023.

public struct SocksInboundConfigurationObject: Encodable {

    public enum Auth: String, Encodable {

        case noauth, password
    }

    let auth: Auth
    let udp: Bool

    public init(
        auth: Auth = .noauth,
        udp: Bool = true
    ) {
        self.auth = auth
        self.udp = udp
    }
}
