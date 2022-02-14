@description('The location into which the resources should be deployed.')
param lNetGatewayLocation string = resourceGroup().location

@description('Name of Local Network Gateway.')
param localNetworkGatewayName string

@description('The local network address prefixes')
param localAddressPrefix1 string
param localAddressPrefix2 string

@description('The Local End Point IP Address.')
param localNetworkEndPointIpAddress string

resource localNetworkGateways 'Microsoft.Network/localNetworkGateways@2020-11-01' = {
  name: localNetworkGatewayName
  location: lNetGatewayLocation
  properties: {
    localNetworkAddressSpace: {
      addressPrefixes: [
        localAddressPrefix1
        localAddressPrefix2
      ]
    }
    gatewayIpAddress: localNetworkEndPointIpAddress
  }
}
