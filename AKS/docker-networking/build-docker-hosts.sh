
#!/bin/bash
#
# Build two linux VMs with docker and network tools
#

# Define common variables
export RESOURCE_GROUP_NAME=docker-rg
export LOCATION=eastus
export VM_NAME_1=docker-host-1
export VM_NAME_2=docker-host-2
export VM_IMAGE=Ubuntu2204
export ADMIN_USERNAME=azureuser
export VNET_NAME=docker-vnet
export SUBNET_NAME=docker-subnet
export VNET_ADDRESS_PREFIX=10.1.0.0/16
export SUBNET_ADDRESS_PREFIX=10.1.1.0/24
#
# Use your own public key file
#
export PUB_KEY=~/.ssh/id_rsa.pub

# Get the current public IP of the user
MY_IP=$(curl -s ifconfig.me)

# Verify Azure login
if ! az account show > /dev/null 2>&1; then
  echo "Error: Azure CLI is not logged in. Please run 'az login' to log in."
  exit 1
fi

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create virtual network
az network vnet create --resource-group $RESOURCE_GROUP_NAME --name $VNET_NAME --address-prefix $VNET_ADDRESS_PREFIX --subnet-name $SUBNET_NAME --subnet-prefix $SUBNET_ADDRESS_PREFIX

# Function to create a VM and configure NSG
create_vm() {
  local vm_name=$1
  local nsg_name="${vm_name}nsg"

  # Create VM
  az vm create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $vm_name \
    --image $VM_IMAGE \
    --admin-username $ADMIN_USERNAME \
    --ssh-key-values $PUB_KEY \
    --public-ip-sku Standard \
    --vnet-name $VNET_NAME \
    --subnet $SUBNET_NAME \
    --custom-data cloud-init.txt \
    --verbose

  # Create NSG
  az network nsg create --resource-group $RESOURCE_GROUP_NAME --name $nsg_name

  # Allow port 22 from YOUR IP
  az network nsg rule create --resource-group $RESOURCE_GROUP_NAME --nsg-name $nsg_name --name AllowSSH --protocol tcp --priority 1000 --destination-port-range 22 --source-address-prefixes $MY_IP --access allow

  # Allow port 8080 from YOUR IP
  az network nsg rule create --resource-group $RESOURCE_GROUP_NAME --nsg-name $nsg_name --name AllowHTTP --protocol tcp --priority 1010 --destination-port-range 8080 --source-address-prefixes $MY_IP --access allow

  # Associate NSG with VM's network interface
  local nic_name=$(az vm show --resource-group $RESOURCE_GROUP_NAME --name $vm_name --query "networkProfile.networkInterfaces[0].id" --output tsv | xargs -n 1 basename)
  az network nic update --resource-group $RESOURCE_GROUP_NAME --name $nic_name --network-security-group $nsg_name
}

# Create cloud-init file for custom script
cat <<EOF > cloud-init.txt
#cloud-config
package_update: true
packages:
  - net-tools
  - docker.io
runcmd:
  - sudo usermod -aG docker $ADMIN_USERNAME
EOF

# Create VMs
create_vm $VM_NAME_1
create_vm $VM_NAME_2


# Retrieve and echo the public IP addresses and SSH commands
VM1_IP=$(az vm show --resource-group $RESOURCE_GROUP_NAME --name $VM_NAME_1 --show-details --query [publicIps] --output tsv)
VM2_IP=$(az vm show --resource-group $RESOURCE_GROUP_NAME --name $VM_NAME_2 --show-details --query [publicIps] --output tsv)

echo "VM1 Public IP: $VM1_IP"
echo "SSH into VM1: ssh $ADMIN_USERNAME@$VM1_IP"

echo "VM2 Public IP: $VM2_IP"
echo "SSH into VM2: ssh $ADMIN_USERNAME@$VM2_IP"