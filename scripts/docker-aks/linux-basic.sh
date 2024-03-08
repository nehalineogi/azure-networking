



sudo -s
apt install bridge-utils
apt install net-tools

#
# Create linux bridge and type dummy interface
#

ip link add dummy-int-1 type dummy
ip link add dummy-int-2 type dummy
brctl addbr br0

#
# add dummy interface to the bridge
brctl addif br0 dummy-int-1 dummy-int-2
brctl show br0
brctl showmacs br0
ip link show

ip link set dev br0 up
ip link set dev dummy-int-1 up
ip link set dev dummy-int-2 up

# layer 3

ip addr add 192.168.25.1/24 dev br0


#
# veth pair
#

ip link add veth-int1 type veth peer name veth-int1-br
ip link add veth-int2 type veth peer name veth-int2-br

# Host side of the pair
ip link set veth-int1-br master br0
ip link set veth-int2-br master br0

# add veth pairs to the default namespace
ip link set up veth-int1
ip link set up veth-int2
ip link set up veth-int1-br
ip link set up veth-int2-br

ip addr add 192.168.25.10/24 dev veth-int1
ip addr add 192.168.25.11/24 dev veth-int2


#
# Default namespace
#
ln -s /proc/1/ns/net /var/run/netns/default
ip netns exec default ifconfig -a

nsenter -t 1 -n -- ip addr show

#
#
#
ip netns add red
ip netns add green
ip netns list
green
red
default
# 
# Connect the "container" side of the veth pair to the namespace
sudo ip link set veth-int1 netns red
sudo ip link set veth-int2 netns green


# red
sudo ip netns exec red ip addr add 192.168.25.10/24 dev veth-int1
ip netns exec red ip addr show
ip netns exec red ip link set up veth-int1

# green
sudo ip netns exec green ip addr add 192.168.25.11/24 dev veth-int2
ip netns exec green ip addr show
ip netns exec green ip link set up veth-int2


# validate between namespaces
root@docker-host-2:/home/azureuser# ip netns exec red ping 192.168.25.11
PING 192.168.25.11 (192.168.25.11) 56(84) bytes of data.
64 bytes from 192.168.25.11: icmp_seq=1 ttl=64 time=0.058 ms
64 bytes from 192.168.25.11: icmp_seq=2 ttl=64 time=0.050 ms
^C
--- 192.168.25.11 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1018ms
rtt min/avg/max/mdev = 0.050/0.054/0.058/0.004 ms
root@docker-host-2:/home/azureuser# ip netns exec green ping 192.168.25.10
PING 192.168.25.10 (192.168.25.10) 56(84) bytes of data.
64 bytes from 192.168.25.10: icmp_seq=1 ttl=64 time=0.076 ms
64 bytes from 192.168.25.10: icmp_seq=2 ttl=64 time=0.053 ms
^C
--- 192.168.25.10 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1032ms
rtt min/avg/max/mdev = 0.053/0.064/0.076/0.011 ms

#
# outbound
#
ip netns exec red ping 8.8.8.8
ip netns exec green ping 8.8.8.8

ip netns exec red  route add default gateway 192.168.25.1
ip netns exec green  route add default gateway 192.168.25.1

# ip forward
cat /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv4/conf/all/forwarding


root@docker-host-2:/home/azureuser# tcpdump -ni eth0 icmp
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
12:44:39.467645 IP 192.168.25.10 > 8.8.8.8: ICMP echo request, id 61457, seq 93, length 64
12:44:40.491687 IP 192.168.25.10 > 8.8.8.8: ICMP echo request, id 61457, seq 94, length 64
12:44:41.515633 IP 192.168.25.10 > 8.8.8.8: ICMP echo request, id 61457, seq 95, length 64

# NAT
iptables --table nat -A POSTROUTING -s 192.168.0.0/16 -j MASQUERADE

root@docker-host-2:/home/azureuser# iptables -L -n -t nat
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination

Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
MASQUERADE  all  --  192.168.0.0/16       0.0.0.0/0

root@docker-host-2:/home/azureuser# tcpdump -ni eth0 icmp
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
12:59:54.523609 IP 10.0.0.5 > 8.8.8.8: ICMP echo request, id 27281, seq 6, length 64
12:59:54.526021 IP 8.8.8.8 > 10.0.0.5: ICMP echo reply, id 27281, seq 6, length 64
12:59:55.525520 IP 10.0.0.5 > 8.8.8.8: ICMP echo request, id 27281, seq 7, length 64
12:59:55.527377 IP 8.8.8.8 > 10.0.0.5: ICMP echo reply, id 27281, seq 7, length 64
12:59:56.527044 IP 10.0.0.5 > 8.8.8.8: ICMP echo request, id 27281, seq 8, length 64
12:59:56.528890 IP 8.8.8.8 > 10.0.0.5: ICMP echo reply, id 27281, seq 8, length 64
12:59:57.528927 IP 10.0.0.5 > 8.8.8.8: ICMP echo request, id 27281, seq 9, length 64
12:59:57.531372 IP 8.8.8.8 > 10.0.0.5: ICMP echo reply, id 27281, seq 9, length 64
^C

#Inbound
ip netns exec red nc -lp 80
iptables -t nat -A PREROUTING  -i eth0 -p tcp -m tcp --dport 80 -j DNAT --to-destination 192.168.25.10:80