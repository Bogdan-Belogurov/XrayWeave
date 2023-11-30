// XrayWeave
// Written by Bogdan Belogurov, 2023.

import Foundation

extension NSError {

    static func newError(_ message: String) -> NSError {
        NSError(domain: "XrayWeave", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
