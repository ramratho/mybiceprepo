
param azureFirewallLocation string = resourceGroup().location

@description('Azure Firewall Policy Name')
param azureFirewallPolicyName string 

param firewallRouteTableName string
param firewallRoutesName string
param addressPrefix string

@description('Priority of Application Rule')
param applicationRulePriority int
@description('Name to Allow Website in Application Rule')
param webNametoAllowInAppRule string
@description('Target FQDN Name')
param targetFqdnsName string
@description('IP Address Range to open for Application Rule')
param sourceAddressPrefixes string


param firewallPrivateIpAddress string
param firewallPublicIpAddress  string
param virtualMachinePrivateIpAddress string


@description('Existing Azure Firewall Policy Reference.')
resource azureFirewallPolicyResource 'Microsoft.Network/firewallPolicies@2020-11-01' existing = {
  name:  azureFirewallPolicyName
}


resource azureFirewall_RouteTableResource 'Microsoft.Network/routeTables@2020-11-01' = {
  name: firewallRouteTableName
  location: azureFirewallLocation
   properties: {
    disableBgpRoutePropagation: false
  }
}

resource azureFirewall_RouteResource 'Microsoft.Network/routeTables/routes@2020-11-01' = {
  parent: azureFirewall_RouteTableResource
  name: firewallRoutesName
  properties: {
    addressPrefix: addressPrefix
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: firewallPrivateIpAddress
    hasBgpOverride: false
  }
}


resource ApplicationRuleCollection 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2020-11-01' = {
  parent: azureFirewallPolicyResource
  name: 'DefaultApplicationRuleCollectionGroup'
  properties: {
    priority: applicationRulePriority
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: webNametoAllowInAppRule 
            protocols: [
              {
                protocolType: 'Http'
                port: 80
              }
              {
                protocolType: 'Https'
                port: 443
              }
            ]
            fqdnTags: []
            webCategories: []
            targetFqdns: [
               targetFqdnsName
            ]
            targetUrls: []
            terminateTLS: false
            sourceAddresses: [
               sourceAddressPrefixes
            ]
            destinationAddresses: []
            sourceIpGroups: []
          }
        ]
        name: webNametoAllowInAppRule
        priority: applicationRulePriority
      }
     ]
  }
}

resource DNATRuleCollection 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2020-11-01' = {
  parent: azureFirewallPolicyResource
  name: 'DefaultDnatRuleCollectionGroup'
  //location: 'westus'
  properties: {
    priority: 100
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyNatRuleCollection'
        action: {
          type: 'DNAT'
        }
        rules: [
          {
            ruleType: 'NatRule'
            name: 'rdp-nat'
            translatedAddress:  virtualMachinePrivateIpAddress
            translatedPort: '3389'
            ipProtocols: [
              'TCP'
            ]
            sourceAddresses: [
              '*'
            ]
            sourceIpGroups: []
            destinationAddresses: [
               firewallPublicIpAddress
            ]
            destinationPorts: [
              '3389'
            ]
          }
        ]
        name: 'rdp'
        priority: 200
      }
    ]
  }
}

resource NetworkRuleCollection 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2020-11-01' = {
  parent: azureFirewallPolicyResource
  name: 'DefaultNetworkRuleCollectionGroup'
  properties: {
    priority: 200
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'Allow-DNS'
            ipProtocols: [
              'UDP'
            ]
            sourceAddresses: [
              sourceAddressPrefixes
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '209.244.0.3'
              '209.244.0.4'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '53'
            ]
          }
        ]
        name: 'Net-Coll01'
        priority: 200
      }
    ]
  }
}
