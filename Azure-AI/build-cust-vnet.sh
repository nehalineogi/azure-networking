#!/bin/bash
#
# Build a Linux VM with Docker and network tools
#

# Define common variables
export COMMON_RESOURCE_GROUP=nnmlstudio-common-RG
export LOCATION=eastus
export LINUX_VM=aistudio-linux-vm
export LINUX_IMAGE=Ubuntu2204
export WINDOWS_VM=aistudio-win-vm
export WINDWOS_IMAGE=Win2019Datacenter
export LINUX_IMAGE=Ubuntu2204
export ADMIN_USERNAME=azureuser
export ADMIN_PASSWORD=Azure12345678
export VNET_NAME=customer-vnet
export PEP_SUBNET_NAME=private-endpoint-subnet
export VM_SUBNET_NAME=vm-subnet
export VNET_ADDRESS_PREFIX=10.100.0.0/16
export PEP_SUBNET_PREFIX=10.100.3.0/24
export VM_SUBNET_PREFIX=10.100.2.0/24
export GW_SUBNET_PREFIX=10.100.1.0/24
export NSG_NAME=vm-nsg


#
# Use your own public key file
#
export PUB_KEY=~/.ssh/id_rsa.pub

# Get the current public IP of the user
MY_IP=$(curl -s ifconfig.me)

# Check if resource group with string studio exists
az group list --query "[?contains(name, 'studio')]" --output table


# Create resource group
az group create --name $COMMON_RESOURCE_GROUP --location $LOCATION


# Create virtual network with two subnets in one line
az network vnet create --resource-group $COMMON_RESOURCE_GROUP --name $VNET_NAME --address-prefix $VNET_ADDRESS_PREFIX 
az network vnet subnet create --resource-group $COMMON_RESOURCE_GROUP --vnet-name $VNET_NAME --name $VM_SUBNET_NAME --address-prefix $VM_SUBNET_PREFIX
az network vnet subnet create --resource-group $COMMON_RESOURCE_GROUP --vnet-name $VNET_NAME --name $PEP_SUBNET_NAME --address-prefix $PEP_SUBNET_PREFIX


# Create NSG
az network nsg create --resource-group $COMMON_RESOURCE_GROUP --name $NSG_NAME

# Allow port 22 from YOUR IP
az network nsg rule create --resource-group $COMMON_RESOURCE_GROUP --nsg-name $NSG_NAME --name AllowSSH --protocol tcp --priority 1000 --destination-port-range 22 --source-address-prefixes $MY_IP --access allow

# Allow port 3389 from YOUR IP
az network nsg rule create --resource-group $COMMON_RESOURCE_GROUP --nsg-name $NSG_NAME --name AllowHTTP --protocol tcp --priority 1010 --destination-port-range 3389 --source-address-prefixes $MY_IP --access allow

# Create cloud-init file for custom script
cat <<EOF > cloud-init.txt
#cloud-config
package_update: true
packages:
  - net-tools
runcmd:
  - sudo usermod -aG docker $ADMIN_USERNAME
EOF


  # Create VM
  az vm create \
    --resource-group $COMMON_RESOURCE_GROUP \
    --name $LINUX_VM \
    --image $LINUX_IMAGE \
    --admin-username $ADMIN_USERNAME \
    --ssh-key-values $PUB_KEY \
    --public-ip-sku Standard \
    --vnet-name $VNET_NAME \
    --subnet $VM_SUBNET_NAME \
    --custom-data cloud-init.txt \
    --verbose

# Create Windows VM
az vm create \
  --resource-group $COMMON_RESOURCE_GROUP \
  --name $WINDOWS_VM \
  --image $WINDWOS_IMAGE \
  --admin-username $ADMIN_USERNAME \
  --admin-password $ADMIN_PASSWORD \
  --public-ip-sku Standard \
  --vnet-name $VNET_NAME \
  --subnet $VM_SUBNET_NAME \
  --size Standard_D2s_v3 \
  --verbose

# Get NIC Name
linux_vm_nic_name=$(az vm show --resource-group $COMMON_RESOURCE_GROUP --name $LINUX_VM --query "networkProfile.networkInterfaces[0].id" --output tsv | xargs -n 1 basename)
win_vm_nic_name=$(az vm show --resource-group $COMMON_RESOURCE_GROUP --name $WINDOWS_VM --query "networkProfile.networkInterfaces[0].id" --output tsv | xargs -n 1 basename)

# Associate NSG with VM's network interface
az network nic update --resource-group $COMMON_RESOURCE_GROUP --name $linux_vm_nic_name --network-security-group $NSG_NAME
az network nic update --resource-group $COMMON_RESOURCE_GROUP --name $win_vm_nic_name --network-security-group $NSG_NAME

# Retrieve and echo the public IP address and SSH command
LINUX_VM_IP=$(az vm show --resource-group $COMMON_RESOURCE_GROUP --name $LINUX_VM --show-details --query [publicIps] --output tsv)
WINDOWS_VM_IP=$(az vm show --resource-group $COMMON_RESOURCE_GROUP --name $WINDOWS_VM --show-details --query [publicIps] --output tsv)

# Echo the IPs
echo "Linux Public IP: $LINUX_VM_IP"
echo "SSH into VM: ssh $ADMIN_USERNAME@$LINUX_VM_IP"

echo "Windows Public IP: $WINDOWS_VM_IP"
echo "RDP into VM: mstsc /v:$WINDOWS_VM_IP"


