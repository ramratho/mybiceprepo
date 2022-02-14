param ipRangeHub string = '150'
param location string = resourceGroup().location

var companyCode = 'cws'
var environmentCode = 'hub'
var locationCode = 'chn1'
var purpAppCode = 'core'
var instanceCountCode = '01'
var ipRangeHubSubnet = '24'



module newStgAccount '../../Modules_Infra/Network/vNetGateway.bicep' ={
  name: 'newVnetGatewayModule'
  params: {
    vNetGatewayName: '${companyCode}-${environmentCode}-${locationCode}-${purpAppCode}-vgw-${instanceCountCode}'
    vNetGatewayLocation: location
    vNetGatewayType: 'Vpn'
    vNetGatewayvpnType: 'RouteBased'
  	sku: 'VpnGw2'
   	vpnGatewayGeneration: 'Generation2'
	  virtualNetworkName: '${companyCode}-${environmentCode}-${locationCode}-${purpAppCode}-vnet-${instanceCountCode}'
    gatewaySubnetName: 'GatewaySubnet'
	  subnetAddressPrefix: '10.${ipRangeHub}.1.0/27'
	  publicIpAddressName: '${companyCode}-${environmentCode}-${locationCode}-vgw-pip-${instanceCountCode}'
	  resourceGroupName: '${companyCode}-${environmentCode}-${locationCode}-${purpAppCode}-rg-${instanceCountCode}'
	
  }
}


/*
module newStgAccount '../../Modules_Infra/Network/locNetGateway.bicep' ={
  name: 'newLocalNetGatewayModule'
  params: {
    localNetworkGatewayName: '${companyCode}-${environmentCode}-${locationCode}-${purpAppCode}-lgw-${instanceCountCode}'
    lNetGatewayLocation: location
    localNetworkEndPointIpAddress: '23.99.221.164'
	localAddressPrefix1: '10.0.0.0/24'
    localAddressPrefix2: '20.0.0.0/24'
	//tag1Name: tagEnvName
    //tag1Value: environmentCode
    //tag2Name: tagApplName
	//tag2Value: applicationCode
  }
}
*/