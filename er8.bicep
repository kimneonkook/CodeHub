// Log Analytics Workspace
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: 'company-log-analytics'
  location: 'westeurope'
  sku: {
    name: 'PerGB2018'
  }
  properties: {
    retentionInDays: 90
  }
}

// Application Insights (connected with Log Analytics)
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'company-app-insights'
  location: 'westeurope'
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id
  }
}

// Alert for high CPU
resource cpuAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'high-cpu-app-plan'
  location: 'global'
  properties: {
    description: 'Alert when CPU usage > 80% for 5 minutes on App Plan'
    severity: 2
    enabled: true
    scopes: [
      resourceId('Microsoft.Web/serverfarms', 'multisoft-api-plan')
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: 'HighCPU'
          metricName: 'CpuPercentage'
          metricNamespace: 'Microsoft.Web/serverfarms'
          operator: 'GreaterThan'
          threshold: 80
          timeAggregation: 'Average'
        }
      ]
    }
    actions: []
  }
}

// Failed webApp - error
resource webAppFailureAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'webapp-failure-alert'
  location: 'global'
  properties: {
    description: 'Alert on 5xx HTTP responses'
    severity: 2
    enabled: true
    scopes: [
      resourceId('Microsoft.Web/sites', 'multisoft-webapp-2025')
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: 'ServerErrors'
          metricName: 'Http5xx'
          metricNamespace: 'Microsoft.Web/sites'
          operator: 'GreaterThan'
          threshold: 10
          timeAggregation: 'Total'
        }
      ]
    }
    actions: []
  }
}
