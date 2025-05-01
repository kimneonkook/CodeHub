targetScope = 'resourceGroup'

@description('Primary email for alerts')
param adminEmail string = 'devops@multisoft.example.com'

@description('SMS phone number (format: 69XXXXXXXX)')
param adminPhone string = '69XXXXXXXX'

@description('Location for resources')
param location string = resourceGroup().location

param projectTag string = 'MultiSoft Cloud Migration'
param departmentTag string = 'IT'
param costCenterTag string = 'IT-2025'
param environmentTag string = 'Production'

var commonTags = {
  Project: projectTag
  Department: departmentTag
  CostCenter: costCenterTag
  Environment: environmentTag
}

// Log Analytics Workspace
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: 'multisoft-logs-${uniqueString(resourceGroup().id)}'
  location: location
  tags: commonTags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 90
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

// Action Group
resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: 'multisoft-critical-alerts'
  location: 'global'
  tags: commonTags
  properties: {
    groupShortName: 'critalert'
    enabled: true
    emailReceivers: [ { name: 'admin-email', emailAddress: adminEmail } ]
    smsReceivers: [ { name: 'oncall-sms', countryCode: '30', phoneNumber: adminPhone } ]
  }
}

// Application Insights
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'multisoft-appinsights'
  location: location
  tags: commonTags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id
  }
}

// Metric Alerts
var metricAlerts = [
  {
    name: 'WebApp-HighCPU'
    component: 'WebApp'
    description: 'Alert when WebApp CPU > 80% for 5 mins'
    scope: resourceId('Microsoft.Web/serverfarms', 'multisoft-api-plan')
    metric: 'CpuPercentage'
    namespace: 'Microsoft.Web/serverfarms'
    threshold: 80
    aggregation: 'Average'
  }
  {
    name: 'SQL-HighDTU'
    component: 'SQL'
    description: 'Alert when SQL DTU > 80%'
    scope: resourceId('Microsoft.Sql/servers/databases', 'company-sql-server2025', 'companydb2025')
    metric: 'dtu_consumption_percent'
    namespace: 'Microsoft.Sql/servers/databases'
    threshold: 80
    aggregation: 'Average'
  }
  {
    name: 'Cosmos-HighRUs'
    component: 'CosmosDB'
    description: 'Alert when Cosmos DB RUs > 80%'
    scope: resourceId('Microsoft.DocumentDB/databaseAccounts', 'company-cosmos-db-north')
    metric: 'NormalizedRUConsumption'
    namespace: 'Microsoft.DocumentDB/databaseAccounts'
    threshold: 0.8
    aggregation: 'Maximum'
  }
  {
    name: 'Storage-ThrottlingErrors'
    component: 'Storage'
    description: 'Alert when storage throttling errors occur'
    scope: resourceId('Microsoft.Storage/storageAccounts', 'companystorage2025')
    metric: 'ThrottlingError'
    namespace: 'Microsoft.Storage/storageAccounts'
    threshold: 5
    aggregation: 'Count'
  }
  {
    name: 'APIM-FailedRequests'
    component: 'APIM'
    description: 'Alert when API failed requests > 10/min'
    scope: resourceId('Microsoft.ApiManagement/service', 'multisoft-apim')
    metric: 'FailedRequests'
    namespace: 'Microsoft.ApiManagement/service'
    threshold: 10
    aggregation: 'Total'
  }
]

resource metricAlertsResources 'Microsoft.Insights/metricAlerts@2018-03-01' = [for item in metricAlerts: {
  name: item.name
  location: 'global'
  tags: {
    Component: item.component
    Severity: 'High'
  }
  properties: {
    description: item.description
    severity: 2
    enabled: true
    scopes: [ item.scope ]
    criteria: {
      allOf: [
        {
          metricName: item.metric
          metricNamespace: item.namespace
          operator: 'GreaterThan'
          threshold: item.threshold
          timeAggregation: item.aggregation
        }
      ]
    }
    actions: [
      {
        actionGroupId: actionGroup.id
      }
    ]
  }
}]

// Web App with App Insights config
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'multisoft-webapi'
  location: location
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', 'multisoft-api-plan')
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
      ]
    }
  }
}
