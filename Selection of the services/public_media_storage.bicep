resource publicStorage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'chpub${uniqueString(resourceGroup().id)}'
  location: location
  tags: union(tags, { DataClassification: 'Public' })
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: true
  }
}
