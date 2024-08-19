#!/bin/bash
#
# https://learn.microsoft.com/en-us/azure/machine-learning/how-to-managed-network
#
# Options: Public, Allow Internet Outbound, Allow Approved Outbound
#

# Log in to Azure
az login
# command to validate the login
# az account list --output table
# command to list resource groups with studio in it
# remove any soft deleted workspaces
#
az group list --query "[?contains(name, 'studio')]" --output table


#
# Define the prefix depending on the network scenario
#
# PREFIX="mlstudio-public-demo"
# PREFIX="mlstudio-byo-vnet"
# PREFIX="mlstudio-managed-vnet-option-2"
# PREFIX="mlstudio-managed-vnet-option-3"

PREFIX="mlstudio-byo-demo"

# Export variables with the prefix
export LOCATION="eastus"
export RESOURCE_GROUP="${PREFIX}-RG"
export WORKSPACE_NAME="${PREFIX}"
echo $RESOURCE_GROUP
echo $WORKSPACE_NAME

#Common RG (VNET, Subnet required for Private Endpoint)
#
export COMMON_RESOURCE_GROUP="nnmlstudio-common-RG"
export VNET_NAME=customer-vnet
export PEP_SUBNET_NAME=private-endpoint-subnet
export VM_SUBNET_NAME=vm-subnet

# #
# # Export variables for Private Endpoint

export PRIVATE_ENDPOINT_TYPE="AutoApproval"
export ALLOW_SHARED_KEY_ACCESS="true"
export PRIVATE_ENDPOINT_NAME="CUST-VNET-PEP"

# Create Resource Group
#az group create --name $COMMON_GROUP --location $LOCATION
echo $RESOURCE_GROUP
az group create --name $RESOURCE_GROUP --location $LOCATION

#
# Create Premium ACR for private endpoints
# Remove any non-alphanumeric characters from PREFIX and limit to 50 characters
# # Export ACR_NAME with the cleaned prefix
#

CLEAN_PREFIX=$(echo "$PREFIX" | tr -cd '[:alnum:]' | cut -c1-50)
export ACR_NAME="${CLEAN_PREFIX}acr"
echo $ACR_NAME
# Create ACR
acrOUT=$(az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Premium)
echo $acrOUT
export ACR_ID=$(echo $acrOUT | jq -r '.id')
echo $ACR_ID
#
# Cleanup any soft deleted resources
#

#
# Public Access: Enabled - Option 1
# takes time
#
az ml workspace create --name $WORKSPACE_NAME \
    --resource-group $RESOURCE_GROUP \
    --container-registry $ACR_ID \
    --public-network-access enabled 

#
# Public Access: Diabled - Option BYO VNET
# takes time

az ml workspace create --name $WORKSPACE_NAME \
    --resource-group $RESOURCE_GROUP \
    --container-registry $ACR_ID \
    --public-network-access disabled 
#
# Managed VNET (allow_internet_outbound) option 2
#

az ml workspace create --name $WORKSPACE_NAME \
    --resource-group $RESOURCE_GROUP \
    --public-network-access Disabled \
    --container-registry $ACR_ID \
    --managed-network allow_internet_outbound

# Managed VNET (allow_internet_approved_outbound) - Option 3
## ** Preview **
#--managed-network 
#  allow_internet_outbound
#  allow_only_approved_outbound 
# --verbose
# ** Preview **


az ml workspace create --name $WORKSPACE_NAME \
    --resource-group $RESOURCE_GROUP \
    --public-network-access Disabled \
    --container-registry $ACR_ID \
    --managed-network allow_only_approved_outbound 



#
# Variables for Private Endpoint for BYO and Managed VNET Only!
#
export COMMON_RESOURCE_GROUP=nnmlstudio-common-RG
PRIVATE_CONNECTION_RESOURCE_ID=$(az ml workspace show --name $WORKSPACE_NAME --resource-group $RESOURCE_GROUP --query "id" --output tsv)
echo $PRIVATE_CONNECTION_RESOURCE_ID

