@description('The name of the function app')
param appName string = 'funcapp${uniqueString(resourceGroup().id)}'

@description('Location of all resources')
param resourceLocation string = resourceGroup().location

module sharedInfra 'function-shared-infra.bicep' = {
  name: 'sharedInfra'
  params: {
  }
}

resource functionApp 'Microsoft.Web/sites@2022-09-01' = {
  name: appName
  location: resourceLocation
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: sharedInfra.outputs.appServicePlanId
    clientAffinityEnabled: false
    httpsOnly: true
    siteConfig: {
      alwaysOn: true
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      netFrameworkVersion: 'v8.0'
      appSettings: [
        {
          name: 'AzureWebJobsStorage__accountname'
          value: sharedInfra.outputs.storageAccountName
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: sharedInfra.outputs.appInsightsInstrumentationKey
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet-isolated'
        }
      ]
    }
  }
}

resource publishingPoliciesScm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01' = {
  parent: functionApp
  name: 'scm'
  properties: {
    allow: false
  }
}

resource publishingPoliciesFtp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01' = {
  parent: functionApp
  name: 'ftp'
  properties: {
    allow: false
  }
}

var storageBlobDataOwnerRole = 'b7e6dc6d-f1e8-4753-8033-0f276bb0955b'

module roleAssignment 'storage-account-role-assignment.bicep' = {
  name: 'storage-role-assignment'
  params: {
    principalId: functionApp.identity.principalId
    roleId: storageBlobDataOwnerRole
    storageAccountName: sharedInfra.outputs.storageAccountName
  }
}
