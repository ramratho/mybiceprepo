targetScope = 'subscription'

param subLocation string = 'SwitzerlandNorth'

var companyCode = 'cws'
var environmentCode = 'prod'
var locationCode = 'chn1'
var purpAppCode = 'rg'
var instanceCountCode = '01'
var tagEnvName = 'Environment'
var tagApplName = 'ApplicationName'

module newRG '../../Modules_Infra/ResourceGroups/newRG.bicep' = {
  name: 'newRGmodule'
  params: {
    rgLocation: subLocation
    rgPrefix: '${companyCode}-${environmentCode}-${locationCode}-'
    rgSuffix: '-${purpAppCode}-${instanceCountCode}'
    rgNames: [
      'backup'
      'core'
    ]
    tag1Name: tagEnvName
    tag1Value: environmentCode
    tag2Name: tagApplName
  }
}