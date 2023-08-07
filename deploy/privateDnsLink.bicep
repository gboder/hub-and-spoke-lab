param vnetName string
param vnetResourceGroupName string
param pdnsName string
param location string = 'global'
param tags object
param registrationEnabled bool = false

resource pDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: pdnsName
}

resource vnetResource 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetResourceGroupName)
}

resource hubDnsLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'vnetlink-hub-lab'
  parent: pDnsZone
  location: location
  tags: tags
  properties: {
    registrationEnabled:registrationEnabled
        virtualNetwork: {
      id: vnetResource.id
    }
  }
}
