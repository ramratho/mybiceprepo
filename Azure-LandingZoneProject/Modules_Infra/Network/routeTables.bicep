param rTblNames array
param rTblLocation string

resource rTbl 'Microsoft.Network/routeTables@2021-03-01' = [for (rTblName, i) in rTblNames: {
  name: rTblName
  location: rTblLocation
  //tags: {
  //  tagName1: 'tagValue1'
  //  tagName2: 'tagValue2'
  //}
  properties: {
    //disableBgpRoutePropagation: bool
    //routes: [
      //{
        //id: 'string'
        //name: 'string'
        //properties: {
          //addressPrefix: 'string'
          //hasBgpOverride: bool
          //nextHopIpAddress: 'string'
          //nextHopType: 'string'
        //}
        //type: 'string'
      //}
    //]
  }
}]