param sourceVnetName string
param targetVnetName string
param allowGwTransit bool = false
param allowFowardedTraffic bool = true
param allowVnetAccess bool = true

resource sourceVnet 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: sourceVnetName
}

resource targetVnet 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: targetVnetName
}

resource sourceToTargetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = {
  name: format('{0}-{1}-peering', sourceVnetName, targetVnetName)
  parent: sourceVnet
  properties: {
    allowForwardedTraffic: allowFowardedTraffic
    allowGatewayTransit: allowGwTransit
    allowVirtualNetworkAccess: allowVnetAccess
    remoteVirtualNetwork: {
      id: targetVnet.id
    }
  }
}
