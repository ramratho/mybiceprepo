param vnetToAttachName string
param subnetToAttachName string
param subnetAddressPrefixToAttach string
param nsgIdAttached string
param routeTableIdAttached string 

resource attachToSubnets 'Microsoft.Network/virtualNetworks/subnets@2020-07-01'  = {
  name: '${vnetToAttachName}/${subnetToAttachName}'
  properties: {
    addressPrefix: subnetAddressPrefixToAttach
    networkSecurityGroup: nsgIdAttached == '' ? null : {
      id: nsgIdAttached
    }
    routeTable: routeTableIdAttached == '' ? null : {
      id: routeTableIdAttached
    }
  }
}