param vNetGatewayName string
param vNetGatewayLocation string
param sku string

@description('VPN Gateway Type')
@allowed([
  'Vpn'
  'ExpressRoute'
])
param vNetGatewayType string
param vpnGatewayGeneration string

@allowed([
  'RouteBased'
  'PolicyBased'
])

param vNetGatewayvpnType string
param virtualNetworkName string
param gatewaySubnetName string
param subnetAddressPrefix string
param publicIpAddressName string
param resourceGroupName string


resource virtualNetworkGateways 'Microsoft.Network/virtualNetworkGateways@2020-11-01' = {
  name: vNetGatewayName
  location: vNetGatewayLocation
  tags: {
   Environment: 'Hub'
  'ApplicationName': 'Virtual Network Gateway'
  }
  properties: {
    gatewayType: vNetGatewayType
    ipConfigurations: [
      {
        name: 'default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId(resourceGroupName, 'Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, gatewaySubnetName)
          }
          publicIPAddress: {
            id: resourceId(resourceGroupName, 'Microsoft.Network/publicIPAddresses', publicIpAddressName)
          }
        }
      }
    ]
    vpnType: vNetGatewayvpnType
    vpnGatewayGeneration: vpnGatewayGeneration
    sku: {
      name: sku
      tier: sku
    }
  }
}

resource virtualNetworkGatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2019-04-01' = {
  name: '${virtualNetworkName}/${gatewaySubnetName}'
   properties: {
    addressPrefix: subnetAddressPrefix
  }
}

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2020-08-01' = {
  name: publicIpAddressName
  location: vNetGatewayLocation
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}
