// XrayWeave
// Written by Bogdan Belogurov, 2023.

import Foundation

public final class XrayConfiguration: Encodable, XrayParsable {

    private var log = Log()
    private var routing: Route?
    private var inbounds: [InboundProxy] = []
    private var outbounds: [OutboundProxy] = []

    init(_ parser: XrayWeave) throws {
        outbounds = [try OutboundProxy(parser)]
    }

    public init() {}

    public func logLevel(_ logLevel: LogLevel) -> Self {
        log.loglevel = logLevel
        return self
    }

    public func routing(_ route: Route) -> Self {
        routing = route
        return self
    }

    public func inbound(_ inbound: InboundProxy) -> Self {
        inbounds.append(inbound)
        return self
    }

    public func outbound(_ outbound: OutboundProxy) -> Self {
        outbounds.append(outbound)
        return self
    }

    public func toJSON() throws -> String {
        let jsonData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData)
        let jsonData2 = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        return String(decoding: jsonData2, as: UTF8.self)
    }
}
