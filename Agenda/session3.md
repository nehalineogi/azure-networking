# Session 3: Load Balancing in Azure (The Art of the Possible)

Agenda
1. Introduction (David O'Keefe) (5 min)

2. Load Balancing in Azure: The Art of The Possible (Nehali Neogi) (30 min)

3. Azure Gateway Load Balancer: Presentation from Check Point (John Guo) (10 min)

4. Azure Front Door:  Presentation from Networking Expert (Marc De Droog) (15 min)


# [Feedback Form](https://forms.microsoft.com/r/HNhm2a7ghu)

Your feedback in important to us. Please take a few minutes survery [here](https://forms.microsoft.com/r/HNhm2a7ghu)


# FAQs


1. Meeting will be recorded and the link in the invite will also work for recording.

2. All drawio diagrams are under the diagrams folder in github repo link [here](https://github.com/nehalineogi/azure-networking)

3. Future sessions signup link [here](https://www.linkedin.com/feed/update/urn:li:activity:7024859847699365888/)

4. Gateway Load Balancer Supported Partners link [here](https://blog.checkpoint.com/2021/11/02/check-point-cloudguard-is-a-launch-partner-of-azure-gateway-load-balancer/)

4. Check Point CloudGuard link [here](https://blog.checkpoint.com/2021/11/02/check-point-cloudguard-is-a-launch-partner-of-azure-gateway-load-balancer/)

3. Useful Blog links:  

Nehali's blogs

[AKS Application Gateway Ingress Controller (AGIC)](https://github.com/nehalineogi/azure-cross-solution-network-architectures/blob/main/aks/README-ingress-appgw.md)
 
[XFF headers](https://nehalineogi.blogspot.com/2020/04/xff-headers-with-azure-front-door.html)

[Azure Front Door Premium with Private Link Service](https://github.com/nehalineogi/azure-cross-solution-network-architectures/blob/main/aks/README-private-cluster-with-AFD.md)

[VXLAN Basics](https://github.com/nehalineogi/azure-cross-solution-network-architectures/blob/main/advanced-linux-networking/linux-vxlan.md)

# Test drive demo links


## East LB


Directly going to LB East from east-VM and West VM

curl http://nneastlb.eastus.cloudapp.azure.com/

curl http://eastlb.nehalineogi.org


## West LB

Directly going to LB West from east-VM or West VM

curl http://nnwestlb.westus.cloudapp.azure.com/

curl http://westlb.nehalineogi.org

## Cross Region LB


Using crosslb From East and West VM

curl http://crosslb.nehalineogi.org

dig crosslb.nehalineogi.org +short

curl ifconfig.io (get source)

curl http://crosslb.nehalineogi.org (observer souce IP and Host Header in tcpdump)