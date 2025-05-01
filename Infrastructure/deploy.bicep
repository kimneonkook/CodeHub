targetScope = 'resourceGroup'

@description('Location for resources.')
param location string = resourceGroup().location

@description('Admin login for SQL Server')
param administratorLogin string = 'sqladmin'

@secure()
@description('Admin password for SQL Server')
param administratorLoginPassword string

@description('SQL Database name')
param sqlDbName string = 'companydb2025'

//
// SQL Server & Database
//
resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: 'company-sql-server2025'
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: '${sqlServer.name}/${sqlDbName}'
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
}

//
// Cosmos DB
//
resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: 'company-cosmos-db-north'
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
  }
}

//
// Storage Account for private data
//
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'companystorage2025'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        blob: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

// Blob Service for private storage
resource storageBlobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: storageAccount
}

// Container inside private storage
resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: 'companydata'
  parent: storageBlobService
  properties: {
    publicAccess: 'None'
  }
}

//
// Storage Account for public media (Ερώτημα 6)
//
resource publicMediaStorage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'companypublicmedia2025'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        blob: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    allowBlobPublicAccess: true
  }
}

// Blob Service for public media storage
resource publicMediaBlobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: publicMediaStorage
}

// Public container for media (images/videos)
resource publicMediaContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: 'publicmedia'
  parent: publicMediaBlobService
  properties: {
    publicAccess: 'Blob'
  }
}
