#
# Login to Azure and configure kubectl contexts
# https://learn.microsoft.com/en-us/azure/aks/configure-kubenet-dual-stack?tabs=azure-cli%2Ckubectl
#
az account list -o table                # List Azure accounts
k config get-contexts                   # Get kubectl contexts
k config use-context nnaks-basic        # Use specific kubectl context
k config delete-context nnaks-dual27  # Delete specific kubectl context


#
# Creat an alias for kubectl
# alias k='kubectl'
alias k
#
# Set variables
# PLUGIN=kubenet                     # Directly in az aks create command
#
MYACR=<YourACRName>                # Azure Container Registry name
VNETRG=<YourVNetResourceGroup>     # Resource group for the VNet
VNET=<YourVNetName>                # Virtual Network name
RG=<YourAKSResourceGroup>          # Resource group for the AKS cluster
AKSCLUSTER=<YourAKSClusterName>    # AKS cluster name
AKSDNS=<YourAKSDNSName>            # AKS DNS name
LOC=<YourLocation>                 # Location of the resources
IDENTITY=<YourManagedIdentityName> # Managed identity name
SUBNET=<YourSubnetName>            # Subnet name for the AKS cluster
#
# Create Resource Group
#
az group create --name $RG --location $LOC # Create resource group

#
# Create ACR in common management-RG
#
az acr create --resource-group $RG --name $MYACR --sku Basic # Create Azure Container Registry


# Get the virtual network resource ID
#
VNET_ID=$(az network vnet show --resource-group $VNETRG --name $VNET --query id -o tsv) # Get VNet ID
echo $VNET_ID

#
# Get the virtual network subnet resource ID
#
SUBNET_ID=$(az network vnet subnet show --resource-group $VNETRG --vnet-name $VNET --name $SUBNET --query id -o tsv) # Get Subnet ID
echo $SUBNET_ID

#
# Create Managed Identity
#
az identity create --name $IDENTITY --resource-group $RG # Create managed identity
az identity list --resource-group $RG # List managed identities

#
# Save the principal ID in a variable
#
principal_id=$(az identity list --resource-group $RG --query '[0].principalId' -o tsv) # Get principal ID
echo $principal_id

#
# Save the ID of the managed identity in a variable
#
identity_id=$(az identity list --resource-group $RG --query "[?name=='$IDENTITY'].id" -o tsv) # Get identity ID
echo $identity_id

#
# Assign "Network Contributor" role to the principal within the VNet scope
#
az role assignment create --assignee $principal_id --scope $VNET_ID --role "Network Contributor" # Assign role
az role assignment list --assignee $principal_id --scope $VNET_ID --role "Network Contributor" # List role assignments

#
# Create AKS Kubenet cluster
# # default POD space: 10.244.0.0/16,fd12:3456:789a::/64
#
az aks create \
    --resource-group $RG \
    --name $AKSCLUSTER \
    --node-count 3 \
    --generate-ssh-keys \
    --enable-addons monitoring \
    --dns-name-prefix $AKSDNS \
    --network-plugin kubenet \
    --docker-bridge-address 172.20.0.1/16 \
    --vnet-subnet-id $SUBNET_ID \
    --assign-identity $identity_id \
    --attach-acr $MYACR \
    --max-pods 30 \
    --ip-families ipv4,ipv6 \
    --verbose # Create AKS cluster

#
# Create AKS CNI Overlay cluster
# default POD space: 10.244.0.0/16,fd12:3456:789a::/64
#
az aks create \
    --resource-group $RG \
    --name $AKSCLUSTER \
    --node-count 3 \
    --generate-ssh-keys \
    --enable-addons monitoring  \
    --dns-name-prefix $AKSDNS \
    --network-plugin azure \
    --network-plugin-mode overlay \
    --service-cidr 10.101.0.0/16 \
    --dns-service-ip 10.101.0.10 \
    --pod-cidr 10.244.0.0/16 \
    --vnet-subnet-id $SUBNET_ID \
    --assign-identity $identity_id \
    --attach-acr $MYACR \
    --max-pods 30 \
    --ip-families ipv4,ipv6 \
    --verbose

#
# Get AKS credentials
#
az aks get-credentials -g $RG -n $AKSCLUSTER # Get AKS credentials

k get nodes -o wide # Get nodes with wide output

#
# Custom columns to view IPv6 addresses
#
kubectl get nodes -o=custom-columns="NAME:.metadata.name,ADDRESSES:.status.addresses[?(@.type=='InternalIP')].address,PODCIDRS:.spec.podCIDRs[*]" # Custom columns for nodes

