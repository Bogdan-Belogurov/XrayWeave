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
    struct TCP: Encodable {

        enum HeaderType: String, Encodable {

            case none
        }

        struct Header: Encodable {

            var type: HeaderType = .none
        }

        let header = Header()
    }

    enum Fingerprint: String, Encodable, XrayParsable {

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

    struct TLS: Encodable, XrayParsable {

        enum ALPN: String, CaseIterable, Codable {

            case h2         = "h2"
            case http1_1    = "http/1.1"
        }

        var serverName: String = ""
        var allowInsecure: Bool = false
        var alpn: [ALPN] = ALPN.allCases
        var fingerprint: Fingerprint = .chrome

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

    struct Reality: Encodable, XrayParsable {

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
    }

    let network: Network
    let security: Security
    var tcpSettings: TCP? = nil
    var realitySettings: Reality? = nil
    var tlsSettings: TLS? = nil

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
}