# # Create a private endpoint (don't need this for public access)
# # create azure storage account with single line with public access disabled
# # az storage account create --name nnmlstudiostorage99 --resource-group $COMMON_RESOURCE_GROUP --location $LOCATION --sku Standard_LRS --allow-blob-public-access false

# az storage account create --name nnmlstudiostorage99 --resource-group $COMMON_RESOURCE_GROUP --location $LOCATION --sku Standard_LRS --public-network-access disabled

# #find the storage account id
# storage_account_id=$(az storage account show --name nnmlstudiostorage99 --resource-group $COMMON_RESOURCE_GROUP --query id --output tsv)
# # create private endpoint for storage account and corresponding DNS zone
# az network private-endpoint create --name nnmlstudiostorage99-blob-pe --resource-group $COMMON_RESOURCE_GROUP --vnet-name $VNET_NAME --subnet $PEP_SUBNET_NAME --private-connection-resource-id $storage_account_id --group-id blob --connection-name nnmlstudio --location $LOCATION
# az network private-endpoint create --name nnmlstudiostorage99-file-pe --resource-group $COMMON_RESOURCE_GROUP --vnet-name $VNET_NAME --subnet $PEP_SUBNET_NAME --private-connection-resource-id $storage_account_id --group-id file --connection-name nnmlstudio --location $LOCATION
# az network private-dns zone create --resource-group $COMMON_RESOURCE_GROUP --name privatelink.blob.core.windows.net
# az network private-dns zone create --resource-group $COMMON_RESOURCE_GROUP --name privatelink.file.core.windows.net
# az network private-dns link vnet create --resource-group $COMMON_RESOURCE_GROUP --zone-name privatelink.blob.core.windows.net --name ${VNET_NAME}-link --virtual-network $VNET_NAME --registration-enabled false
# az network private-dns link vnet create --resource-group $COMMON_RESOURCE_GROUP --zone-name privatelink.file.core.windows.net --name ${VNET_NAME}-link --virtual-network $VNET_NAME --registration-enabled false
# # create zone group for storage account
# az network private-endpoint dns-zone-group create --resource-group $COMMON_RESOURCE_GROUP --endpoint-name nnmlstudiostorage99-blob-pe --name myzonegroup --private-dns-zone privatelink.blob.core.windows.net --zone-name privatelink.blob.core.windows.net
# az network private-endpoint dns-zone-group create --resource-group $COMMON_RESOURCE_GROUP --endpoint-name nnmlstudiostorage99-file-pe --name myzonegroup --private-dns-zone privatelink.file.core.windows.net --zone-name privatelink.file.core.windows.net

# # create azure container registry with single line with public access network disabled and soft erase enabled

# az acr create --name nnmlstudioacr99 --resource-group $COMMON_RESOURCE_GROUP --location $LOCATION --sku Premium --public-network-enabled false

# # find acr id
# acr_id=$(az acr show --name nnmlstudioacr99 --resource-group $COMMON_RESOURCE_GROUP --query id --output tsv)
# # create private endpoint for container registry and corresponding DNS zone
# az network private-endpoint create --name nnmlstudioacr-pe --resource-group $COMMON_RESOURCE_GROUP --vnet-name $VNET_NAME --subnet $PEP_SUBNET_NAME --private-connection-resource-id $acr_id --group-id registry --connection-name nnmlstudio --location $LOCATION
# az network private-dns zone create --resource-group $COMMON_RESOURCE_GROUP --name privatelink.azurecr.io
# az network private-dns link vnet create --resource-group $COMMON_RESOURCE_GROUP --zone-name privatelink.azurecr.io --name ${VNET_NAME}-link --virtual-network $VNET_NAME --registration-enabled false
# # create zone group for acr
# az network private-endpoint dns-zone-group create --resource-group $COMMON_RESOURCE_GROUP --endpoint-name nnmlstudio-pe --name myzonegroup --private-dns-zone privatelink.azurecr.io --zone-name privatelink.azurecr.io

# # create azure key vault with single line with public access network disabled
# az keyvault create --name nnmlstudiokv99 --resource-group $COMMON_RESOURCE_GROUP --location $LOCATION --sku standard --public-network-access disabled
# # find key vault id
# key_vault_id=$(az keyvault show --name nnmlstudiokv99 --resource-group $COMMON_RESOURCE_GROUP --query id --output tsv)
# # create private endpoint for key vault and corresponding DNS zone
# az network private-endpoint create --name nnmlstudiokv-pe --resource-group $COMMON_RESOURCE_GROUP --vnet-name $VNET_NAME --subnet $PEP_SUBNET_NAME --private-connection-resource-id $key_vault_id --group-id vault --connection-name nnmlstudio --location $LOCATION
# az network private-dns zone create --resource-group $COMMON_RESOURCE_GROUP --name privatelink.vaultcore.azure.net
# az network private-dns link vnet create --resource-group $COMMON_RESOURCE_GROUP --zone-name privatelink.vaultcore.azure.net --name ${VNET_NAME}-link --virtual-network $VNET_NAME --registration-enabled false
# # create zone group for key vault
# az network private-endpoint dns-zone-group create --resource-group $COMMON_RESOURCE_GROUP --endpoint-name nnmlstudio-pe --name myzonegroup --private-dns-zone privatelink.vaultcore.azure.net --zone-name privatelink.vaultcore.azure.net
# #create app insights
# az monitor app-insights component create --app nnmlstudioappinsight99 --location $LOCATION --resource-group $COMMON_RESOURCE_GROUP

