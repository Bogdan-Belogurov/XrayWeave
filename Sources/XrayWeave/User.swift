// XrayWeave
// Written by Bogdan Belogurov, 2023.

import Foundation

struct User: Encodable, XrayParsable {

    enum Flow: String, Encodable {

        case none                       = "none"
        case xtls_rprx_vision           = "xtls-rprx-vision"
        case xtls_rprx_vision_udp443    = "xtls-rprx-vision-udp443"
    }

    let id: String
    let flow: Flow
    let encryption: String = "none"
    let level: Int = 0

    init(_ parser: XrayWeave) throws {
        let flow = try Self.getFlow(parser.parametersMap)
        id = parser.userID
        self.flow = flow
    }

    private static func getFlow(_ map: [String: String]) throws -> User.Flow {
        if let flowString = map["flow"] {
            guard !flowString.isEmpty else { throw NSError.newError("Flow control cannot be empty") }
            guard let flow = User.Flow(rawValue: flowString) else {
                throw NSError.newError("Unsupported flow type: \(flowString)")
            }
            return flow
        } else {
            return .none
        }
    }
}
