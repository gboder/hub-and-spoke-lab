param dnsZoneNames array
param vnetName string
param tags object

module pDnsAssociation 'privateDnsLink.bicep' = [for dnsZone in dnsZoneNames: {
  name: format('{0}-{1}', dnsZone.name, 'privateDnsLink')
  params:{
    location: dnsZone.location
    pdnsName: dnsZone
    vnetName: vnetName
    tags: tags
  }
}]
