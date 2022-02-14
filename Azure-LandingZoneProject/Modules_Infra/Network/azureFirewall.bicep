param publicIpAddressName string 
param azureFirewallName string
param azureFirewallLocation string

param resourceGroupName string
param virtualNetworkName string
param azureFirewallSubnetName string

param publicIPAddressVersion string
param publicIPAllocationMethod string

param firewallPolicyName string

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: publicIpAddressName
  location: azureFirewallLocation
  tags: {
    Environment: 'Hub'
    ApplicationName: 'PublicIP-AzureFirewall'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: publicIPAddressVersion
    publicIPAllocationMethod: publicIPAllocationMethod
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}


resource firewallPolicyResource 'Microsoft.Network/firewallPolicies@2020-11-01' = {
  name: firewallPolicyName
  location: azureFirewallLocation
  properties: {
    sku: {
      tier: 'Standard'
    }
    threatIntelMode: 'Alert'
  }
}


resource azureFirewallResource 'Microsoft.Network/azureFirewalls@2020-11-01' = {
  name: azureFirewallName
  location: azureFirewallLocation
  tags: {
    Environment: 'Hub'
    ApplicationName: 'AzureFirewall'
  }
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: 'Standard'
    }
    threatIntelMode: 'Alert'
    additionalProperties: {}
    ipConfigurations: [
      {
        name: publicIpAddressName
        properties: {
          publicIPAddress: {
            id: resourceId(resourceGroupName, 'Microsoft.Network/publicIPAddresses', publicIpAddressName)
          }
          subnet: {
            id: resourceId(resourceGroupName, 'Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, azureFirewallSubnetName)
          }
        }
      }
    ]
    networkRuleCollections: []
    applicationRuleCollections: []
    natRuleCollections: []
	firewallPolicy: {
      id: firewallPolicyResource.id
    }
  }
}
