var prodsubscriptionID = '5ca59c04-4e46-4ec5-b20f-f1a3311ef1e8'
var testsubscriptionID = '5ca59c04-4e46-4ec5-b20f-f1a3311ef1e8'


var prodResourceGroup = 'cws-prod-chn1-core-rg-01'
var prodVirtualNetwork = 'cws-prod-chn1-core-vnet-01'
var testResourceGroup = 'cws-test-chn1-core-rg-01'
var testVirtualNetwork = 'cws-test-chn1-core-vnet-01'

module newHubtoProdPeering '../../Modules_Infra/Network/hub_to_prod_Peering.bicep' ={
  name: 'newHubtoProdPeeringModule'
  params: {
    sourceVirtualNetworkName: 'cws-hub-chn1-core-vnet-01'
	targetVirtualNetworkExtID: '/subscriptions/${prodsubscriptionID}/resourceGroups/${prodResourceGroup}/providers/Microsoft.Network/virtualNetworks/${prodVirtualNetwork}'
    NetworkPeeringName: 'Hub-to-Prod'
    peeringAddressPrefixes: '10.151.0.0/16'
  }
}

module newHubtoTestPeering '../../Modules_Infra/Network/hub_to_test_Peering.bicep' ={
  name: 'newHubtoTestPeeringModule'
  params: {
    sourceVirtualNetworkName: 'cws-hub-chn1-core-vnet-01'
	targetVirtualNetworkExtID: '/subscriptions/${testsubscriptionID}/resourceGroups/${testResourceGroup}/providers/Microsoft.Network/virtualNetworks/${testVirtualNetwork}'
    NetworkPeeringName: 'Hub-to-Test'
    peeringAddressPrefixes: '10.152.0.0/16'
  }
}

