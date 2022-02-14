param aSetName string
param aSetLocation string
param environment string
param applicationName string
param aSetSkuName string
//param aSetSkuTier string
param aSetFaultDomainCount int
param aSetUpdateDomainCount int

resource availabilitySets 'Microsoft.Compute/availabilitySets@2021-07-01' = {
  name: aSetName
  location: aSetLocation
  tags: {
    Environment: environment
    ApplicationName: applicationName
  }
  sku: {
    name: aSetSkuName
   // tier: aSetSkuTier
  }
  properties: {
    platformFaultDomainCount: aSetFaultDomainCount
    platformUpdateDomainCount: aSetUpdateDomainCount
  }
}
