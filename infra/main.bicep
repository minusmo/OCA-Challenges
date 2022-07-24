param myName string = 'HoJoonEum'
param myEmail string = 'bldolphin96@gmail.com'
param rcname string
param location string = resourceGroup().location

var ID = resourceGroup().id
var uniqueName = uniqueString(ID)
var storageAccountDevName = 'Standard_LRS'
var appServiceDevName = 'Y1'
var apiManagmentDevName = 'Basic'
var logAnalyticsDevName = 'Free'


resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: 'StorageAccount${rcname}${uniqueName}'
  location: location
  kind: 'Storage'
  sku: {
    name: storageAccountDevName
  }
  properties: {
    accessTier: 'Hot'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: 'AppServicePlan${rcname}${uniqueName}'
  location: location
  sku: {
    name: appServiceDevName
    tier: 'Dynamic'
  }
}

resource apiManagement 'Microsoft.ApiManagement/service@2021-12-01-preview' = {
  name: 'ApiManagement${rcname}${uniqueName}'
  location: location
  sku: {
    name: apiManagmentDevName
    capacity: 1
  }
  properties: {
    publisherEmail: myEmail
    publisherName: myName
  }
}

resource azureFunction 'Microsoft.Web/sites@2021-03-01' = {
  name: 'AzureFunction${rcname}${uniqueName}'
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
  }
}

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: 'LogAnalytics${rcname}${uniqueName}'
  location: location
  properties: {
    sku: {
      name: logAnalyticsDevName
    }

  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'ApplicationInsights${rcname}${uniqueName}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
  }
}
