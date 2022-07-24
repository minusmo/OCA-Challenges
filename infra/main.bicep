// parameter는 bicep 바깥에서 들어오는 입력
// 값이 반드시 필요. 없으면 에러 // default 값 설정
param myName string = 'HoJoonEum'
param myEmail string = 'bldolphin96@gmail.com'
param rcname string
param location string = resourceGroup().location // 리소스 그룹이 배포된 위치

// variable은 bicep 안에서 사용되는 변수
// param과 variable의 순서는 상관이 없다.
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
// 다른 bicep 파일에서 참조 가능하게 함. 모듈화할 때 사용.
