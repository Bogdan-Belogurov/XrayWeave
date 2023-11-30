// XrayWeave
// Written by Bogdan Belogurov, 2023.

import Foundation

extension String {

    static func sni(_ parser: XrayWeave) throws -> String {
        if let value = parser.parametersMap["sni"] {
            guard !value.isEmpty else { throw NSError.newError("Reality sni cannot be empty") }
            return value
        } else {
            return parser.host
        }
    }
}
