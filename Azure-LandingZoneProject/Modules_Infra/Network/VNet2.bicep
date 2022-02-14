param vnetName string
param vnetLocation string
param addressRangeEnvironment string
//param subnetPrefix string
//param subnetSuffix string
param subnetNames array
param addressPrefixSubnetRanges array
param nsgIDs array

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
        networkSecurityGroup: {
          id: '${nsgIDs[i]}'
        }
      }
    }]
  }
}