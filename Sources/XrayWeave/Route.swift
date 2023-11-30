// XrayWeave
// Written by Bogdan Belogurov, 2023.

public struct Route: Encodable {

    public enum DomainStrategy: String, Encodable {

        case asIs = "AsIs"
        case ipIfNonMatch = "IPIfNonMatch"
        case ipOnDemand = "IPOnDemand"
    }

    public enum DomainMatcher: String, Encodable {

        case hybrid, linear
    }

    public enum Outbound: String, Encodable {

        case direct, proxy, block
    }

    public struct Rule: Encodable {

        let domainMatcher: DomainMatcher?
        let type: String = "field"
        let domain: [String]?
        let ip: [String]?
        let port: String?
        let sourcePort: String?
        let network: String?
        let source: [String]?
        let user: [String]?
        let inboundTag: [String]?
        let `protocol`: [String]?
        let attrs: String?
        let outboundTag: Outbound
        let balancerTag: String?

        public init(
            domainMatcher: DomainMatcher? = nil,
            domain: [String]? = nil,
            ip: [String]? = nil,
            port: String? = nil,
            sourcePort: String? = nil,
            network: String? = nil,
            source: [String]? = nil,
            user: [String]? = nil,
            inboundTag: [String]? = nil,
            `protocol`: [String]? = nil,
            attrs: String? = nil,
            outboundTag: Outbound = .direct,
            balancerTag: String? = nil
        ) {
            self.domainMatcher = domainMatcher
            self.domain = domain
            self.ip = ip
            self.port = port
            self.sourcePort = sourcePort
            self.network = network
            self.source = source
            self.user = user
            self.inboundTag = inboundTag
            self.protocol = `protocol`
            self.attrs = attrs
            self.outboundTag = outboundTag
            self.balancerTag = balancerTag
        }
    }

    public struct Balancer: Encodable {

        let tag: String
        let selector: [String] = []
    }

    /// Domain name resolution strategy uses different strategies according to different settings.
    let domainStrategy: DomainStrategy

    /// Domain name matching algorithm uses different algorithms according to different settings.
    let domainMatcher: DomainMatcher?

    /// For each connection, routing will be judged from top to bottom based on these rules. When the first effective rule is encountered,
    /// the connection will be forwarded to the specified outboundTagor balancerTag.
    let rules: [Rule]

    /// When a rule points to a load balancer, Xray will select an outbound through
    ///  the load balancer and forward the traffic to it.
    let balancers: [Balancer]?

    public init(
        domainStrategy: DomainStrategy = .asIs,
        domainMatcher: DomainMatcher? = nil,
        rules: [Rule] = [],
        balancers: [Balancer]? = nil
    ) {
        self.domainStrategy = domainStrategy
        self.domainMatcher = domainMatcher
        self.rules = rules
        self.balancers = balancers
    }
}

