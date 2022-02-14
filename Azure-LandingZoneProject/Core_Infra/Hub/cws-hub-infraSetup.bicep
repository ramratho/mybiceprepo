param location string = resourceGroup().location

var companyCode = 'cws'
var environmentCode = 'hub'
var locationCode = 'chn1'
var purpAppCode = 'core'
var instanceCountCode = '01'

module VNetMod '../../Modules_Infra/Network/VNet.bicep' = {
  name: 'VNetModule'
  params: {
    vnetName: '${companyCode}-${environmentCode}-${locationCode}-${purpAppCode}-vnet-${instanceCountCode}'
    vnetLocation: location
    addressRangeEnvironment: '150'
    subnetNames: [
        '${environmentCode}-${purpAppCode}-mgmt-${instanceCountCode}'
        '${environmentCode}-${purpAppCode}-admin-${instanceCountCode}'
    ]
    addressPrefixSubnetRanges: [
        '10.150.1.0/24'
        '10.150.2.0/27'
    ]
  }
}

//---comments to stgAccount module---
//--> if storage Account is already existing: change param newStgOrExisting from 'new' to 'existing'
//possible storage Account types: 'Premium_LRS','Premium_ZRS','Standard_GRS','Standard_GZRS','Standard_LRS','Standard_RAGRS','Standard_RAGZRS','Standard_ZRS'
//possible storage types: 'BlobStarge','BlockBlobStorage','FileStorage','Storage','StorageV2'
//possible access tiers: 'Hot','Cold'

module StgAccountMod '../../Modules_Infra/StorageAccounts/stgAccount.bicep' = {
  name: 'StgAccountModule'
  params: {
    newStgOrExisting: 'existing'
    stgAccountName: '${companyCode}${environmentCode}${locationCode}${purpAppCode}tsa${instanceCountCode}'
    stgLocation: location
    stgAccountType: 'Standard_GRS'
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
  name: 'attToSubnetModule-hub-1'
  params: {
    vnetToAttachName: '${companyCode}-${environmentCode}-${locationCode}-${purpAppCode}-vnet-${instanceCountCode}'
    subnetToAttachName: 'hub-core-mgmt-01'
    subnetAddressPrefixToAttach: '10.150.1.0/24'
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
  name: 'attToSubnetModule-hub-2'
  params: {
    vnetToAttachName: '${companyCode}-${environmentCode}-${locationCode}-${purpAppCode}-vnet-${instanceCountCode}'
    subnetToAttachName: 'hub-core-admin-01'
    subnetAddressPrefixToAttach: '10.150.2.0/27'
    nsgIdAttached: resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', '${companyCode}-${environmentCode}-${locationCode}-core-${resourceCodeNSG}-${instanceCountCode}')
    routeTableIdAttached: resourceId(resourceGroup().name, 'Microsoft.Network/routeTables', '${companyCode}-${environmentCode}-${locationCode}-core-${resourceCodeRTbl}-${instanceCountCode}')
  }
dependsOn: [
    attachToSubnetMod1
  ]
}
