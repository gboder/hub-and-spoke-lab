// Deploy an App Service in the spoke
param location string = 'switzerlandnorth'


resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: 'appplan'
  location: location
  sku:{
    name: 'B1'
    tier: 'Basic'
  }
  kind: 'linux'
}
