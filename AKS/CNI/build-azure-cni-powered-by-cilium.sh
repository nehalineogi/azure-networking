#
# https://learn.microsoft.com/en-us/azure/aks/azure-cni-powered-by-cilium
#

az account list -o table
az group list -o table

# Preview features
az feature register --namespace Microsoft.ContainerService --name AzureOverlayPreview
az feature unregister --namespace Microsoft.ContainerService --name AzureOverlayPreview
az feature show --namespace Microsoft.ContainerService --name AzureOverlayPreview

#
# providers
#
az provider register -n Microsoft.ContainerService
az provider list --output table
az provider list --query "[?namespace=='Microsoft.ContainerService']" --output table
#
# Set variables
#
RG=aks-cilium-rg

AKSCLUSTER=nnaks-cilium99
LOC="eastus"
MYACR=nnacr101
VNETRG=mgmt-rg-east
VNET=hub-vnet-east
AKSDNS=nnaks-cilium99
PLUGIN=azure
IDENTITY=nnidentity
SUBNET=aks-overlay-subnet


#
# Create RG
#
az group create --name $RG --location $LOC
#
# Create cluster
#
az aks create -n $AKSCLUSTER -g $RG -l $LOC \
--network-plugin azure --network-plugin-mode overlay \
--pod-cidr 192.168.0.0/16 \
--network-dataplane cilium \
--verbose

#
# Connect to cluster
az aks get-credentials -g $RG -n $AKSCLUSTER
alias k='kubectl'
k get nodes -o wide
#
# Create a demo container
#

k apply -f network-tools-pod.yaml

#
# demo deployment
#
k create ns demo-ns
k apply -f deployment.yaml
k get pods -o wide -n demo-ns
k apply -f service-external-lb.yaml
k apply -f service-internal-lb.yaml
k get pods,service -o wide -n demo-ns
k describe service -n demo-ns --watch
# curl http://20.119.104.171:8080/
k delete ns demo-ns



**********************************************************

OLD
#
# The behavior of this command has been altered by the following extension: aks-preview
az extension remove --name aks-preview



#
# Create ACR in common management-RG (only once)
#
az acr create --resource-group $VNETRG  --name $MYACR --sku Basic

#
# Create your own identity in common management-RG (mgmt-rg-east)
#
az identity create --name $IDENTITY --resource-group $VNETRG

#
# One time only - check basic cluster
#
az identity list --query "[].{Name:name, Id:id, Location:location}" -o table
USERIDENTITY=$(az identity show --resource-group $VNETRG --name $IDENTITY --query id -o tsv)
echo $USERIDENTITY
 



  # Get the virtual network resource ID
VNET_ID=$(az network vnet show --resource-group $VNETRG --name $VNET --query id -o tsv)
echo $VNET_ID


# Get the virtual network subnet resource ID
SUBNET_ID=$(az network vnet subnet show --resource-group $VNETRG --vnet-name $VNET --name $SUBNET --query id -o tsv)
echo $SUBNET_ID
#

#
#    --enable-managed-identity \
# 
#    "principalId": "13b879a2-5b44-4c78-ba53-841101bed81d",
#
az identity list
az role assignment create --assignee   "4601b637-964d-467d-93c0-0b5d0a5c5a3c" --scope $VNET_ID --role "Network Contributor"
#
# Create RG
#
az group create --name $RG --location $LOC


#
#Create the AKS cluster with --network-plugin-mode overlay
# 

az aks create \
    --resource-group $RG \
    --name $AKSCLUSTER \
    --node-count 3 \
    --generate-ssh-keys \
    --enable-addons monitoring  \
    --dns-name-prefix $AKSDNS \
    --network-plugin $PLUGIN \
    --network-plugin-mode overlay \
    --service-cidr 10.101.0.0/16 \
    --dns-service-ip 10.101.0.10 \
    --pod-cidr 10.244.0.0/16 \
  #  --docker-bridge-address 172.20.0.1/16 \
    --vnet-subnet-id $SUBNET_ID \
    --assign-identity $USERIDENTITY \
    --attach-acr $MYACR \
    --max-pods 30 \
    --verbose


#
# Connect to cluster
az aks get-credentials -g $RG -n $AKSCLUSTER
alias k='kubectl'
k get nodes -o wide
#
# Create a demo container
#

k apply -f dnsutils.yaml

#
# demo deployment
#
k create ns demo-ns
k apply -f deployment.yaml
k get pods -o wide -n demo-ns
k apply -f service-external-lb.yaml
k apply -f service-internal-lb.yaml
k get pods,service -o wide -n demo-ns
k describe service -n demo-ns
# curl http://20.119.104.171:8080/
k delete ns demo-ns

#
# colors
#
k create ns colors-ns
k apply -f dnsutils.yaml
k apply -f red-internal-service.yaml
k get pods,service -o wide -n colors-ns
k delete -f red-internal-service.yaml
k apply -f red-internal-service.yaml
k get events -n colors-ns
k get service -n colors-ns --watch
k delete ns colors-ns
# nehali@linux-dev:~$ curl 172.16.239.7:8080
#
# Internal LB permissions issue
#
# 23s         Warning   SyncLoadBalancerFailed   service/red-service-internal   Error syncing load balancer: failed to ensure load balancer: Retriable: false, RetryAfter: 0s, HTTPStatusCode: 403, RawError: Retriable: false, RetryAfter: 0s, HTTPStatusCode: 403, RawError: {"error":{"code":"AuthorizationFailed","message":"The client 'e3ba4b52-fd38-44fc-8b4b-ff3e610fdc2b' with object id 'e3ba4b52-fd38-44fc-8b4b-ff3e610fdc2b' does not have authorization to perform action 'Microsoft.Network/virtualNetworks/subnets/read' over scope '/subscriptions/3e9e488a-a196-47d3-9850-297d92cc34dc/resourceGroups/nn-rg-east/providers/Microsoft.Network/virtualNetworks/nn-hub-vnet-east/subnets/aks-kubenet-subnet' or the scope is invalid. If access was recently granted, please refresh your credentials."}}

az aks show -g $RG -n $AKSCLUSTER --query identity
# {
#   "principalId": "e3ba4b52-fd38-44fc-8b4b-ff3e610fdc2b",
#   "tenantId": "72f988bf-86f1-41af-91ab-2d7cd011db47",
#   "type": "SystemAssigned",
#   "userAssignedIdentities": null
# }

#
# Note takes time!
#
az role assignment create --assignee e3ba4b52-fd38-44fc-8b4b-ff3e610fdc2b --role "Network Contributor" --scope /subscriptions/3e9e488a-a196-47d3-9850-297d92cc34dc/resourceGroups/nn-rg-east/providers/Microsoft.Network/virtualNetworks/nn-hub-vnet-east/subnets/aks-kubenet-subnet
#
#
k apply -f example.yaml
k get service --watch
#
#
#
az aks show -g $RG -n $AKSCLUSTER --query identity
az role assignment create --assignee f7675293-b5f2-4183-9c66-2e2874bec08d --role "Network Contributor" --scope /subscriptions/3e9e488a-a196-47d3-9850-297d92cc34dc/resourceGroups/nn-rg-east


az group delete --name $RG