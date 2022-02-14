param diskNames array
param diskLocation string
param diskSkuNames array
param diskOsTypes array
param diskCreatOpts array
param diskSzGbs array
param diskIopsRWs array
param diskMbpsRWs array
param diskEncryptTypes array
param diskNetAccPolicys array
param diskPubNetAccs array
param environment string
param applicationName string

resource managedDisks 'Microsoft.Compute/disks@2021-04-01' = [for (diskName, i) in diskNames: {
  name: diskName
  location: diskLocation
  tags: {
    Environment: environment
    ApplicationName: applicationName
  }
  sku: {
    name: diskSkuNames[i]
  }
  properties: {
    creationData: {
      createOption: diskCreatOpts[i]
    }
    diskIOPSReadWrite: diskIopsRWs[i]
    diskMBpsReadWrite: diskMbpsRWs[i]
    diskSizeGB: diskSzGbs[i]
    encryption: {
      type: diskEncryptTypes[i]
    }
    networkAccessPolicy: diskNetAccPolicys[i]
    osType: diskOsTypes[i]
    publicNetworkAccess: diskPubNetAccs[i]
  }
}]