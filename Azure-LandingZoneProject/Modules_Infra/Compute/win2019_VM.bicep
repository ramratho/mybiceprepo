@description('The location into which the resources should be deployed.')
param location string = resourceGroup().location

@description('The name of the storage account SKU to use for the virtual machine\'s managed disk.')
param virtualMachineManagedDiskStorageAccountType string

@description('The administrator username for the virtual machine.')
param virtualMachineAdminUsername string

@description('The administrator password for the virtual machine.')
@secure()
param virtualMachineAdminPassword string

@description('Virtual Machine Tag.')
param environment string
param applicationName string

@description('Virtual Machine Size Name.')
param virtualMachineSizeName string

@description('Virtual Machine image reference.')
var virtualMachineImageReference = {
  publisher: 'MicrosoftWindowsServer'
  offer: 'WindowsServer'
  sku: '2019-Datacenter'
  version: 'latest'
}


param resourceGroupName string
param virtualNetworkName string
param networkSubnetName string
param availabilitySetName string

//param virtualMachineOSDiskName string
param virtualMachineName string
//param networkInterfaceResourceName string
param networkSecurityGroupName string

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2020-11-01' existing = {
  name: networkSecurityGroupName
}

resource virtualMachineResource 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: virtualMachineName
  location: location
  tags: {
    Environment: environment
    ApplicationName: applicationName
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: virtualMachineSizeName
    }
    storageProfile: {
      imageReference: virtualMachineImageReference
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachineName}-osdisk-01'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: virtualMachineManagedDiskStorageAccountType
          }
        diskSizeGB: 127
      }
      
    }
    osProfile: {
      computerName: virtualMachineName
      adminUsername: virtualMachineAdminUsername
      adminPassword: virtualMachineAdminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
        }
      }
      allowExtensionOperations: true
     }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaceResource.id
        }
      ]
    }
    availabilitySet: {
      id: resourceId(resourceGroupName, 'Microsoft.Compute/availabilitySets', availabilitySetName)
    }     
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}


resource networkInterfaceResource 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: '${virtualMachineName}-nic-01'
  location: location
  tags: {
    Environment: environment
    ApplicationName: applicationName
  }
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId(resourceGroupName, 'Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, networkSubnetName)
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    networkSecurityGroup: {
      id: networkSecurityGroup.id
    }
  }
}

