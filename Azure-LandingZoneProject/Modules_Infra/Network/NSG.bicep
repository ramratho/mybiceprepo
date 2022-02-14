param nsgNames array
param nsgLocation string

resource netSecGrp 'Microsoft.Network/networkSecurityGroups@2021-03-01' = [for (nsgName, i) in nsgNames: {
  name: nsgName
  location: nsgLocation
    //tags: {
    //  tagName1: 'tagValue1'
    //  tagName2: 'tagValue2'
    //}
  properties: {}
}]