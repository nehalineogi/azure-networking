#
# Azure Documentation link
#
#https://learn.microsoft.com/en-us/azure/aks/azure-cni-overlay?tabs=kubectl#overview-of-overlay-networking
#
#
# Login and Useful commands
#
# List all Azure accounts in table format
az account list -o table

#
# Creat an alias for kubectl
# alias k='kubectl'
alias k

# Preview features
az feature register --namespace Microsoft.ContainerService --name AzureOverlayPreview
az feature unregister --namespace Microsoft.ContainerService --name AzureOverlayPreview
az feature show --namespace Microsoft.ContainerService --name AzureOverlayPreview

#
# The behavior of this command has been altered by the following extension: aks-preview
az extension remove --name aks-preview

#
# providers
#
az provider register -n Microsoft.ContainerService
az provider list --output table
az provider list --query "[?namespace=='Microsoft.ContainerService']" --output table

# Get the current Kubernetes contexts
k config get-contexts

# Switch to a specific Kubernetes context
#k config use-context nnaks-basic

# Delete a specific Kubernetes context
k config delete-context nnaks-overlay99

#
# Set variables (Note: Brownfield with Existing VNET and AKS Node Subnet)
#
#
MYACR=<your-acr-name>                # Name of the Azure Container Registry
VNETRG=<your-vnet-resource-group>    # Resource group of the virtual network
VNET=<your-vnet-name>                # Name of the Existing virtual network
SUBNET_NAME=<your-aks-subnet-name>   # Name of the Exsiting subnet 
AKSCLUSTER=<your-aks-cluster-name>   # Unique Name of the AKS cluster
AKSDNS=<your-aks-dns-name-prefix>    # Unique DNS name prefix for the AKS cluster
LOC=<your-location>                  # Location for the resources
PLUGIN=azure                       # Network plugin to use (kubenet)
IDENTITY=<your-managed-identity-name># Managed identity name
RG=<your-aks-resource-group>         # Resource group for the AKS cluster

#

# Create RG
#
# This command creates a new resource group in the specified location
az group create --name $RG --location $LOC
#
# Create ACR in RG
#
# This command creates an Azure Container Registry in the specified resource group
az acr create --resource-group $RG --name $MYACR --sku Basic

#
# Create IDENTITY
#
# User defined identity
# This will be the identity assigned to the AKS cluster.
#
az identity create --name $IDENTITY --resource-group $RG
az identity list --resource-group $RG

# Save the principal ID in a variable
principal_id=$(az identity list --resource-group $RG --query '[0].principalId' -o tsv)

# Print the principal ID to verify
echo $principal_id


# Save the id of the managed identity in a variable
identity_id=$(az identity list --resource-group $RG --query "[?name=='$IDENTITY'].id" -o tsv)

# Print the id to verify
echo $identity_id

# Get the virtual network resource ID
# This command retrieves the resource ID of the specified virtual network
VNET_ID=$(az network vnet show --resource-group $VNETRG --name $VNET --query id -o tsv)
echo $VNET_ID

# Get the virtual network subnet resource ID
# This command retrieves the resource ID of the specified subnet within the virtual network
SUBNET_ID=$(az network vnet subnet show --resource-group $VNETRG --vnet-name $VNET --name $SUBNET_NAME --query id -o tsv)
echo $SUBNET_ID

#
# Use principalId
#
# Assign the "Network Contributor" role to the specified principal ID for the virtual network
az role assignment create --assignee $principal_id --scope $VNET_ID --role "Network Contributor"
# verify the role assignment
az role assignment list --assignee $principal_id --scope $VNET_ID --role "Network Contributor"



#
# #Create the AKS cluster with --network-plugin-mode overlay
#     --network-plugin $PLUGIN \
#     --network-plugin-mode overlay \
# # 

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
    --vnet-subnet-id $SUBNET_ID \
    --assign-identity $identity_id \
    --attach-acr $MYACR \
    --max-pods 30 \
    --verbose


