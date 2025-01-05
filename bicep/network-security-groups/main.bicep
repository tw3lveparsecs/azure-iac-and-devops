metadata name = 'Network Security Group Module'
metadata description = 'This module deploys Microsoft.Network networkSecurityGroups.'
metadata owner = 'Arinco'

@description('The resource name.')
param name string

@description('The geo-location where the resource lives.')
param location string

@description('Optional. Resource tags.')
@metadata({
  doc: 'https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources?tabs=bicep#arm-templates'
  example: {
    tagKey: 'string'
  }
})
param tags object = {}

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
param securityRules array = []

@description('Optional. Enable diagnostic logging.')
param enableDiagnostics bool = false

@description('Optional. The name of log category groups that will be streamed.')
@allowed([
  'AllLogs'
])
param diagnosticLogCategoryGroupsToEnable array = [
  'AllLogs'
]

@description('Optional. Storage account resource id. Only required if enableDiagnostics is set to true.')
param diagnosticStorageAccountId string = ''

@description('Optional. Log analytics workspace resource id. Only required if enableDiagnostics is set to true.')
param diagnosticLogAnalyticsWorkspaceId string = ''

@description('Optional. Event hub authorization rule for the Event Hubs namespace. Only required if enableDiagnostics is set to true.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Event hub name. Only required if enableDiagnostics is set to true.')
param diagnosticEventHubName string = ''

@description('Optional. Specify the type of resource lock.')
@allowed([
  'NotSpecified'
  'ReadOnly'
  'CanNotDelete'
])
param resourceLock string = 'NotSpecified'

var lockName = toLower('${nsg.name}-${resourceLock}-lck')

var diagnosticsName = toLower('${nsg.name}-dgs')

var diagnosticsLogs = [for categoryGroup in diagnosticLogCategoryGroupsToEnable: {
  categoryGroup: categoryGroup
  enabled: true
}]

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    securityRules: [for rule in securityRules: {
      name: rule.name
      properties: rule.properties
    }]
  }
}

resource lock 'Microsoft.Authorization/locks@2017-04-01' = if (resourceLock != 'NotSpecified') {
  scope: nsg
  name: lockName
  properties: {
    level: resourceLock
    notes: (resourceLock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
}

resource diagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics) {
  scope: nsg
  name: diagnosticsName
  properties: {
    workspaceId: empty(diagnosticLogAnalyticsWorkspaceId) ? null : diagnosticLogAnalyticsWorkspaceId
    storageAccountId: empty(diagnosticStorageAccountId) ? null : diagnosticStorageAccountId
    eventHubAuthorizationRuleId: empty(diagnosticEventHubAuthorizationRuleId) ? null : diagnosticEventHubAuthorizationRuleId
    eventHubName: empty(diagnosticEventHubName) ? null : diagnosticEventHubName
    logs: diagnosticsLogs
  }
}

@description('The name of the deployed network security group.')
output name string = nsg.name

@description('The resource ID of the network security group.')
output resourceId string = nsg.id
