// Log Analytics Workspace
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: 'company-log-analytics'
  location: resourceGroup().location
  properties: {
    retentionInDays: 90
  }
}

// Application Insights (δεμένο με Log Analytics)
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'company-app-insights'
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id
  }
}

// Action Group (ειδοποίηση με email)
resource actionGroup 'Microsoft.Insights/actionGroups@2022-06-01' = {
  name: 'notify-team'
  location: 'global'
  properties: {
    groupShortName: 'Team'
    enabled: true
    emailReceivers: [
      {
        name: 'StratisEmail'
        emailAddress: 'stratinavoskou@gmail.com'
        useCommonAlertSchema: true
      }
    ]
  }
}

// Alert για υψηλό CPU usage στο App Service plan
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
          criterionType: 'StaticThresholdCriterion'
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

// Alert για αποτυχία Web App
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
          criterionType: 'StaticThresholdCriterion'
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

// Alert για καθυστέρηση στη SQL Database (ανήκει σε άλλο subscription)
resource sqlLatencyAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'sql-latency-alert'
  location: 'global'
  properties: {
    description: 'Alert on SQL DB latency > 500ms'
    severity: 2
    enabled: true
    scopes: [
      '/subscriptions/<SUB_ID>/resourceGroups/<SQL_RG>/providers/Microsoft.Sql/servers/company-sql-server2025/databases/companydb2025'
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: 'DBLatency'
          metricName: 'io_latency'
          metricNamespace: 'Microsoft.Sql/servers/databases'
          operator: 'GreaterThan'
          threshold: 500
          timeAggregation: 'Average'
          criterionType: 'StaticThresholdCriterion'
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

