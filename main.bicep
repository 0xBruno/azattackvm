targetScope = 'subscription'

@description('Specifies the location for resources.')
param location string = 'centralus'

var prefix = 'azattack-'
var rgName = '${prefix}rg'

// Resource Group 
resource azattackRG 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: rgName
  location: location
}

module azattack 'azattack.bicep' = {
  name: 'azattackDeployment'
  scope: azattackRG
  params: { 
    prefix: prefix
    location: location
    adminUsername: 'azattackadmin'
    adminPassword: ''
  }
}
