// XrayWeave
// Written by Bogdan Belogurov, 2023.

public struct VlessOutboundConfigurationObject: Encodable, XrayParsable {

    let address: String

    let port: Int

    let users: [User]

    init(_ parser: XrayWeave) throws {
        address = parser.host
        port = parser.port
        users = [try User(parser)]
    }
}
