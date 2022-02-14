param location string = resourceGroup().location


module newazureFirewall '../../Modules_Infra/Network/azureFirewall.bicep' ={
  name: 'newAzureFirewallModule'
  params: {
      azureFirewallName: 'cws-hub-chn1-azfw-01'
      azureFirewallLocation: location
	  resourceGroupName: 'cws-hub-chn1-core-rg-01'
	  virtualNetworkName: 'cws-hub-chn1-core-vnet-01'
	  publicIpAddressName: 'cws-hub-chn1-azfw-pip-01'
	  firewallPolicyName: 'cws-hub-chn1-azfw-pol-01'
      azureFirewallSubnetName: 'AzureFirewallSubnet'
      publicIPAddressVersion: 'IPv4'
      publicIPAllocationMethod: 'Static'
	  
  		
  }
}

