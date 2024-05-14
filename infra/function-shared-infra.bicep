
@description('Location of all resources')
param resourceLocation string = resourceGroup().location

@description('Storage Account type')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
])
param storageAccountType string = 'Standard_LRS'

@description('Name of the Storage Account')
param storageAccountName string = 'funcappsa${uniqueString(resourceGroup().id)}'
@description('Name of the Log Analytics Workspace')
param logAnalyticsName string = 'funcapplaw${uniqueString(resourceGroup().id)}'
@description('Name of the Application Insights instance')
param applicationInsightsName string = 'funcappai${uniqueString(resourceGroup().id)}'
@description('Name of the App Service Plan')
param appServicePlanName string = 'funcappasp${uniqueString(resourceGroup().id)}'

@description('The pricing tier for the hosting plan.')
@allowed([
  'D1'
  'F1'
  'B1'
  'B2'
  'B3'
  'S1'
  'S2'
  'S3'
  'P1'
  'P2'
  'P3'
  'P1V2'
  'P2V2'
  'P3V2'
  'I1'
  'I2'
  'I3'
  'Y1'
])
param sku string = 'S1'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: resourceLocation
  sku: {
    name: sku
  }
  properties: {}
}


resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: resourceLocation
  sku: {
    name: storageAccountType
  }
  kind: 'Storage'
  properties: {
    supportsHttpsTrafficOnly: true
    defaultToOAuthAuthentication: true
    allowSharedKeyAccess: false
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsName
  location: resourceLocation
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    workspaceCapping: {
      dailyQuotaGb: '0.023'
    }
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: resourceLocation
  tags: {
    'hidden-link:${resourceId('Microsoft.Web/sites', applicationInsightsName)}': 'Resource'
  }
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

output storageAccountName string = storageAccount.name
output appInsightsInstrumentationKey string = applicationInsights.properties.InstrumentationKey
output appServicePlanId string = appServicePlan.id
