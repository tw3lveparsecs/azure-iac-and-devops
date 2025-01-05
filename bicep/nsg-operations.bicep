targetScope = 'subscription'

@description('The resource name.')
param name string

@description('Optional. The geo-location where the resource lives.')
param location string = deployment().location

@description('The resource group name.')
param resourceGroup string

@description('A collection of security rules for the network security group.')
@metadata({
  name: 'Rule name.'
  properties: {
    access: 'The network traffic is allowed or denied. Allowed values: "Allow" or "Deny".'
    description: 'A description for this rule. Restricted to 140 chars.'
    destinationAddressPrefix: 'The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used.'
    destinationAddressPrefixes: [
      'The destination address prefixes. CIDR or destination IP ranges.'
    ]
    destinationApplicationSecurityGroups: [
      {
        id: 'Resource ID of destination application security group. Only used when destinationAddressPrefix/destinationAddressPrefixes is not specified.'
      }
    ]
    destinationPortRange: 'The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.'
    destinationPortRanges: [
      'The destination port ranges. Only used when destinationPortRange is not specified.'
    ]
    direction: 'The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic. Allowed values: "Inbound" or "Outbound".'
    priority: 'The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.'
    protocol: 'Network protocol this rule applies to. Allowed values: "*", "Ah", "Esp", "Icmp", "Tcp", "Udp".'
    sourceAddressPrefix: '	The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from.'
    sourceAddressPrefixes: [
      'The CIDR or source IP ranges. Only used when sourceAddressPrefix is not specified.'
    ]
    sourceApplicationSecurityGroups: [
      {
        id: 'Resource ID of source application security group. Only used when sourceAddressPrefix/sourceAddressPrefixes is not specified.'
      }
    ]
    sourcePortRange: 'The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.'
    sourcePortRanges: [
      'The source port ranges. Only used when sourcePortRange is not specified.'
    ]
  }
})
param securityRules array

module nsgDevops 'network-security-groups/main.bicep' = {
  scope: az.resourceGroup(resourceGroup)
  name: 'nsg-operations-${uniqueString(deployment().name, location)}'
  params: {
    name: toLower(name)
    location: location
    securityRules: securityRules
  }
}
