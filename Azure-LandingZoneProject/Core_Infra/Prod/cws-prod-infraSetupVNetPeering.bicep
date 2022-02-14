var hubsubscriptionID = '5ca59c04-4e46-4ec5-b20f-f1a3311ef1e8'

var hubResourceGroup = 'cws-hub-chn1-core-rg-01'
var hubVirtualNetwork = 'cws-hub-chn1-core-vnet-01'


module newProdtoHubPeering '../../Modules_Infra/Network/prod_to_hub_Peering.bicep' ={
  name: 'newProdtoHubPeeringModule'
  params: {
    sourceVirtualNetworkName: 'cws-prod-chn1-core-vnet-01'
	targetVirtualNetworkExtID: '/subscriptions/${hubsubscriptionID}/resourceGroups/${hubResourceGroup}/providers/Microsoft.Network/virtualNetworks/${hubVirtualNetwork}'
    NetworkPeeringName: 'Prod-to-Hub'
    peeringAddressPrefixes: '10.150.0.0/16'
  }
}
