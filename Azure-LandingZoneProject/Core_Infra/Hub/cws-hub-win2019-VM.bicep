param location string = resourceGroup().location

var environmentNameVar = 'Hub'

/*
module AvailabilitySetMod '../../Modules_Infra/Compute/availabilitySet.bicep' = {
  name: 'availabilitySetHubModule'
  params: {
    aSetName: 'cwshubchn1coreas01'
    aSetLocation: location
    environment: environmentNameVar
    applicationName: 'Availability Sets'
    aSetSkuName: 'Aligned'
    //aSetSkuTier: 'Standard' //possible tier values: 'Basic','Standard'
    aSetFaultDomainCount: 2
    aSetUpdateDomainCount: 2
  }
}
*/

module newazureVirtualMachine '../../Modules_Infra/Compute/win2019_VM.bicep' ={
  name: 'newAzureVirtualMachine'
  params: {
           virtualMachineManagedDiskStorageAccountType: 'StandardSSD_LRS'
           virtualMachineAdminUsername: 'adminuser'
           virtualMachineAdminPassword: 'Adminuser@12345'
           virtualMachineSizeName: 'Standard_D2s_v3'
           //virtualMachineOSDiskName: 'cws-hub-disk-01' //virtualMachineName-osdisk-01
           virtualMachineName: 'cwshubchn103' //'cwshubchn102'
           resourceGroupName: 'cws-hub-chn1-core-rg-01'
           virtualNetworkName: 'cws-hub-chn1-core-vnet-01'
           networkSubnetName: 'hub-core-admin-01'
           //networkInterfaceResourceName: 'cws-hub-netIntface-01'  //virtualMachineName-nic-01
           networkSecurityGroupName: 'cws-hub-chn1-core-nsg-01'

           environment: 'Hub'
           applicationName: 'WindowsServer-VM'
           availabilitySetName: 'cwshubchn1coreas01' //'cwshubchn1coreas01'

	 		
  }
 //  dependsOn: [
   // AvailabilitySetMod
    //]
}

var vmNameAsPrefixVar = 'cwshubchn103'

module dataDiskMod '../../Modules_Infra/Compute/dataDisk.bicep' = {
    name: 'dataDiskModule'
    params: {
        diskNames: [
            '${vmNameAsPrefixVar}-datadisk-01'
        ]
        diskLocation: location
        environment: 'Hub'
        applicationName: 'DataDisks'
        diskSkuNames: [ //possible disks sku names: 'Premium_LRS','Premium_ZRS','StandardSSD_LRS','StandardSSD_ZRS','Standard_LRS','UltraSSD_LRS'
            'StandardSSD_LRS'
        ] 
        diskOsTypes: [ //possible OS: 'Linux','Windows'
            'Windows'
        ] 
        diskCreatOpts: [ //possible create options: 'Attach','Copy','CopyStart','Empty','FromImage','Import','Restore','Upload'
            'Empty'
        ] 
        diskIopsRWs: [
            500
        ]
        diskMbpsRWs: [
            60
        ]
        diskSzGbs: [
            32
        ]
        diskEncryptTypes: [ //possible encryption types: 'EncryptionAtRestWithCustomerKey','EncryptionAtRestWithPlatformAndCustomerKeys','EncryptionAtRestWithPlatformKey'
            'EncryptionAtRestWithPlatformKey'
        ] 
        diskNetAccPolicys: [ //possible policies: 'AllowAll','AllowPrivate','DenyAll'
            'AllowAll'
        ] 
        diskPubNetAccs: [ //possible public network access: 'Disabled','Enabled'
            'Enabled'
        ] 
    }
    dependsOn: [
      newazureVirtualMachine
    ]
}

module diskAttachmentMod '../../Modules_Infra/Compute/diskAttachment.bicep' = {
    name: 'diskAttachModule'
    params: {
        vmToAttachName: vmNameAsPrefixVar
        diskNameAttached: '${vmNameAsPrefixVar}-datadisk-01'
        lunId: 1
        dCrOpt: 'Attach'
        diskCaching: 'None' //possible 'None','ReadOnly','ReadWrite'
        diskIdAttached: resourceId(resourceGroup().name, 'Microsoft.Compute/disks','${vmNameAsPrefixVar}-datadisk-01')
    }
    dependsOn: [
        dataDiskMod
    ]
}


/*


module dataDiskMod '../../Modules_Infra/Compute/dataDisk.bicep' = {
    name: 'dataDiskModule'
    params: {
        diskNames: [
            '${vmNameAsPrefixVar}-datadisk-01'
        ]
        diskLocation: location
        environment: 'Hub'
        applicationName: 'DataDisks'
        diskSkuNames: [ //possible disks sku names: 'Premium_LRS','Premium_ZRS','StandardSSD_LRS','StandardSSD_ZRS','Standard_LRS','UltraSSD_LRS'
            'StandardSSD_LRS'
        ] 
        diskOsTypes: [ //possible OS: 'Linux','Windows'
            'Windows'
        ] 
        diskCreatOpts: [ //possible create options: 'Attach','Copy','CopyStart','Empty','FromImage','Import','Restore','Upload'
            'Empty'
        ] 
        diskIopsRWs: [
            500
        ]
        diskMbpsRWs: [
            60
        ]
        diskSzGbs: [
            1024
        ]
        diskEncryptTypes: [ //possible encryption types: 'EncryptionAtRestWithCustomerKey','EncryptionAtRestWithPlatformAndCustomerKeys','EncryptionAtRestWithPlatformKey'
            'EncryptionAtRestWithPlatformKey'
        ] 
        diskNetAccPolicys: [ //possible policies: 'AllowAll','AllowPrivate','DenyAll'
            'AllowAll'
        ] 
        diskPubNetAccs: [ //possible public network access: 'Disabled','Enabled'
            'Enabled'
        ] 
    }
}

module diskAttachmentMod '../../Modules_Infra/Compute/diskAttachment.bicep' = {
    name: 'diskAttachModule'
    params: {
        vmToAttachName: vmNameAsPrefixVar
        diskNameAttached: '${vmNameAsPrefixVar}-datadisk-01'
        lunId: 1
        dCrOpt: 'Attach'
        diskCaching: 'ReadOnly'
        diskIdAttached: resourceId(resourceGroup().name, 'Microsoft.Compute/disks','${vmNameAsPrefixVar}-datadisk-01')
    }
    dependsOn: [
        dataDiskMod
    ]
}

*/