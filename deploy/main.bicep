param location string = 'switzerlandnorth'
var tags = {
  environment: 'lab'
  project: 'hub-spoke'
}
var dnsZoneNames = [
  'privatelink.azurewebsites.net'
  'hub-spoke.lab'
]
var hubNetworks = [
  {
    name: 'vnet-hub-lab'
    addressPrefixes: [ '10.0.0.0/16' ]
    subnets: [
      {
        name: 'default'
        addressPrefix: '10.0.1.0/9'
      }
    ]
  }
]
var spokeNetworks = [
  {
    name: 'vnet-devvms-lab'
    addressPrefixes: [ '10.1.0.0/16' ]
    subnets: [
      {
        name: 'default'
        addressPrefix: '10.1.1.0/9'
      }
    ]
  }
  {
    name: 'vnet-app-lab'
    addressPrefixes: [ '10.2.0.0/16' ]
    subnets: [
      {
        name: 'default'
        addressPrefix: '10.2.1.0/9'
      }
    ]
  }
]

// Private DNS zone for app service
module privateDnsZones 'privateDnsZone.bicep' = [for dnsZoneName in dnsZoneNames: {
  name: format('pdnsZoneRes-{0}', dnsZoneName)
  params: {
    location: location
    tags: tags
    name: dnsZoneName
  }
}]


module hubVirtualNetworks 'virtualNetwork.bicep' = [for vnet in hubNetworks: {
  name: format('vnetRes-{0}', vnet.name)
  params: {
    location: location
    tags: tags
    vnetAddressPrefix: vnet.addressPrefixes
    subnetConfig: vnet.subnets
  }
}]
module spokeVirtualNetworks 'virtualNetwork.bicep' = [for vnet in spokeNetworks: {
  name: format('vnetRes-{0}', vnet.name)
  params: {
    location: location
    tags: tags
    vnetAddressPrefix: vnet.addressPrefixes
    subnetConfig: vnet.subnets
  }
}]

module associateToSpokeNetwork 'associatePrivateDns.bicep' = [for vnet in spokeNetworks: {
  name: format('dnsToVnetLink-{0}', vnet.name)
  params: {
    tags: tags
    dnsZoneNames: dnsZoneNames
    vnetName: vnet.name
  }
}]

module associateToHubNetwork 'associatePrivateDns.bicep' = [for vnet in hubNetworks: {
  name: format('dnsToVnetLink-{0}', vnet.name)
  params: {
    dnsZoneNames: dnsZoneNames
    vnetName: vnet.name
    tags: tags
  }
}]