echo $COMMON_RESOURCE_GROUP

VNET_ID=$(az network vnet show -g $COMMON_RESOURCE_GROUP --name $VNET_NAME --query "id" --output tsv)
echo "VNET_ID: $VNET_ID"

PEP_SUBNET_ID=$(az network vnet subnet show --resource-group $COMMON_RESOURCE_GROUP --vnet-name $VNET_NAME --name $PEP_SUBNET_NAME --query "id" --output tsv)
echo "PEP_SUBNET_ID: $PEP_SUBNET_ID"

#
# Create a private endpoint (don't need this for public access)
# takes time
#
az network private-endpoint create \
    --name $PRIVATE_ENDPOINT_NAME \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $VNET_ID \
    --subnet $PEP_SUBNET_ID \
    --private-connection-resource-id $PRIVATE_CONNECTION_RESOURCE_ID \
    --group-id amlworkspace \
    --connection-name workspace \
    --location $LOCATION

# Verify the private endpoint creation
PRIVATE_ENDPOINT_ID=$(az network private-endpoint show --name $PRIVATE_ENDPOINT_NAME --resource-group $RESOURCE_GROUP --query "id" --output tsv)
echo "PRIVATE_ENDPOINT_ID: $PRIVATE_ENDPOINT_ID"

# Create DNS Zone privatelink.api.azureml.ms
az network private-dns zone create -g $RESOURCE_GROUP --name privatelink.api.azureml.ms
az network private-dns link vnet create -g $RESOURCE_GROUP --zone-name privatelink.api.azureml.ms --name ${VNET_NAME}-link --virtual-network $VNET_ID --registration-enabled false
az network private-endpoint dns-zone-group create -g $RESOURCE_GROUP --endpoint-name $PRIVATE_ENDPOINT_NAME --name myzonegroup --private-dns-zone privatelink.api.azureml.ms --zone-name privatelink.api.azureml.ms

# Create Private DNS privatelink.notebooks.azure.net
az network private-dns zone create -g $RESOURCE_GROUP --name privatelink.notebooks.azure.net
az network private-dns link vnet create -g $RESOURCE_GROUP --zone-name privatelink.notebooks.azure.net --name ${VNET_NAME}-link --virtual-network $VNET_ID --registration-enabled false
az network private-endpoint dns-zone-group add -g $RESOURCE_GROUP --endpoint-name $PRIVATE_ENDPOINT_NAME --name myzonegroup --private-dns-zone privatelink.notebooks.azure.net --zone-name privatelink.notebooks.azure.net
#
# Access ML Studio from within the Customer VNET
#

# find all storage accounts in $RESOURCE_GROUP and put it in a vaiable
STORAGE_ACCOUNTS=$(az storage account list --resource-group $RESOURCE_GROUP --query "[].name" --output tsv)
# find fqdn of the storage account
STORAGE_ACCOUNT_FQDN=$(az storage account show --name $STORAGE_ACCOUNTS --resource-group $RESOURCE_GROUP --query "primaryEndpoints.blob" --output tsv)
echo $STORAGE_ACCOUNT_FQDN

# find fqdn for keyvault in $RESOURCE_GROUP
KEYVAULT_NAME=$(az keyvault list --resource-group $RESOURCE_GROUP --query "[].name" --output tsv)
KEYVAULT_FQDN=$(az keyvault show --name $KEYVAULT_NAME --resource-group $RESOURCE_GROUP --query "properties.vaultUri" --output tsv)
echo $KEYVAULT_FQDN

