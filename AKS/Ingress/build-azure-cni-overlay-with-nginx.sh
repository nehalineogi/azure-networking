#
# Azure Documentation link
#
# https://learn.microsoft.com/en-us/azure/aks/app-routing-nginx-configuration
# https://learn.microsoft.com/en-us/azure/aks/app-routing
#
# Verify Login and Useful commands
#
# List all Azure accounts in table format
# az account list -o table
# list all resource groups with string aks in the name
az group list --query "[?contains(name, 'aks')]" -o table


# Creat an alias for kubectl
alias k='kubectl'
alias k

#
# Preview features < review this - cleanup>
# az feature unregister --namespace Microsoft.ContainerService --name AzureOverlayPreview
# az feature show --namespace Microsoft.ContainerService --name AzureOverlayPreview
#
# The behavior of this command has been altered by the following extension: aks-preview
# az extension remove --name aks-preview
#
# providers validations
#az provider register -n Microsoft.ContainerService
#az provider list --output table
# az provider list --query "[?namespace=='Microsoft.ContainerService']" --output table

# Get the current Kubernetes contexts
k config get-contexts

# Switch to a specific Kubernetes context
#k config use-context nnaks-basic

# Delete a specific Kubernetes context
k config delete-context nnaks-overlay99

#
# Set variables (Note: Brownfield with Existing VNET and AKS Node Subnet)
# CNI Overlay
#
#
PLUGIN=azure                       # Network plugin to use
MYACR=<your-acr-name>                # Name of the Azure Container Registry
VNETRG=<your-vnet-resource-group>    # Resource group of the virtual network
VNET=<your-vnet-name>                # Name of the Existing virtual network
SUBNET_NAME=<your-aks-subnet-name>   # Name of the Exsiting subnet 
AKSCLUSTER=<your-aks-cluster-name>   # Unique Name of the AKS cluster
AKSDNS=<your-aks-dns-name-prefix>    # Unique DNS name prefix for the AKS cluster
LOC=<your-location>                  # Location for the resources
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
# This command creates a managed identity in the specified resource group
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
# Note: Existing Cluster
#
az aks approuting enable --resource-group $RG --name $AKSCLUSTER

#
# New Cluster
# Create the AKS cluster 
#  --network-plugin $PLUGIN \
# --network-plugin-mode overlay \
# --enable-app-routing \
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
    --vnet-subnet-id $SUBNET_ID \
    --assign-identity $identity_id \
    --attach-acr $MYACR \
    --max-pods 30 \
    --enable-app-routing \
    --verbose


# Get the AKS cluster credentials
az aks get-credentials -g $RG -n $AKSCLUSTER

# Get the list of nodes in the AKS cluster
k get nodes -o wide

#
# validate ingress controller
k get ns
k get service,pods -o wide -n app-routing-system
k describe service nginx -n app-routing-system
#
# Deploy the demo application
#
k delete ns colors-ns
k create ns colors-ns
k apply -f red-cluster-ip.yaml
k apply -f green-cluster-ip.yaml
k apply -f blue-cluster-ip.yaml
k get pods,services,nodes -o wide -n colors-ns
k get pods,services,nodes,ingress -o wide -n colors-ns
k describe ingress -n colors-ns


# Show nodes on the AKS cluster
k get nodes -o wide
k get service -n app-routing-system
kubectl get svc/nginx -o json -n app-routing-system | jq -rc '.status.loadBalancer.ingress[0].ip'

# show nginx service and extract external IP

# ingress
k apply -f fanout-nginx.yaml
k apply -f virtualhost-nginx.yaml
#
k get nodes,ingress -n colors-ns -o wide
k get pods,services,nodes,ingress -o wide -n colors-ns

k describe ingress colors-fanout-ingress -n colors-ns
k describe ingress colors-virtual-host-ingress -n colors-ns
#
#
# Deploy a test pod
k delete -f network-tools-pod.yaml
k apply -f network-tools-pod.yaml
k get pods -o wide
k exec -it network-tools -- sh
#
# outbound
#
curl ifconfig.me

