targetScope = 'subscription'

param prefix string
param location string 
param adminUsername string 
@secure()
param adminPassword string
param vmName string
param dnsLabel string 
param publicIpName string 
param publicIPAllocationMethod string
param publicIpSku string
param OSVersion string 
param vmSize string 
param securityType string 
var rgName = '${prefix}rg'

// Resource Group 
resource azattackRG 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: rgName
  location:location
}

module azattack 'azattack.bicep' = {
  name: 'azattackDeployment'
  scope: azattackRG
  params: {
    prefix:prefix
    location:location
    adminUsername:adminUsername
    adminPassword:adminPassword
    vmName:vmName
    dnsLabel:dnsLabel
    publicIpName:publicIpName
    publicIPAllocationMethod:publicIPAllocationMethod
    publicIpSku:publicIpSku
    OSVersion:OSVersion
    vmSize:vmSize
    securityType:securityType
    
  }
}
