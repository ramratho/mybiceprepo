param vmToAttachName string
param diskNameAttached string
param diskIdAttached string
param lunId int
param dCrOpt string
param diskCaching string

resource attachToVM 'Microsoft.Compute/virtualMachines@2021-07-01'  = {
  name: vmToAttachName
  location: resourceGroup().location
  properties: {
    storageProfile: {
        dataDisks: [
        {
          lun: lunId
          name: diskNameAttached
          createOption: dCrOpt
          caching: diskCaching
          managedDisk: diskIdAttached == '' ? null : {
            id: diskIdAttached
          }
        }
      ]
    }
  }
}