param location string = 'switzerlandnorth'
var tags = {
  environment: 'lab'
  project: 'hub-spoke'
}
var dnsZoneConfig = [
  {
    name: 'privatelink.azurewebsites.net'
    registrationEnabled: false
    resourceGroupName: hubNetworks[0].resourceGroupName
  }
  {
    name: format('privatelink{1}', 'sqlserver', environment().suffixes.sqlServerHostname)
    registrationEnabled: false
    resourceGroupName: hubNetworks[0].resourceGroupName
  }
  // private link for keyvault
  {
    name: format('privatelink{1}', 'vault', environment().suffixes.keyvaultDns)
    registrationEnabled: false
    resourceGroupName: hubNetworks[0].resourceGroupName
  }
  {
    name: 'hub-spoke-lab.local'
    registrationEnabled: true
    resourceGroupName: hubNetworks[0].resourceGroupName
  }
]
var hubNetworks = [
  {
    vnetNameSuffix: 'hub-lab'
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
    vnetNameSuffix: 'devvms-lab'
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
    vnetNameSuffix: 'app-lab'
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
var dnsZoneResourceGroupName = hubNetworks[0].resourceGroupName
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
  name: format('vnetRes-{0}', vnet.vnetNameSuffix)
  params: {
    name: vnet.vnetNameSuffix
    location: location
    tags: tags
    vnetAddressPrefix: vnet.addressPrefixes
    subnetConfig: vnet.subnets
  }
  scope: resourceGroup(vnet.resourceGroupName)
}]
module spokeVirtualNetworks 'virtualNetwork.bicep' = [for vnet in spokeNetworks: {
  name: format('vnetRes-{0}', vnet.vnetNameSuffix)
  params: {
    name: vnet.vnetNameSuffix
    location: location
    tags: tags
    vnetAddressPrefix: vnet.addressPrefixes
    subnetConfig: vnet.subnets
  }
  scope: resourceGroup(vnet.resourceGroupName)
}]

module associateToSpokeNetwork 'associatePrivateDns.bicep' = [for vnet in spokeNetworks: {
  name: format('dnsToVnetLink-{0}', vnet.vnetNameSuffix)
  params: {
    tags: tags
    dnsZoneConfig: dnsZoneConfig
    vnetName: vnet.vnetNameSuffix
    vnetResourceGroupName: vnet.resourceGroupName
    location: 'global'
  }
}]

module associateToHubNetwork 'associatePrivateDns.bicep' = [for vnet in hubNetworks: {
  name: format('dnsToVnetLink-{0}', vnet.vnetNameSuffix)
  params: {
    dnsZoneConfig: dnsZoneConfig
    vnetResourceGroupName: vnet.resourceGroupName
    vnetName: vnet.vnetNameSuffix
    tags: tags
    location: 'global'
  }
}]
