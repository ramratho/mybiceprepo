param location string = resourceGroup().location

var companyCode = 'cws'
var environmentCode = 'test'
var locationCode = 'chn1'
var purpAppCode = 'core'
var instanceCountCode = '01'

module VNetMod '../../Modules_Infra/Network/VNet.bicep' = {
  name: 'VNetModule'
  params: {
    vnetName: '${companyCode}-${environmentCode}-${locationCode}-${purpAppCode}-vnet-${instanceCountCode}'
    vnetLocation: location
    addressRangeEnvironment: '152'
    subnetNames: [
        '${environmentCode}-${purpAppCode}-publicdmz-in-${instanceCountCode}'
        '${environmentCode}-${purpAppCode}-frontend-${instanceCountCode}'
        '${environmentCode}-${purpAppCode}-backend-${instanceCountCode}'
        '${environmentCode}-${purpAppCode}-middletier-${instanceCountCode}'        
        '${environmentCode}-${purpAppCode}-admin-${instanceCountCode}'
        'AzureBastionSubnet'
    ]
    addressPrefixSubnetRanges: [
        '10.152.1.0/24'
        '10.152.2.0/24'
        '10.152.3.0/24'
        '10.152.4.0/24'
        '10.152.5.0/24'
        '10.152.6.0/24'
    ]
  }
}

//---comments to stgAccount module---
//--> if storage Account is already existing: change param newStgOrExisting to existing
//possible storage Account types: 'Premium_LRS','Premium_ZRS','Standard_GRS','Standard_GZRS','Standard_LRS','Standard_RAGRS','Standard_RAGZRS','Standard_ZRS'
//possible storage types: 'BlobStarge','BlockBlobStorage','FileStorage','Storage','StorageV2'
//possible access tiers: 'Hot','Cold'

module StgAccountMod '../../Modules_Infra/StorageAccounts/stgAccount.bicep' ={
  name: 'StgAccountModule'
  params: {
    newStgOrExisting: 'existing'
    stgAccountName: '${companyCode}${environmentCode}${locationCode}${purpAppCode}stg${instanceCountCode}'
    stgLocation: location
    stgAccountType: 'Standard_LRS'
    stgType: 'StorageV2'
    accTr: 'Hot'
  }
}

var resourceCodeNSG = 'nsg'

module netSecGrpMod '../../Modules_Infra/Network/NSG.bicep' = {
  name: 'NSGsModule'
  params: {
    nsgLocation: location
    nsgNames: [
      '${companyCode}-${environmentCode}-${locationCode}-core-${resourceCodeNSG}-${instanceCountCode}'
    ]
  }
}

var resourceCodeRTbl = 'udr'

module routTableMod '../../Modules_Infra/Network/routeTables.bicep' = {
  name: 'rtblModule'
  params: {
    rTblLocation: location
    rTblNames: [
      '${companyCode}-${environmentCode}-${locationCode}-core-${resourceCodeRTbl}-${instanceCountCode}'
    ]
  }
}

module attachToSubnetMod1 '../../Modules_Infra/Network/nsgAttachment.bicep' = {
  name: 'attToSubnetModule-test-1'
  params: {
    vnetToAttachName: '${companyCode}-${environmentCode}-${locationCode}-${purpAppCode}-vnet-${instanceCountCode}'
    subnetToAttachName: 'test-core-publicdmz-in-01'
    subnetAddressPrefixToAttach: '10.152.1.0/24'
    nsgIdAttached: resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', '${companyCode}-${environmentCode}-${locationCode}-core-${resourceCodeNSG}-${instanceCountCode}')
    routeTableIdAttached: resourceId(resourceGroup().name, 'Microsoft.Network/routeTables', '${companyCode}-${environmentCode}-${locationCode}-core-${resourceCodeRTbl}-${instanceCountCode}')
  }
dependsOn: [
    VNetMod
    netSecGrpMod
    routTableMod
  ]
}

module attachToSubnetMod2 '../../Modules_Infra/Network/nsgAttachment.bicep' = {
  name: 'attToSubnetModule-test-2'
  params: {
    vnetToAttachName: '${companyCode}-${environmentCode}-${locationCode}-${purpAppCode}-vnet-${instanceCountCode}'
    subnetToAttachName: 'test-core-frontend-01'
    subnetAddressPrefixToAttach: '10.152.2.0/24'
    nsgIdAttached: resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', '${companyCode}-${environmentCode}-${locationCode}-core-${resourceCodeNSG}-${instanceCountCode}')
    routeTableIdAttached: resourceId(resourceGroup().name, 'Microsoft.Network/routeTables', '${companyCode}-${environmentCode}-${locationCode}-core-${resourceCodeRTbl}-${instanceCountCode}')
  }
dependsOn: [
    attachToSubnetMod1
  ]
}

module attachToSubnetMod3 '../../Modules_Infra/Network/nsgAttachment.bicep' = {
  name: 'attToSubnetModule-test-3'
  params: {
    vnetToAttachName: '${companyCode}-${environmentCode}-${locationCode}-${purpAppCode}-vnet-${instanceCountCode}'
    subnetToAttachName: 'test-core-backend-01'
    subnetAddressPrefixToAttach: '10.152.3.0/24'
    nsgIdAttached: resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', '${companyCode}-${environmentCode}-${locationCode}-core-${resourceCodeNSG}-${instanceCountCode}')
    routeTableIdAttached: resourceId(resourceGroup().name, 'Microsoft.Network/routeTables', '${companyCode}-${environmentCode}-${locationCode}-core-${resourceCodeRTbl}-${instanceCountCode}')
  }
dependsOn: [
    attachToSubnetMod2
  ]
}

module attachToSubnetMod4 '../../Modules_Infra/Network/nsgAttachment.bicep' = {
  name: 'attToSubnetModule-test-4'
  params: {
    vnetToAttachName: '${companyCode}-${environmentCode}-${locationCode}-${purpAppCode}-vnet-${instanceCountCode}'
    subnetToAttachName:   'test-core-middletier-01'
    subnetAddressPrefixToAttach: '10.152.4.0/24'
    nsgIdAttached: resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', '${companyCode}-${environmentCode}-${locationCode}-core-${resourceCodeNSG}-${instanceCountCode}')
    routeTableIdAttached: resourceId(resourceGroup().name, 'Microsoft.Network/routeTables', '${companyCode}-${environmentCode}-${locationCode}-core-${resourceCodeRTbl}-${instanceCountCode}')
  }
dependsOn: [
    attachToSubnetMod3
  ]
}

module attachToSubnetMod5 '../../Modules_Infra/Network/nsgAttachment.bicep' = {
  name: 'attToSubnetModule-test-5'
  params: {
    vnetToAttachName: '${companyCode}-${environmentCode}-${locationCode}-${purpAppCode}-vnet-${instanceCountCode}'
    subnetToAttachName:   'test-core-admin-01'
    subnetAddressPrefixToAttach: '10.152.5.0/24'
    nsgIdAttached: resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', '${companyCode}-${environmentCode}-${locationCode}-core-${resourceCodeNSG}-${instanceCountCode}')
    routeTableIdAttached: resourceId(resourceGroup().name, 'Microsoft.Network/routeTables', '${companyCode}-${environmentCode}-${locationCode}-core-${resourceCodeRTbl}-${instanceCountCode}')
  }
dependsOn: [
    attachToSubnetMod4
  ]
}