@description('Storage Account type')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param stgAccountType string
param stgLocation string
param stgAccountName string

@description('Storage type')
@allowed([
  'BlobStorage'
  'BlockBlobStorage'
  'FileStorage'
  'Storage'
  'StorageV2'
])
param stgType string
param accTr string

@allowed([
  'new'
  'existing'
])
param newStgOrExisting string

resource stgAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = if (newStgOrExisting == 'new') {
  name: stgAccountName
  location: stgLocation
  sku: {
    name: stgAccountType
  }
  kind: stgType
  properties: {
    accessTier: accTr
  }
}