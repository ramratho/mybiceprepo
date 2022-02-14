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
//possible storage Account types: 'Premium_LRS','Premium_ZRS','Standard_GRS','Standard_GZRS','Standard_LRS','Standard_RAGRS','Standard_RAGZRS','Standard_ZRS'
//possible storage types: 'BlobStarge','BlockBlobStorage','FileStorage','Storage','StorageV2'
//possible access tiers: 'Hot','Cold'

module StgAccountMod '../../Modules_Infra/StorageAccounts/stgAccount.bicep' ={
  name: 'StgAccountModule'
  params: {
    stgAccountName: '${companyCode}${environmentCode}${locationCode}${purpAppCode}stg${instanceCountCode}'
    stgLocation: location
    stgAccountType: 'Standard_LRS'
    stgType: 'StorageV2'
    accTr: 'Hot'
  }
}