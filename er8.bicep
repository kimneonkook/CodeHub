param location string = 'westeurope'
param actionGroupName string = 'CriticalAlertsActionGroup'
param emailReceiver string = 'evoskou@uth.gr' 

// Action Group 
resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: actionGroupName
  location: 'global'
  properties: {
    groupShortName: 'critalert'
    enabled: true
    emailReceivers: [
      {
        name: 'admin-email'
        emailAddress: emailReceiver
      }
    ]
  }
}

//WebApp
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'multisoft-insights-${uniqueString(resourceGroup().id)}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id  // Σύνδεση με Log Analytics
  }
}

// connects with the webApp
resource webApp 'Microsoft.Web/sites@2022-03-01' existing = {
  name: 'multisoft-webapp-2025'
}

// Alert for WebApp CPU > 80%
resource webAppCpuAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'WebAppHighCPUAlert'
  location: 'global'
  properties: {
    description: 'Alert when WebApp CPU exceeds 80% for 5 minutes'
    severity: 2
    enabled: true
    scopes: [
      resourceId('Microsoft.Web/serverfarms', 'multisoft-asp-2025') // Υπάρχον App Service Plan
    ]
    criteria: {
      allOf: [
        {
          metricName: 'CpuPercentage'
          metricNamespace: 'Microsoft.Web/serverfarms'
          operator: 'GreaterThan'
          threshold: 80
          timeAggregation: 'Average'
        }
      ]
    }
    actions: [
      {
        actionGroupId: actionGroup.id
      }
    ]
  }
}

//Alert for SQL Database(>80%)
resource sqlDtuAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'SQLHighDTUAlert'
  location: 'global'
  properties: {
    description: 'Alert when SQL DTU consumption exceeds 80%'
    severity: 2
    enabled: true
    scopes: [
      resourceId('Microsoft.Sql/servers/databases', 'company-sql-server2025', 'companydb2025') // Υπάρχον SQL DB
    ]
    criteria: {
      allOf: [
        {
          metricName: 'dtu_consumption_percent'
          metricNamespace: 'Microsoft.Sql/servers/databases'
          operator: 'GreaterThan'
          threshold: 80
          timeAggregation: 'Average'
        }
      ]
    }
    actions: [
      {
        actionGroupId: actionGroup.id
      }
    ]
  }
}

//Alert for Storage
resource storageThrottlingAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'StorageThrottlingAlert'
  location: 'global'
  properties: {
    description: 'Alert when storage requests are throttled'
    severity: 2
    enabled: true
    scopes: [
      resourceId('Microsoft.Storage/storageAccounts', 'companystorage2025') // Από Ερώτημα 3
    ]
    criteria: {
      allOf: [
        {
          metricName: 'ThrottlingError'
          metricNamespace: 'Microsoft.Storage/storageAccounts'
          operator: 'GreaterThan'
          threshold: 0
          timeAggregation: 'Count'
        }
      ]
    }
    actions: [
      {
        actionGroupId: actionGroup.id
      }
    ]
  }
}

// Log Analytics Workspace (90 days)
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: 'multisoft-logs-${uniqueString(resourceGroup().id)}'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 90
  }
}
