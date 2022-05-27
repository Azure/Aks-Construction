param nameseed string = 'fluxdocs'
param location string =  resourceGroup().location

//--------------Flux Config---------------
module flux 'fluxConfig-InfraAndApps.bicep' = {
  name: 'flux'
  params: {
    aksName: aksconst.outputs.aksClusterName
    aksFluxAddOnReleaseNamespace: aksconst.outputs.fluxReleaseNamespace
    fluxConfigRepo: 'https://github.com/Azure/gitops-flux2-kustomize-helm-mt'
    fluxRepoInfraPath: ''
    fluxRepoAppsPath: ''
  }
}

//---------Kubernetes Construction---------
//ref: https://github.com/Azure/AKS-Construction

module aksconst '../../bicep/main.bicep' = {
  name: 'aksconstruction'
  params: {
    location : location
    resourceName: nameseed
    enable_aad: true
    enableAzureRBAC : true
    registries_sku: 'Standard'
    omsagent: true
    retentionInDays: 30
    agentCount: 1
    JustUseSystemPool: true
    createEventGrid: true
  }
}
