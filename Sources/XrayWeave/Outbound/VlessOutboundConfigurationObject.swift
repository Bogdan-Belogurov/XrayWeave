// XrayWeave
// Written by Bogdan Belogurov, 2023.

public struct VlessOutboundConfigurationObject: Encodable, XrayParsable {

    public let address: String

    public let port: Int

    public let users: [User]

    init(_ parser: XrayWeave) throws {
        address = parser.host
        port = parser.port
        users = [try User(parser)]
    }

    public init(
        address: String,
        port: Int,
        users: [User]
    ) {
        self.address = address
        self.port = port
        self.users = users
    }
}
