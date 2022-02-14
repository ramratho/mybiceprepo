param location string = resourceGroup().location

var environmentNameVar = 'Hub'

//possible permissions to secrets: 'all','backup','create','delete','deleteisusers','get','getisusers','import','list','listisusers','managecontacts','manageisusers','purge','recover','restore','setisusers','update'
param certPermSettings array = []

//possible permissions to secrets: 'all','backup','create','decrypt','delete','encrypt','get','import','list','purge','recover','release','restore','rotate','sign','unwrapKey','update','verify',wrapKey'
param keyPermSettings array = []

//possible permissions to secrets: 'all','backup','delete','get','list','purge','recover','restore','set'
param secPermSettings array = [
  'all'
  'backup'
  'delete'
  'get'
  'list'
  'purge'
  'recover'
  'restore'
  'set'
]

//possible permissions to secrets: 'all','backup','delete','deletesas','get','getsas','list','listsas','purge','recover','regeneratekey','restore','set','setsas','update'
param stgPermSettings array = []

module KeyVaultMod '../../Modules_Infra/SecurityRecovery/keyVault.bicep' = {
  name: 'keyVaultHubModule'
  params: {
    kvName: 'testkv23122021'
    kvLocation: resourceGroup().location
    tagEnviName: environmentNameVar
    tagApplName: 'Key vaults'
    kvCreateMode: 'default' //possible createMode: 'default', 'recover'. if recover, no access policies required
    aadTenantId: tenant().tenantId
    aadApplId: '37af483b-50f3-442c-bfea-a14862cd2cde' //check before deployment
    aadObjectId: 'fa6aa0af-871b-43b4-bac8-4b8b675962b9' //check before deployment
    certsPermissions: certPermSettings
    keysPermissions: keyPermSettings
    secretsPermissions: secPermSettings
    stgPermissions: stgPermSettings
    enblKvDeploy: false
    enblKvDiskEncryp: false
    enblKvTmplDeploy: false
    enblKvRbacAuthor: false
    enblKvSoftDel: true
    kvSkuFamily: 'A'
    kvSkuName: 'Standard' //possible Key Vault names: 'Standard', 'Premium'
    kvSoftDelRetD: 90
  }
}

module RecServVaultMod '../../Modules_Infra/SecurityRecovery/recoveryServiceVault.bicep' = {
  name: 'recServVaultHubModule'
  params: {
    rsvName: 'testrsv22122021'
    rsvLocation: location
    tagEnviName: environmentNameVar
    tagApplName: 'Recovery Services Vaults'
    rsvSkuName: 'Standard' //possible recoveryServiceVault names: 'RS0', 'Standard'
    rsvSkuTier: 'Standard'
  }
}

var rsvBuRunTimeVar = '2021-12-21T23:00:00Z'

module rsvBuPoliciesMod '../../Modules_Infra/SecurityRecovery/rsvBuPolicy.bicep' = {
  name: 'rsvBuPoliciesHubModule'
  params: {
    rsvParentName: 'testrsv22122021'
    rsvBuPolicyName: 'vm-daily-2300-UTC'
    rsvBuPolicyLocation: location
    tagEnviName: environmentNameVar
    tagApplName: 'Backup policies'    
    rsvBuMgmtType: 'AzureIaasVM' //possible backupManagementTypes: 'AzureIaasVM','AzureSql','AzureStorage',AzureWorkload','GenericProtectionPolicy','MAB'
    rsvInstRestoreDays: 2
    rsvBuRetPolType: 'LongTermRetentionPolicy'
    rsvBuRetRunTime: rsvBuRunTimeVar
    rsvBuRetDurCount: 7
    rsvBuRetDurType: 'Days'
    rsvBuSchPolType: 'SimpleSchedulePolicy'
    rsvBuSchRunFreq: 'Daily'
    rsvBuSchRunTime: rsvBuRunTimeVar
    rsvBuTimeZone: 'UTC'
  }
  dependsOn: [
    RecServVaultMod
  ]
}

module logAlyxWsMod '../../Modules_Infra/Analytics/logAlyxWs.bicep' = {
  name: 'lgaModule'
  scope: resourceGroup(subscription().subscriptionId, 'cws-hub-chn1-core-rg-01')
  params: {
    lgaName: 'testlga22122021'
    lgaLocation: location
    tagEnviName: environmentNameVar
    tagApplName: 'Log Analytics workspaces'
    lgaSkuName: 'PerGB2018' //possible workspace SKU names: 'CapacityReservation','Free','LACluster','PerGB2018','PerNode','Premium','Standalone','Standard'
  }
}
