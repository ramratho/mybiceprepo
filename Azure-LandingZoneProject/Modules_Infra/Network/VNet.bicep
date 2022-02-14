param vnetName string
param vnetLocation string
param addressRangeEnvironment string
param subnetNames array
param addressPrefixSubnetRanges array

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetName
  location: vnetLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.${addressRangeEnvironment}.0.0/16'
      ]
    }
    subnets: [for (subnetName, i) in subnetNames: {
      name: subnetName
      properties: {
        addressPrefix: '${addressPrefixSubnetRanges[i]}'
      }
    }]
  }
}