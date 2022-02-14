var hubsubscriptionID = '5ca59c04-4e46-4ec5-b20f-f1a3311ef1e8'


var hubResourceGroup = 'cws-hub-chn1-core-rg-01'
var hubVirtualNetwork = 'cws-hub-chn1-core-vnet-01'


module newTesttoHubPeering '../../Modules_Infra/Network/test_to_hub_Peering.bicep' ={
  name: 'newTesttoHubPeeringModule'
  params: {
    sourceVirtualNetworkName: 'cws-test-chn1-core-vnet-01'
	targetVirtualNetworkExtID: '/subscriptions/${hubsubscriptionID}/resourceGroups/${hubResourceGroup}/providers/Microsoft.Network/virtualNetworks/${hubVirtualNetwork}'
    NetworkPeeringName: 'Test-to-Hub'
    peeringAddressPrefixes: '10.150.0.0/16'
  }
}
