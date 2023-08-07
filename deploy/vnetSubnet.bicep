param name string = 'default'
param subnetPrefix string = '10.0.0.0/29'
param vnetName string

resource subnetResource 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: vnetName
}

resource vnetSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  name: name
  parent: subnetResource
  properties: {
    addressPrefix: subnetPrefix
  }
}