# find fqdn for acr in $RESOURCE_GROUP
ACR_NAME=$(az acr list --resource-group $RESOURCE_GROUP --query "[].name" --output tsv)
ACR_FQDN=$(az acr show --name $ACR_NAME --resource-group $RESOURCE_GROUP --query "loginServer" --output tsv)
echo $ACR_FQDN
#
# Validations
#
# Public Endpoint
# Use variables in the curl command
#
dig public-endpoint.eastus.inference.ml.azure.com +short
ENDPOINT='https://public-endpoint.eastus.inference.ml.azure.com/score'
CONTENT_TYPE='application/json'
AUTHORIZATION='Bearer CmcePZXbtJsgEArUXLHbVyjBWqXcRUoH'
MODEL_DEPLOYMENT='greattonguenvsh20-1'
DATA='{
  "input_data": {
    "columns": [
      "day",
      "mnth",
      "year",
      "season",
      "holiday",
      "weekday",
      "workingday",
      "weathersit",
      "temp",
      "atemp",
      "hum",
      "windspeed"
    ],
    "index": [0],
    "data": [[1,1,2022,2,0,1,1,2,0.3,0.3,0.3,0.3]]
  }
}'

# Use variables in the curl command
curl -X POST \
  "$ENDPOINT" \
  -H "Content-Type: $CONTENT_TYPE" \
  -H "Authorization: $AUTHORIZATION" \
  -H "azureml-model-deployment: $MODEL_DEPLOYMENT" \
  -d "$DATA"

#
# Private Endpoint 
# from linux vm
#
dig private-endpoint.eastus.inference.ml.azure.com +short
ENDPOINT='https://private-endpoint.eastus.inference.ml.azure.com/score'
CONTENT_TYPE='application/json'
AUTHORIZATION='Bearer lqyDw89dyJcG84Ep1MnTzsxknuyMknx2'
MODEL_DEPLOYMENT='greattonguenvsh20-1'
DATA='{
  "input_data": {
    "columns": [
      "day",
      "mnth",
      "year",
      "season",
      "holiday",
      "weekday",
      "workingday",
      "weathersit",
      "temp",
      "atemp",
      "hum",
      "windspeed"
    ],
    "index": [0],
    "data": [[1,1,2022,2,0,1,1,2,0.3,0.3,0.3,0.3]]
  }
}'

# Use variables in the curl command
curl -X POST \
  "$ENDPOINT" \
  -H "Content-Type: $CONTENT_TYPE" \
  -H "Authorization: $AUTHORIZATION" \
  -H "azureml-model-deployment: $MODEL_DEPLOYMENT" \
  -d "$DATA"
#
#cleanup
#
# delete workspace
echo $WORKSPACE_NAME
echo $RESOURCE_GROUP
az ml workspace delete --name $WORKSPACE_NAME \
                       --resource-group $RESOURCE_GROUP\
                       --all-resources\
                       --no-wait\
                       --permanently-delete\
                       --yes

az group delete --name $RESOURCE_GROUP --yes --no-wait



#
# Future BYO PaaS Services
#
#


# create workworkspace with managed vnet and storage account,ketvault,acr

# # get the storage account id from existing storage account
# export STORAGE_ACCOUNT_NAME="nnmlstudiostorage99"
# export STORAGE_ACCOUNT_ID=$(az storage account show --name $STORAGE_ACCOUNT_NAME --resource-group $COMMON_RESOURCE_GROUP --query id --output tsv)
# echo $STORAGE_ACCOUNT_ID

# # get the keyvault id from existing keyvault
# export KEYVAULT_NAME="nnmlstudiokv99"
# export KEYVAULT_ID=$(az keyvault show --name $KEYVAULT_NAME --resource-group $COMMON_RESOURCE_GROUP --query id --output tsv)
# echo $KEYVAULT_ID

# # get the acr id from existing acr
# export ACR_NAME="nnmlstudioacr99"
# export ACR_ID=$(az acr show --name $ACR_NAME --resource-group $COMMON_RESOURCE_GROUP --query id --output tsv)
# echo $ACR_ID


# #create workspace with managed vnet and above storage,acr,keyvault

# az ml workspace create --name $WORKSPACE_NAME \
#     --resource-group $RESOURCE_GROUP \
#     --location $LOCATION \
#     --public-network-access Disabled \
#     --container-registry $ACR_ID \
#     --storage-account $STORAGE_ACCOUNT_ID \
#     --key-vault $KEYVAULT_ID \
#     --managed-network allow_internet_outbound