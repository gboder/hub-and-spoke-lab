param location string = 'global'
param name string = 'hub-lab'
param tags object = {
  environment: 'lab'
  project: 'hub-and-spoke'
}
param vnetAddressPrefix array = ['10.0.0.0/16']
param subnetConfig array = [
  {
    name: 'default'
    addressPrefix: '10.0.1.0/29'
  }
]

resource vnetResource 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: name
  tags: tags
  location: location
  resource DefaultSubnet 'subnets' existing = {
    name: 'default'
  }
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressPrefix
    }
  }
}

module subnets 'vnetSubnet.bicep' = [for subnet in subnetConfig: {
  name: format('subnetRes-{0}-{1}',vnetResource.name , subnet.name)
  params: {
    vnetName: vnetResource.name
    subnetPrefix: subnet.addressPrefix
    name: subnet.name
}}]

output vnetId string = vnetResource.id
