param location string = resourceGroup().location


module newcisUbuntuMachine '../../Modules_Infra/Compute/cis-ubuntu-20.04-vm.bicep' ={
  name: 'newcisUbuntuMachine'
  params: {
           virtualMachineManagedDiskStorageAccountType: 'StandardSSD_LRS'
           virtualMachineAdminUsername: 'adminuser'
           virtualMachineAdminPassword: '!CW42admin!CW42admin'
           virtualMachineSizeName: 'Standard_D2s_v3'
           virtualMachineName: 'cwshubchn1ux01'
           resourceGroupName: 'cws-hub-chn1-core-rg-01'
           virtualNetworkName: 'cws-hub-chn1-core-vnet-01'
           networkSubnetName: 'hub-core-admin-01'
           networkSecurityGroupName: 'cws-hub-chn1-core-nsg-01'
           availabilitySetName: 'cwshubchn1coreas01'

           environment: 'Hub'
           applicationName: 'CIS-LinuxServer'

	  
  		
  }
}


var vmNameAsPrefixVar = 'cwshubchn1ux01'

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