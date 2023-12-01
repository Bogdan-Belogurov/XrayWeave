# XrayWeave

Helper for [xray-core](https://github.com/XTLS/Xray-core) to parse URI links or construct configuration by yourself.

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Installation](#installation)
  - [Usage](#usage)
- [Contributing](#contributing)

## Introduction

The XrayWeave is a utility designed to assist xray-core users to create configuration for the Xray VPN using Swift. It simplifies the process of extracting from URI and manipulating configuration information.

## Features

- **Parsing:** Quickly parse xray config URI links to extract configuration details.
- **Compatibility:** Designed to work seamlessly with xray-core configurations.
- **Easy Integration:** Simple and straightforward integration into your projects.

## Getting Started

### Installation

The preferred way of installing XrayWeave is via the [Swift Package Manager](https://swift.org/package-manager/).

```swift
/// Package.swift
/// ...
dependencies: [
    .package(url: "https://github.com/Bogdan-Belogurov/XrayWeave.git", branch: "main"),
]
/// ...
```

### Usage
```swift
import XrayWeave

/// ...

func connect() {
    let uri = """
    vless://e4109c55-8d9b-b270-9d58b308d45a@xray.vpn.com:443flow=xtls-rprx-vision-udp443\
    &type=tcp&security=reality&fp=safari&sni=dl.google.com&pbk=publickey&sid=7d263c#X-ray
    """

    let inboundTag = "socketinbound"
    let newInbound = InboundProxy(
        listen: "[::1]",
        port: inboundPort,
        protocol: .socks,
        settings: .socks(SocksInboundConfigurationObject(auth: .noauth, udp: true)),
        tag: inboundTag
    )

    let config = try XrayWeave(urlString: uri)
        .getConfiguration()
        .logLevel(.debug)
        .routing(
            Route(
                domainStrategy: .asIs,
                rules: [
                    Route.Rule(
                        inboundTag: [inboundTag],
                        outboundTag: .proxy
                    )
                ]
            )
        )
        .inbound(newInbound)
        .toJSON()
        
    try xray.connect(config)
}
```

## Contributing
Contributions are welcome! If you encounter any issues or have suggestions for improvements, please open an [issue](https://github.com/Bogdan-Belogurov/XrayWeave/issues) or submit a [pull request](https://github.com/Bogdan-Belogurov/XrayWeave/pulls).
