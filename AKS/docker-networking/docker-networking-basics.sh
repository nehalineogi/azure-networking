#
# az login basics
#

# ssh into the docker hosts
ssh into the docker-host-1 VM
ssh into the docker-host-2 VM


#
# docker commands
#

# Display Docker version
docker version

# Display Docker system-wide information
docker info

# View running containers
docker ps

# View all containers (including stopped ones)

# List Docker images
docker images

# List Docker containers
docker container list


# Before state
ip add
docker run hello-world
docker images
docker ps
docker ps -a

# Run a container named blue1 with nginxdemos/hello image
docker run -dit --name blue1 nginxdemos/hello

# Run a container named blue2 with nginxdemos/hello image
docker run -dit --name blue2 nginxdemos/hello

# View running containers
docker ps

# Execute a shell inside the web2 container
docker exec -it blue1 sh

# Display network interfaces
ifconfig

# Ping Google's DNS server
ping 8.8.8.8

# Get public IP address using ifconfig.me
curl ifconfig.me
exit

#
# expose ports
#

# Run a container with nginxdemos/hello image and expose port 8080
docker run -dit -p 8080:80 nginxdemos/hello


#
# publish all exposed ports
#

# Run a container with nginxdemos/hello image and publish all exposed ports
docker run -dit -P nginxdemos/hello

#
# create network
#

# Show bridge control
brctl show

#
# docker host 1
#
# List Docker networks
docker network ls

docker network rm red-bridge
# Create a bridge network named red-bridge with a specific subnet
#docker network create --driver bridge red-bridge
docker network create --subnet 172.20.0.0/16 -d bridge red-bridge

# List Docker networks
docker network ls

# Run a container named red1 in the red-bridge network with nginxdemos/hello image
#docker run -dit --name red1 --network red-bridge nginxdemos/hello
# Run a container named red1 in the red-bridge network with nginxdemos/hello image and assign a specific IP address
docker run -dit --name red1 --network red-bridge --ip 172.20.1.10 nginxdemos/hello

# Run a container named red2 in the red-bridge network with nginxdemos/hello image
#docker run -dit --name red2 --network red-bridge nginxdemos/hello
docker run -dit --name red2 --network red-bridge --ip 172.20.1.11 nginxdemos/hello
#
# ******docker host 2*******
#
docker run -dit --name red3 --network red-bridge --ip 172.20.1.12 nginxdemos/hello

# Run a container named red2 in the red-bridge network with nginxdemos/hello image
#docker run -dit --name red2 --network red-bridge nginxdemos/hello
docker run -dit --name red4 --network red-bridge --ip 172.20.1.13 nginxdemos/hello
#docker network create --subnet 172.18.0.0/16 -d bridge red-bridge

# Inspect the bridge network and nn-bridge network
docker network inspect bridge red-bridge

# View running containers
docker ps

# Execute a shell inside the red1 container
docker exec -it red1 ifconfig
docker exec -it red1 sh
ping red2
docker exec -it red3 sh
ping red3 (fails)
#
# docker host 2
#
docker exec -it red3 sh

# Execute a shell inside the stoic_bell container
docker exec -it red2 ifconfig

# Dual homed container from the red2 container

# Run a container named blue3 with nginxdemos/hello image
docker run -dit --name blue3 nginxdemos/hello

# Connect the blue3 container to the red-bridge network
ping blue3 from red1
docker network connect red-bridge blue3
ping blue3 from red1

#
# Docker Hub
#

# Clean up Docker containers

# Stop all running containers
docker stop $(docker ps -aq)

# Remove all containers
docker rm $(docker ps -aq)

#
#ipvlan network
#
docker network create --driver ipvlan --subnet 10.1.1.0/24 --opt parent=eth0 --opt ipvlan_mode=l3 ipvlan-net
docker network inspect ipvlan-net
#run a container with alpine image
# attach nic on the host (secodary IP private and public)
docker run -d --net=ipvlan-net --ip=10.1.1.10 --name purple1 alpine sh -c "while true; do sleep 3600; done"
docker run -d --net=ipvlan-net --ip=10.1.1.11 --name purple2 alpine sh -c "while true; do sleep 3600; done"
#cleanup
# Stop and remove all running containers
docker stop $(docker ps -aq) && docker rm $(docker ps -aq)
docker network rm ipvlan-net

# different subnet
# allow inbound nsg on 10.1.1.5
docker network create --driver ipvlan \
    --subnet 192.168.1.0/24 --subnet 192.168.2.0/24 \
    --opt parent=eth0 \
    --opt ipvlan_mode=l3 ipvlan-net
docker network inspect ipvlan-net
# attach nic on the host (secodary IP private and public)
docker run -d --net=ipvlan-net --ip=192.168.1.10 --name purple1 alpine sh -c "while true; do sleep 3600; done"
docker run -d --net=ipvlan-net --ip=192.168.2.10 --name purple2 alpine sh -c "while true; do sleep 3600; done"
docker exec -it purple1 sh
ping purple2 (works)
ping 10.1.1.5 (works with return route and inbound NSG on destination 10.1.1.5)
ping 8.8.8.8 (needs 0/0 via NVA - NVA does the source NAT)
docker network rm ipvlan-net

