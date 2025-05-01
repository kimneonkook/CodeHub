param storageAccountName string = 'logs${uniqueString(resourceGroup().id)}'
param location string = resourceGroup().location
param retentionDays int = 365

// Storage Account (Cool Tier + Private)
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: { name: 'Standard_ZRS' }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Cool'
    publicNetworkAccess: 'Disabled'
    minimumTlsVersion: 'TLS1_2'
  }
}

// Lifecycle Policy
resource lifecyclePolicy 'Microsoft.Storage/storageAccounts/managementPolicies@2023-01-01' = {
  name: 'default'
  parent: storageAccount
  properties: {
    policy: {
      rules: [{
        name: 'logRetentionRule'
        enabled: true
        type: 'Lifecycle'
        definition: {
          actions: {
            baseBlob: {
              tierToCool: { daysAfterModificationGreaterThan: 30 }
              delete: { daysAfterModificationGreaterThan: retentionDays }
            }
          }
          filters: {
            blobTypes: [ 'blockBlob' ]
            prefixMatch: [ 'logs/' ]
          }
        }
      }]
    }
  }
}

var tags = {
  Environment: 'Production'
  Project: 'CodeHub'
  Team: 'Univators'
  CostCenter: 'Marketing'
  Compliance: 'GDPR'
}


// Private Endpoint
resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: 'vnet-logstorage'
  location: location
  properties: {
    addressSpace: { addressPrefixes: [ '10.1.0.0/16' ] }
    subnets: [{
      name: 'subnet-private-endpoint'
      properties: {
        addressPrefix: '10.1.1.0/24'
        privateEndpointNetworkPolicies: 'Enabled'
      }
    }]
  }
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-05-01' = {
  name: 'pe-${storageAccountName}-blob'
  location: location
  properties: {
    subnet: { id: '${vnet.id}/subnets/subnet-private-endpoint' }
    privateLinkServiceConnections: [{
      name: 'pls-blob'
      properties: {
        privateLinkServiceId: storageAccount.id
        groupIds: [ 'blob' ]
      }
    }]
  }
}
