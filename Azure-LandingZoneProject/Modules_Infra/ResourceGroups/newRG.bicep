targetScope = 'subscription'

param rgLocation string
param rgPrefix string
param rgSuffix string
param rgNames array
param tag1Name string
param tag1Value string
param tag2Name string

resource newRG 'Microsoft.Resources/resourceGroups@2021-04-01' = [for i in rgNames: {
  name: '${rgPrefix}${i}${rgSuffix}'
  location: rgLocation
  tags: {
    '${tag1Name}': tag1Value
    '${tag2Name}': '${i}'
  }
}]