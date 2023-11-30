// XrayWeave
// Written by Bogdan Belogurov, 2023.

import Foundation

public struct XrayWeave {

    public let outboundProtocol: OutboundProtocol
    public let userID: String
    public let host: String
    public let port: Int
    public let network: StreamSettings.Network
    public let security: StreamSettings.Security
    public let fragment: String
    let parametersMap: [String: String]

    public init(urlString: String) throws {
        guard let urlComponents = URLComponents(string: urlString) else {
            throw NSError.newError("Can't create URL components")
        }

        guard let outboundProtocol = urlComponents.scheme.flatMap(OutboundProtocol.init) else {
            throw NSError.newError("Unsupported protocol \(String(describing: urlComponents.scheme))")
        }

        guard let userID = urlComponents.user, !userID.isEmpty else {
            throw NSError.newError("There is no user")
        }

        guard let host = urlComponents.host, !host.isEmpty else {
            throw NSError.newError("There is no host")
        }

        guard let port = urlComponents.port, (1...65535).contains(port) else {
            throw NSError.newError("Port isn't valid")
        }

        let map = (urlComponents.queryItems ?? []).reduce(into: [String: String](), { result, item in
            result[item.name] = item.value
        })

        guard let network = map["type"].flatMap(StreamSettings.Network.init) else {
            throw NSError.newError("There is no valid network type")
        }

        guard let security = map["security"].flatMap(StreamSettings.Security.init) else {
            throw NSError.newError("There is no valid security type")
        }

        self.outboundProtocol = outboundProtocol
        self.userID = userID
        self.host = host
        self.port = port
        self.network = network
        self.security = security
        self.fragment = urlComponents.fragment ?? String()
        parametersMap = map
    }

    public func getConfiguration() throws -> XrayConfiguration {
        return try XrayConfiguration(self)
    }
}
