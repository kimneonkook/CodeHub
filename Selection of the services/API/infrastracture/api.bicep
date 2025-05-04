param location string = 'westeurope' // Match your resource group

// API Management (Gateway)
resource apim 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: 'multisoft-apim'
  location: location
  sku: { name: 'Developer', capacity: 1 }
  properties: {
    publisherEmail: 'admin@multisoft.com'
    publisherName: 'MultiSoft'
  }
}
var tags = {
  Environment: 'Production'
  Project: 'CodeHub'
  Team: 'Univators'
  CostCenter: 'Marketing'
  Compliance: 'GDPR'
}

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'multisoft-api-plan'
  location: location
  sku: {
    name: 'S1'      // ← Standard tier
    tier: 'Standard'
  }
}
// API App
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'multisoft-webapi'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      windowsFxVersion: 'DOTNETCORE|6.0'  // ← Windows hosting
    }
  }
}