#
# Deploy and expose nginx
#
kubectl create deployment nginx --image=nginx:latest --replicas=3 # Create nginx deployment
kubectl expose deployment nginx --name=nginx-ipv4 --port=80 --type=LoadBalancer --overrides='{"spec":{"externalTrafficPolicy":"Local"}}' # Expose IPv4 deployment
kubectl expose deployment nginx --name=nginx-ipv6 --port=80 --type=LoadBalancer --overrides='{"spec":{"externalTrafficPolicy":"Local", "ipFamilies": ["IPv6"]}}' # Expose IPv6 deployment
kubectl get services # Get services

#
# Test IPv6
#
# http://[2603:1030:20c:9::43]

#
# Create and manage demo namespace
#
k delete ns demo-ns
k create ns demo-ns # Create demo namespace
k apply -f deployment.yaml # Apply deployment
k get nodes,pods,service -o wide -n demo-ns # Get resources in demo namespace
k apply -f service-internal-lb-dualstack.yaml # Apply internal LB service
k apply -f service-external-lb-dualstack.yaml # Apply external LB service
k get nodes,pods,service -o wide -n demo-ns # Get resources in demo namespace
k get service -o wide -n demo-ns --watch

kubectl get nodes -o=custom-columns="NAME:.metadata.name,ADDRESSES:.status.addresses[?(@.type=='InternalIP')].address,PODCIDRS:.spec.podCIDRs[*]" # Custom columns for nodes
kubectl get pods -o custom-columns="NAME:.metadata.name,IPs:.status.podIPs[*].ip,NODE:.spec.nodeName,READY:.status.conditions[?(@.type=='Ready')].status" -n demo-ns # Custom columns for pods
kubectl get services -n demo-ns -o custom-columns="NAME:.metadata.name,CLUSTER-IP:.spec.clusterIPs[*],EXTERNAL-IP:.status.loadBalancer.ingress[*].ip" # Custom columns for services

k describe service -n demo-ns # Describe service
# curl http://20.119.104.171:8080/ # Test service
k delete ns demo-ns # Delete demo namespace

#
# validations
# outbound
k exec -it nginx-deployment-5786c9d647-7zx7l -n demo-ns -- sh
curl  ifconfig.me
curl -6 ifconfig.me
# inbound
curl.exe -6 https://ifconfig.me
curl.exe "http://[2603:1030:20c:f::6]:8080" | findstr address

#
# internal LB (from east VM)
#
curl http://[fd12:3456:789a:7::7]:8080 | grep address
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
# Handle internal LB permissions issue
#
# 23s Warning SyncLoadBalancerFailed service/red-service-internal Error syncing load balancer: failed to ensure load balancer: Retriable: false, RetryAfter: 0s, HTTPStatusCode: 403, RawError: Retriable: false, RetryAfter: 0s, HTTPStatusCode: 403, RawError: {"error":{"code":"AuthorizationFailed","message":"The client 'e3ba4b52-fd38-44fc-8b4b-ff3e610fdc2b' with object id 'e3ba4b52-fd38-44fc-8b4b-ff3e610fdc2b' does not have authorization to perform action 'Microsoft.Network/virtualNetworks/subnets/read' over scope '/subscriptions/3e9e488a-a196-47d3-9850-297d92cc34dc/resourceGroups/nn-rg-east/providers/Microsoft.Network/virtualNetworks/nn-hub-vnet-east/subnets/aks-kubenet-subnet' or the scope is invalid. If access was recently granted, please refresh your credentials."}}

az aks show -g $RG -n $AKSCLUSTER --query identity # Show AKS identity
# {
#   "principalId": "e3ba4b52-fd38-44fc-8b4b-ff3e610fdc2b",
#   "tenantId": "72f988bf-86f1-41af-91ab-2d7cd011db47",
#   "type": "SystemAssigned",
#   "userAssignedIdentities": null
# }

#
# Assign "Network Contributor" role to the AKS cluster identity
#
az role assignment create --assignee e3ba4b52-fd38-44fc-8b4b-ff3e610fdc2b --role "Network Contributor" --scope /subscriptions/3e9e488a-a196-47d3-9850-297d92cc34dc/resourceGroups/nn-rg-east/providers/Microsoft.Network/virtualNetworks/nn-hub-vnet-east/subnets/aks-kubenet-subnet # Assign role

#
# Apply example configuration
#
k apply -f example.yaml # Apply example configuration
k get service --watch # Watch services

#
# Show AKS identity and assign role
#
az aks show -g $RG -n $AKSCLUSTER --query identity # Show AKS identity
az role assignment create --assignee f7675293-b5f2-4183-9c66-2e2874bec08d --role "Network Contributor" --scope /subscriptions/3e9e488a

#
# Cleanup
#
# Delete the resource group to clean up all resources
az group delete --name $RG