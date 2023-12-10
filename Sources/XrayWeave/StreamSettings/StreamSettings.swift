// XrayWeave
// Written by Bogdan Belogurov, 2023.

import Foundation

/// The underlying transmission method (transport) is the way the current Xray node connects with other nodes.
public struct StreamSettings: Encodable, XrayParsable {

    public enum Network: String, Encodable {

        case tcp, kcp, ws, http, domainsocket, quic, grpc
    }

    public enum Security: String, Encodable {

        case none, tls, reality
    }

    /// The TCP configuration of the current connection, valid only when this connection uses TCP.
    public struct TCP: Encodable {

        public enum HeaderType: String, Encodable {

            case none
        }

        public struct Header: Encodable {

            var type: HeaderType = .none
        }

        public let header = Header()

        public init() {}
    }

    public enum Fingerprint: String, Encodable, XrayParsable {

        case chrome     = "chrome"
        case firefox    = "firefox"
        case safari     = "safari"
        case ios        = "ios"
        case android    = "android"
        case edge       = "edge"
        case _360       = "360"
        case qq         = "qq"
        case random     = "random"
        case randomized = "randomized"

        init(_ parser: XrayWeave) throws {
            if let value = parser.parametersMap["fp"] {
                guard !value.isEmpty else {
                    throw NSError.newError("Reality fp cannot be empty")
                }

                guard let value = Fingerprint(rawValue: value)else {
                    throw NSError.newError("Reality fingerprint isn't supported: \(value)")
                }

                self = value
            } else {
                self = .chrome
            }
        }
    }

    public struct TLS: Encodable, XrayParsable {

        public enum ALPN: String, CaseIterable, Codable {

            case h2         = "h2"
            case http1_1    = "http/1.1"
        }

        public var serverName: String = ""
        public var allowInsecure: Bool = false
        public var alpn: [ALPN] = ALPN.allCases
        public var fingerprint: Fingerprint = .chrome

        init(_ parser: XrayWeave) throws {
            guard parser.security == .tls else {
                throw NSError.newError(
                    "Should not provide tls config for this type of security: \(parser.security)"
                )
            }

            serverName = try String.sni(parser)
            fingerprint = try Fingerprint(parser)

            if let value = parser.parametersMap["alpn"] {
                guard !value.isEmpty else {
                    throw NSError.newError("\(parser.outboundProtocol.rawValue) TLS alpn cannot be empty")
                }
                alpn = value.components(separatedBy: ",").compactMap(ALPN.init)
            } else {
                alpn = ALPN.allCases
            }
        }
    }

    public struct Reality: Encodable, XrayParsable {

        var show: Bool = false
        var fingerprint: Fingerprint = .chrome
        var serverName: String = ""
        var publicKey: String = ""
        var shortId: String = ""
        var spiderX: String = ""

        init(_ parser: XrayWeave) throws {
            guard parser.security == .reality else {
                throw NSError.newError(
                    "Should not provide reality config for this type of security: \(parser.security)"
                )
            }
            if let publicKey = parser.parametersMap["pbk"], !publicKey.isEmpty {
                self.publicKey = publicKey
            } else {
                throw NSError.newError("Reality pbk cannot be empty")
            }

            serverName = try String.sni(parser)
            fingerprint = try Fingerprint(parser)
            shortId = parser.parametersMap["sid"] ?? String()
            spiderX = parser.parametersMap["spx"] ?? String()
        }

        public init(
            show: Bool = false,
            fingerprint: Fingerprint = .chrome,
            serverName: String = "",
            publicKey: String = "",
            shortId: String = "",
            spiderX: String = ""
        ) {
            self.show = show
            self.fingerprint = fingerprint
            self.serverName = serverName
            self.publicKey = publicKey
            self.shortId = shortId
            self.spiderX = spiderX
        }
    }

    public let network: Network
    public let security: Security
    public var tcpSettings: TCP? = nil
    public var realitySettings: Reality? = nil
    public var tlsSettings: TLS? = nil

    init(_ parser: XrayWeave) throws {
        network = parser.network
        security = parser.security

        switch network {
        case .tcp:
            tcpSettings = StreamSettings.TCP()
        default:
            throw NSError.newError("Unsupported network type: \(network.rawValue)")
        }

        switch security {
        case .none:
            break
        case .reality:
            realitySettings = try Reality(parser)
        case .tls:
            tlsSettings = try TLS(parser)
        }
    }

    public init(
        network: Network,
        security: Security,
        tcpSettings: TCP? = nil,
        realitySettings: Reality? = nil,
        tlsSettings: TLS? = nil
    ) {
        self.network = network
        self.security = security
        self.tcpSettings = tcpSettings
        self.realitySettings = realitySettings
        self.tlsSettings = tlsSettings
    }
}
