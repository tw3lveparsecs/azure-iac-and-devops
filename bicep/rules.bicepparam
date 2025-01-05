using 'nsg-operations.bicep'

param name = 'test-nsg'

param resourceGroup = 'temp'

param securityRules = [
  {
    name: 'AZ-Allow-Inbound-Internet-AzureBastionSubnet-TCP-443'
    properties: {
      access: 'Allow'
      direction: 'Inbound'
      priority: 120
      sourceAddressPrefix: 'Internet'
      destinationAddressPrefix: '*'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '443'
    }
  }
  {
    name: 'AZ-Allow-Inbound-GatewayManager-AzureBastionSubnet-TCP-443'
    properties: {
      access: 'Allow'
      direction: 'Inbound'
      priority: 130
      sourceAddressPrefix: 'GatewayManager'
      destinationAddressPrefix: '*'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '443'
    }
  }
  {
    name: 'AZ_Allow_Inbound_AzureLB_Any_TCP_443'
    properties: {
      access: 'Allow'
      direction: 'Inbound'
      priority: 140
      sourceAddressPrefix: 'AzureLoadBalancer'
      destinationAddressPrefix: '*'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '443'
    }
  }
  {
    name: 'AZ_Allow_Inbound_VirtualNetwork_VirtualNetwork_TCP_BastionHostComms'
    properties: {
      access: 'Allow'
      direction: 'Inbound'
      priority: 150
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'VirtualNetwork'
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRanges: ['8080', '5701']
    }
  }
  {
    name: 'AZ-Deny-Inbound-Any-Any-Any-Any'
    properties: {
      access: 'Deny'
      direction: 'Inbound'
      priority: 999
      sourceAddressPrefix: '*'
      destinationAddressPrefix: '*'
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRange: '*'
    }
  }
  {
    name: 'AZ_Allow_Outbound_Any_VirtualNetwork_TCP_SSH-RDP'
    properties: {
      access: 'Allow'
      direction: 'Outbound'
      priority: 100
      sourceAddressPrefix: '*'
      destinationAddressPrefix: 'VirtualNetwork'
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRanges: ['22', '3389']
    }
  }
  {
    name: 'AZ_Allow_Outbound_Any_AzureCloud_TCP_443'
    properties: {
      access: 'Allow'
      direction: 'Outbound'
      priority: 110
      sourceAddressPrefix: '*'
      destinationAddressPrefix: 'AzureCloud'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '443'
    }
  }
  {
    name: 'AZ_Allow_Outbound_VirtualNetwork_VirtualNetwork_Any_BastionHostComms'
    properties: {
      access: 'Allow'
      direction: 'Outbound'
      priority: 120
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'VirtualNetwork'
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRanges: ['8080', '5701']
    }
  }
  {
    name: 'AZ_Allow_Outbound_Any_Internet_Any_80'
    properties: {
      access: 'Allow'
      direction: 'Outbound'
      priority: 130
      sourceAddressPrefix: '*'
      destinationAddressPrefix: 'Internet'
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRange: '80'
    }
  }
]