# External Inbound
#
k get nodes -o wide
k get service,pods -o wide -n app-routing-system # aks-nodepool1-12818158-vmss000000 
#

#
# fanout using the external IP of nginx service
#
curl http://51.8.66.245/red --header "Host: akscolors.penguintrails.com"
curl http://51.8.66.245/green --header "Host: akscolors.penguintrails.com"
curl http://51.8.66.245/blue --header "Host: akscolors.penguintrails.com"
#
# virtualhost
#
curl http://51.8.66.245/ --header "Host: aksred.penguintrails.com"
curl http://51.8.66.245/ --header "Host: aksgreen.penguintrails.com"
curl http://51.8.66.245/ --header "Host: aksblue.penguintrails.com"

#
# with FDQN akscolors.penguintrails.com CNAME to Application Gateway public IP/DNS Name
# resolvectl flush-caches 
curl akscolors.penguintrails.com/red
curl akscolors.penguintrails.com/green
curl akscolors.penguintrails.com/blue
#
#
# with FDQN aksred.penguintrails.com, aksgreen.penguintrails.com, aksblue.penguintrails.com 
# CNAME to Application Gateway public IP/DNS Name

curl aksred.penguintrails.com
curl aksgreen.penguintrails.com
curl aksblue.penguintrails.com
#
# Verify inbound and outbound flows
#
# Outbound
k exec -it network-tools -- sh
curl ifconfig.me



#
#  Validate Ingess - NodePort
# Get NodePort for nginx ingress service and Node IPs
#

k get nodes -o wide
k get service,pods -o wide -n app-routing-system 
#
#
# Test using nodeport
# From  east vm
# NodeIP:NodePort
curl http://172.16.236.4:31096/ --header "Host: aksblue.penguintrails.com"
curl http://172.16.236.5:31096/ --header "Host: aksblue.penguintrails.com"
curl http://172.16.236.6:31096/ --header "Host: aksblue.penguintrails.com"

# Edit the configuration of the nginx service
#
 k edit service nginx -n app-routing-system 
#    externalTrafficPolicy: Local
#   healthCheckNodePort: 30928
#   internalTrafficPolicy: Cluster
  - 10.101.11.33
  externalTrafficPolicy: Cluster
  internalTrafficPolicy: Cluster
  ipFamilies:

#
# From the network POD: Cluster IP for nginx ingress
#
k get service,pods -o wide -n app-routing-system
k exec -it network-tools -- sh
curl http://10.101.158.125 --header "Host: aksblue.penguintrails.com"
curl http://10.101.158.125/blue --header "Host: akscolors.penguintrails.com"

curl http://10.101.158.125 --header "Host: aksred.penguintrails.com"
curl http://10.101.158.125/red --header "Host: akscolors.penguintrails.com"

#
# Cluster IP for Blue Service
#
k get service -o wide -n colors-ns
k exec -it network-tools -- sh
curl 10.101.140.185:8080 # red
curl 10.101.138.117:8080 # green
curl 10.101.180.75:8080  # blue

#
# Pod IP
#
k get pods -o wide -n colors-ns
k exec -it network-tools -- sh
curl 10.244.1.42:8080

#
# Some validations on the nodes
#
tcpdump and floating IP
sudo iptables-save | grep nginx
sudo iptables-save | grep 51.8.66.245
iptables -L -n  | grep nginx


# 
# Cleanup namespace
k delete ns demo-ns

#
# Troubleshooting:
#
az aks get-credentials --resource-group <ResourceGroupName> --name <ClusterName>
k get events -n colors-ns
k get pods -n colors-ns
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

#
#
#

az k8s-extension create --name ml-k8s-extension --extension-type Microsoft.AzureML.Kubernetes \
--config enableTraining=True enableInference=True \
inferenceRouterServiceType=LoadBalancer \
allowInsecureConnections=True InferenceRouterHA=False --cluster-type managedClusters \
--cluster-name $AKSCLUSTER --resource-group $RG --scope cluster
# Cleanup resourcegroup
#
# Delete the resource group to clean up all resources
az group delete --name $RG