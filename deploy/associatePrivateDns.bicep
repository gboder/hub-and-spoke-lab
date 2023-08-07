param dnsZoneConfig array
param vnetName string
param vnetResourceGroupName string
param tags object
param location string = 'global'

module pDnsAssociation 'privateDnsLink.bicep' = [for dnsZone in dnsZoneConfig: {
  name: format('{0}-{1}', dnsZone, 'privateDnsLink')
  params:{
    location: location
    pdnsName: dnsZone.name
    registrationEnabled: dnsZone.registrationEnabled
    vnetResourceGroupName: vnetResourceGroupName
    vnetName: vnetName
    tags: tags
  }
}]
