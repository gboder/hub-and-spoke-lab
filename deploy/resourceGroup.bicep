param location string
param name string
param tags array

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01'= {
  name: 'myResourceGroup'
  location: 'westus'
  tags: {
    environment: 'dev'
  }
}
