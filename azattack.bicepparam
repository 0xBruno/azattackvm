using 'azattack.bicep'

@description('Specified the prefix for resources created')
param prefix = 'azattack-'

@description('Specifies the location for resources.')
param location = 'centralus'

@description('Username for the Virtual Machine.')
param adminUsername = '${prefix}vmadmin'

@description('Password for the Virtual Machine.')
@secure()
param adminPassword = ''

@description('Name of the virtual machine.')
param vmName = 'azattack-vm'

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabel  = 'azattack'

@description('Name for the Public IP used to access the Virtual Machine.')
param publicIpName = '${prefix}-pip'

@description('Allocation method for the Public IP used to access the Virtual Machine.')
@allowed([
  'Dynamic'
  'Static'
])
param publicIPAllocationMethod = 'Dynamic'

@description('SKU for the Public IP used to access the Virtual Machine.')
@allowed([
  'Basic'
  'Standard'
])
param publicIpSku = 'Basic'

@description('The Windows version for the VM. This will pick a fully patched image of this given Windows version.')
param OSVersion = 'win10-22h2-pro-g2'

@description('Size of the virtual machine.')
param vmSize = 'Standard_B2s'

@description('Security Type of the Virtual Machine.')
param securityType = 'TrustedLaunch'
