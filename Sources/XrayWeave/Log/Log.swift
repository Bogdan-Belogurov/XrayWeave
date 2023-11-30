// XrayWeave
// Written by Bogdan Belogurov, 2023.

/// Log configuration, controls the way Xray outputs logs.
struct Log: Encodable {

    var loglevel: LogLevel = .info
}
