param location string = 'switzerlandnorth'
var tags = {
  environment: 'lab'
  project: 'hub-spoke'
}
var dnsZoneConfig = [
  {
  name: 'privatelink.azurewebsites.net'
  registrationEnabled: false
  }
  {
  name: 'hub-spoke.lab'
  registrationEnabled: true
  }
]
var hubNetworks = [
  {
    name: 'vnet-hub-lab'
    resourceGroupName: 'rg-hubandspoke-hub-lab'
    addressPrefixes: [ '10.0.0.0/16' ]
    subnets: [
      {
        name: 'default'
        addressPrefix: '10.0.0.0/29'
      }
    ]
  }
]
var spokeNetworks = [
  {
    name: 'vnet-devvms-lab'
    resourceGroupName: 'rg-hubandspoke-spoke-devvms-lab'
    addressPrefixes: [ '10.1.0.0/16' ]
    subnets: [
      {
        name: 'default'
        addressPrefix: '10.1.0.0/29'
      }
    ]
  }
  {
    name: 'vnet-app-lab'
    resourceGroupName: 'rg-hubandspoke-spoke-app-lab'
    addressPrefixes: [ '10.2.0.0/16' ]
    subnets: [
      {
        name: 'default'
        addressPrefix: '10.2.0.0/29'
      }
    ]
  }
]

// Private DNS zone for app service
var dnsZoneResourceGroupName = resourceGroup().name
module privateDnsZones 'privateDnsZone.bicep' = [for dnsZoneConfig in dnsZoneConfig: {
  name: format('pdnsZoneRes-{0}', dnsZoneConfig.name)
  params: {
    location: 'global'
    tags: tags
    name: dnsZoneConfig.name
  }
  scope: resourceGroup(dnsZoneResourceGroupName)
}]


module hubVirtualNetworks 'virtualNetwork.bicep' = [for vnet in hubNetworks: {
  name: format('vnetRes-{0}', vnet.name)
  params: {
    location: location
    tags: tags
    vnetAddressPrefix: vnet.addressPrefixes
    subnetConfig: vnet.subnets
  }
  scope: resourceGroup(vnet.resourceGroupName)
}]
module spokeVirtualNetworks 'virtualNetwork.bicep' = [for vnet in spokeNetworks: {
  name: format('vnetRes-{0}', vnet.name)
  params: {
    location: location
    tags: tags
    vnetAddressPrefix: vnet.addressPrefixes
    subnetConfig: vnet.subnets
  }
  scope: resourceGroup(vnet.resourceGroupName)
}]

module associateToSpokeNetwork 'associatePrivateDns.bicep' = [for vnet in spokeNetworks: {
  name: format('dnsToVnetLink-{0}', vnet.name)
  params: {
    tags: tags
    dnsZoneConfig: dnsZoneConfig
    vnetName: vnet.name
    vnetResourceGroupName: vnet.resourceGroupName
    location: 'global'
  }
  scope: resourceGroup(vnet.resourceGroupName)
}]

module associateToHubNetwork 'associatePrivateDns.bicep' = [for vnet in hubNetworks: {
  name: format('dnsToVnetLink-{0}', vnet.name)
  params: {
    dnsZoneConfig: dnsZoneConfig
    vnetResourceGroupName: vnet.resourceGroupName
    vnetName: vnet.name
    tags: tags
    location: 'global'
  }
  scope: resourceGroup(vnet.resourceGroupName)
}]
