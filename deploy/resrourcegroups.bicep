param location string = 'switzerlandnorth'
param resourceGroupNames array
param subscriptionId

resource resourceGroups 'Microsoft.Resources/resourceGroups@2022-09-01' = [for resourceGroupName in resourceGroupNames: {
  name: resourceGroupName
  location: location
  scope: subscription(subscriptionId)
}]
