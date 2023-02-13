echo "net.ipv4.ip_forward = 1" > /etc/sysctl.conf
sudo sysctl -p /etc/sysctl.conf
sudo iptables -t nat -A POSTROUTING -d 10.0.0.0/8 -j ACCEPT
sudo iptables -t nat -A POSTROUTING -d 172.16.0.0/12 -j ACCEPT
sudo iptables -t nat -A POSTROUTING -d 192.168.0.0/16 -j ACCEPT
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
cat /proc/sys/net/ipv4/ip_forward

#echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.conf
#echo "net.ipv4.conf.all.send_redirects = 0" >> /etc/sysctl.conf
