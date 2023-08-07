param tags object
param location string = 'global'
param name string

resource privateDns 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: name
  location: location
  tags: tags
}
