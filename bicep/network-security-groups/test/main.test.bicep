/*======================================================================
GLOBAL CONFIGURATION
======================================================================*/
@description('Optional. The geo-location where the resource lives.')
param location string = resourceGroup().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
@minLength(1)
@maxLength(5)
param shortIdentifier string = 'arn'

/*======================================================================
TEST PREREQUISITES
======================================================================*/
resource asg 'Microsoft.Network/applicationSecurityGroups@2022-01-01' = {
  name: '${shortIdentifier}-tst-asg-${uniqueString(deployment().name, 'applicationSecurityGroup', location)}'
  location: location
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: '${shortIdentifier}-tst-law-${uniqueString(deployment().name, 'logAnalyticsWorkspace', location)}'
  location: location
}

resource diagnosticsStorageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: '${shortIdentifier}tstdiag${uniqueString(deployment().name, 'diagnosticsStorageAccount', location)}'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource diagnosticsStorageAccountPolicy 'Microsoft.Storage/storageAccounts/managementPolicies@2023-01-01' = {
  parent: diagnosticsStorageAccount
  name: 'default'
  properties: {
    policy: {
      rules: [
        {
          name: 'blob-lifecycle'
          type: 'Lifecycle'
          definition: {
            actions: {
              baseBlob: {
                tierToCool: {
                  daysAfterModificationGreaterThan: 30
                }
                delete: {
                  daysAfterModificationGreaterThan: 365
                }
              }
              snapshot: {
                delete: {
                  daysAfterCreationGreaterThan: 365
                }
              }
            }
            filters: {
              blobTypes: [
                'blockBlob'
              ]
            }
          }
        }
      ]
    }
  }
}

resource diagnosticsEventHubNamespace 'Microsoft.EventHub/namespaces@2021-11-01' = {
  name: '${shortIdentifier}tstdiag${uniqueString(deployment().name, 'diagnosticsEventHubNamespace', location)}'
  location: location
}

/*======================================================================
TEST EXECUTION
======================================================================*/
module nsgMinimum '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-min-nsg'
  params: {
    name: '${uniqueString(deployment().name, location)}minnsg'
    location: location
  }
}

module nsg '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-nsg'
  params: {
    name: '${uniqueString(deployment().name, location)}nsg'
    location: location
    securityRules: [
      {
        name: 'Rule1'
        properties: {
          access: 'Allow'
          description: 'Allow Http to 10.0.1.4 from 10.0.2.10.'
          destinationAddressPrefix: '10.0.1.4'
          destinationPortRange: 80
          direction: 'Inbound'
          priority: 100
          protocol: 'Tcp'
          sourceAddressPrefix: '10.0.2.10'
          sourcePortRange: '*'
        }
      }
      {
        name: 'Rule2'
        properties: {
          access: 'Allow'
          description: 'Allow web apps to dbs.'
          destinationAddressPrefixes: [
            '10.20.0.0/24'
            '10.20.1.0/24'
          ]
          destinationPortRanges: [
            443
            1443
          ]
          direction: 'Inbound'
          priority: 200
          protocol: 'Tcp'
          sourceAddressPrefixes: [
            '10.10.0.0/24'
            '10.10.1.0/24'
          ]

          sourcePortRanges: [
            443
            1443
          ]
        }
      }
      {
        name: 'Rule3'
        properties: {
          access: 'Allow'
          description: 'Allow db comms.'
          destinationApplicationSecurityGroups: [
            {
              id: asg.id
            }
          ]
          destinationPortRanges: [
            443
            1443
          ]
          direction: 'Inbound'
          priority: 300
          protocol: 'Tcp'
          sourceApplicationSecurityGroups: [
            {
              id: asg.id
            }
          ]
          sourcePortRanges: [
            443
            1443
          ]
        }
      }
    ]
    enableDiagnostics: true
    diagnosticLogAnalyticsWorkspaceId: logAnalyticsWorkspace.id
    diagnosticStorageAccountId: diagnosticsStorageAccount.id
    diagnosticEventHubAuthorizationRuleId: '${diagnosticsEventHubNamespace.id}/authorizationrules/RootManageSharedAccessKey'
    resourceLock: 'CanNotDelete'
  }
}