# Get the AKS cluster credentials
az aks get-credentials -g $RG -n $AKSCLUSTER


# Get the list of nodes in the AKS cluster
k get nodes -o wide

# Get the list of services and pods in the app-routing-system namespace
k get service,pods -o wide 
#
# Summary
#
# The Deployment creates 3 replicas of a pod running the hashicorp/http-echo container,
# which listens on port 8080 and responds with the text "red".
# The Service exposes these pods internally within the Kubernetes cluster on port 8080,
# allowing other services within the cluster to communicate with the red application
#
# k delete ns demo-ns
k create ns demo-ns
k apply -f deployment.yaml
k get service,pods -o wide -n demo-ns

#
# External LB
#
k apply -f service-external-lb.yaml
k get service -n demo-ns --watch
k get nodes,pods,service -o wide -n demo-ns


#
# Internal LB
#
# k delete -f service-internal-lb.yaml
k apply -f service-internal-lb.yaml
k get service -n demo-ns --watch
k get nodes,pods,services -o wide -n demo-ns

#
# Verify inbound and outbound flows
#
# Outbound
k exec -it <nginx-pod-name> -n demo-ns
curl ifconfig.me
# inbound
curl <external-ip>:8080


k describe service nginx-service-external -n demo-ns
k describe service nginx-service-internal -n demo-ns

# Cleanup namespace
k delete ns demo-ns

#
# Troubleshooting:
#
az aks get-credentials --resource-group <ResourceGroupName> --name <ClusterName>
k get events -n demo-ns
k get pods -n demo-ns 
kubectl logs <PodName> -n <Namespace>
kubectl describe pod <PodName> -n <Namespace>
kubectl get services --all-namespaces
#
#
#
#
# Internal LB permissions issue
# Example error message when there is a permissions issue with the internal load balancer
# 23s         Warning   SyncLoadBalancerFailed   service/red-service-internal   Error syncing load balancer: failed to ensure load balancer: Retriable: false, RetryAfter: 0s, HTTPStatusCode: 403, RawError: Retriable: false, RetryAfter: 0s, HTTPStatusCode: 403, RawError: {"error":{"code":"AuthorizationFailed","message":"The client 'e3ba4b52-fd38-44fc-8b4b-ff3e610fdc2b' with object id 'e3ba4b52-fd38-44fc-8b4b-ff3e610fdc2b' does not have authorization to perform action 'Microsoft.Network/virtualNetworks/subnets/read' over scope '/subscriptions/3e9e488a-a196-47d3-9850-297d92cc34dc/resourceGroups/nn-rg-east/providers/Microsoft.Network/virtualNetworks/nn-hub-vnet-east/subnets/aks-kubenet-subnet' or the scope is invalid. If access was recently granted, please refresh your credentials."}}

# Show the identity of the AKS cluster
az aks show -g $RG -n $AKSCLUSTER --query identity
# {
#   "principalId": "e3ba4b52-fd38-44fc-8b4b-ff3e610fdc2b",
#   "tenantId": "72f988bf-86f1-41af-91ab-2d7cd011db47",
#   "type": "SystemAssigned",
#   "userAssignedIdentities": null
# }

# Note: It takes time for the role assignment to propagate
az role assignment list --assignee $principal_id --scope $VNET_ID --role "Network Contributor"
az role assignment create --assignee $principal_id --scope $VNET_ID --role "Network Contributor"

# Query identity again to verify
az aks show -g $RG -n $AKSCLUSTER --query identity
#
# Verifty DNS
#
kubectl get pods -n kube-system -l k8s-app=kube-dns
kubectl get svc -n kube-system kube-dns
kubectl describe svc -n kube-system kube-dns
kubectl get pods -n kube-system -l k8s-app=kube-dns
kubectl get svc -n kube-system kube-dns
#
# Cleanup
#
# Delete the resource group to clean up all resources
az group delete --name $RG