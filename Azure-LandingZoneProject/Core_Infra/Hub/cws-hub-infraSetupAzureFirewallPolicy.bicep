


module newazureFirewallPolicy '../../Modules_Infra/Network/azureFirewallPolicy.bicep' ={
  name: 'newAzureFirewallPolicy'
  params: {
    azureFirewallPolicyName: 'cws-hub-chn1-azfw-pol-01'
    firewallRouteTableName: 'fw-routeTable'
    firewallRoutesName: 'fw-routes'
    addressPrefix: '0.0.0.0/0'
    applicationRulePriority: 300
    webNametoAllowInAppRule: 'Allow-Microsoft'
    targetFqdnsName: '*.microsoft.com'
    sourceAddressPrefixes: '10.150.5.0/24'
    firewallPrivateIpAddress: '10.150.3.4'
    firewallPublicIpAddress: '20.203.147.225'
    virtualMachinePrivateIpAddress: '10.150.5.4'
  		
  }
}

