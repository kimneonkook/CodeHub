// Parameters
param location string = 'westerneurope'
param webAppName string = 'multisoft-webapp-2025'
param appServicePlanName string = 'multisoft-asp-2025'

// Tags
var tags = {
  Environment: 'Production'
  Project: 'CodeHub'
  Team: 'Univators'
  CostCenter: 'Marketing'
  Compliance: 'GDPR'
}

// App Service Plan (Standard S1)
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  tags: tags
  sku: {
    name: 'S1'          // Standard tier 
    tier: 'Standard'
    capacity: 1         // Single instance for ~1000 visits/day
  }
  kind: 'windows'       // Windows for .NET 8
  properties: {
    reserved: false     // only for WINDOWS
  }
}

// Web App (net 8)
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  tags: tags
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      windowsFxVersion: 'DOTNET|8.0'
      alwaysOn: true                  // Critical for production
      http20Enabled: true             // Performance optimization
      minTlsVersion: '1.2'            // Security alignment with storage
      ftpsState: 'Disabled'           // Disable insecure FTP
    }
    httpsOnly: true                   // Enforce HTTPS
  }
}

// 3. Outputs
output webAppName string = webApp.name
output webAppHostName string = webApp.properties.defaultHostName
