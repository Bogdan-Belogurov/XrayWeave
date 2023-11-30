// XrayWeave
// Written by Bogdan Belogurov, 2023.

import XCTest
@testable import XrayWeave

final class XrayWeaveTests: XCTestCase {

    func test_shouldSuccessfullyParseURI() throws {
        let parser = try XrayWeave(urlString: Fixtures.uri)

        XCTAssertEqual(parser.outboundProtocol, .vless)
        XCTAssertEqual(parser.userID, "e4109c55-8d9b-428b-b270-9d58b308d45a")
        XCTAssertEqual(parser.host, "xray.vpn.com")
        XCTAssertEqual(parser.port, 443)
        XCTAssertEqual(parser.network, .tcp)
        XCTAssertEqual(parser.security, .reality)
    }
}

private enum Fixtures {

    static let uri = """
    vless://e4109c55-8d9b-428b-b270-9d58b308d45a@xray.vpn.com:443?flow=xtls-rprx-vision-udp443\
    &type=tcp&security=reality&fp=safari&sni=dl.google.com&pbk=publickey&\
    sid=7d41abc#X-ray
    """
}
