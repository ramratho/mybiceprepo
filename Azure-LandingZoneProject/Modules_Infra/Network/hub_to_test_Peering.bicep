
@description('Name of the Virtual Network Peering Connection.')
param NetworkPeeringName string
//param NetworkPeeringName string = 'Hub-to-Prod'

@description('Name of the Hub Core Virtual Network.')
param sourceVirtualNetworkName string
//param hubCoreVirtualNetworkName string = 'Hub-VNet'

@description('AddressPrefixes of the Prod Virtual Network')
param peeringAddressPrefixes string

@description('Prod Virtual Network Resource ID.')
param targetVirtualNetworkExtID string
//param prodVirtualNetworkExternalid string = '/subscriptions/5ca59c04-4e46-4ec5-b20f-f1a3311ef1e8/resourceGroups/Spoke-First-RG/providers/Microsoft.Network/virtualNetworks/First-Spoke-VNet'

@description('Hub Core existing defined Virtual Network Reference.')
resource hubVirtualNetwork 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: sourceVirtualNetworkName
}

resource Hub_to_Prod_NetworkPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = {
  parent: hubVirtualNetwork
  name: NetworkPeeringName
  properties: {
    peeringState: 'Connected'
    remoteVirtualNetwork: {
      id: targetVirtualNetworkExtID
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
    remoteAddressSpace: {
      addressPrefixes: [
          peeringAddressPrefixes
      ]
    }
  }
}


