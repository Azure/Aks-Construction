param AksName string

param PoolName string

@description('The zones to use for a node pool')
param availabilityZones array = []

@description('OS disk type')
param osDiskType string

@description('VM SKU')
param agentVMSize string

@description('Disk size in GB')
param osDiskSizeGB int

@description('The number of agents for the user node pool')
param agentCount int

@description('The maximum number of nodes for the user node pool')
param agentCountMax int
var autoScale = agentCountMax > agentCount

@description('The maximum number of pods per node.')
param maxPods int

@description('Any taints that should be applied to the node pool')
param nodeTaints array = []

@description('Any labels that should be applied to the node pool')
param nodeLabels object = {}

@description('The subnet the node pool will use')
param subnetId string

@description('OS Type for the node pool')
@allowed([
  'Linux'
  'Windows'
])
param osType string

param enableNodePublicIP bool

resource aks 'Microsoft.ContainerService/managedClusters@2021-10-01' existing = {
  name: AksName
}

resource nodepool 'Microsoft.ContainerService/managedClusters/agentPools@2021-10-01' = {
  parent: aks
  name: PoolName
  properties: {
    mode: 'User'
    vmSize: agentVMSize
    count: agentCount
    minCount: autoScale ? agentCount : json('null')
    maxCount: autoScale ? agentCountMax : json('null')
    enableAutoScaling: autoScale
    availabilityZones: !empty(availabilityZones) ? availabilityZones : null
    osDiskType: osDiskType
    osDiskSizeGB: osDiskSizeGB
    osType: osType
    maxPods: maxPods
    type: 'VirtualMachineScaleSets'
    vnetSubnetID: !empty(subnetId) ? subnetId : json('null')
    upgradeSettings: {
      maxSurge: '33%'
    }
    nodeTaints: nodeTaints
    nodeLabels: nodeLabels
    enableNodePublicIP: enableNodePublicIP
  }
}
