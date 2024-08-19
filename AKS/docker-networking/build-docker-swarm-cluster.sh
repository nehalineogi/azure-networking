# Check Docker version
docker --version

# Run a test Docker container
docker run hello-world

# Display IP addresses
ip add

# Initialize Docker Swarm with a specific advertise address
docker swarm init --advertise-addr 10.1.1.4

# # On host 2:
# # Join Docker Swarm with a specific token and manager address
# docker swarm join --token SWMTKN-1-44y444jxuk8h0d9ret8hdw4cgdu6i8vl5ji15khf7d4d8vwic2-cphnsx5g4y3dne2ivzuqfg3yb 10.1.1.4:2377

# List Docker nodes in the swarm
docker node ls
docker network ls
docker service ls

# local docker0 bridge
docker run -dit --name demo1 nginxdemos/hello
docker exec -it demo1 sh


# Verify the Docker overlay network
docker ps
docker network ls
#
# /etc/docker/daemon.json (custom address-pools)
#
docker network inspect ingress overlay
#
# Create an attachable overlay network
# Optional : docker network create --driver overlay --attachable green-overlay
#
docker network create --driver overlay --subnet 172.21.0.0/16 green-overlay 
docker network ls
docker network inspect ingress green-overlay


# Create a Docker service with Nginx demo, 2 replicas, and map port 8080
docker service create --name nn-nginx --replicas 2 -p 8080:80 nginxdemos/hello
docker service rm nn-nginx
docker service create --name nn-nginx --replicas 2 -p 8080:80 --network green-overlay nginxdemos/hello

# List running Docker containers
docker ps
docker service ls

# Execute a shell inside a specific container
docker exec -it 67db75e5378b ifconfig
docker exec -it eaffe29bba5d sh

# Outbound Get public IP address
curl ifconfig.me

# Inbound:
curl <VM1_IP>:8080
curl <VM2_IP>:8080
curl 52.142.46.112:8080 | grep address
curl 20.185.44.30:8080 | grep address


# East west and overlay

# Display IP addresses
ip add
ping container on the other docker host
#
# run tcpdump on the host - vxlan packets
#
 sudo tcpdump -vv -ni eth0 port 4789



# cleanup

export RESOURCE_GROUP_NAME=docker-rg
echo $RESOURCE_GROUP_NAME
az group delete --name $RESOURCE_GROUP_NAME --yes --no-wait

#remove docker network
docker network rm green-overlay

